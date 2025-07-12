package org.example.roomly.service;

import org.example.roomly.model.*;
import org.example.roomly.utils.SimpleJwtUtil;
import org.springframework.stereotype.Service;

import org.example.roomly.repository.CustomerRepository;
import org.example.roomly.repository.WorkspaceStaffRepository;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.*;

@Service
public class UserService {

    @Autowired
    private CustomerRepository customerRepository;

    @Autowired
    private WorkspaceStaffRepository workspaceStaffRepository;

    @Autowired
    private AuthenticationService authenticationService;

    @Autowired
    private SimpleJwtUtil jwtUtil;

    private final Map<Integer, User> pendingUsers = new HashMap<Integer, User>(); // Temp storage for unverified users
    private final Random random = new Random();

    private final Map<String, User> profileUsers = new HashMap<String, User>();

    private final Map<String, Integer> passwordResetOtpMap = new HashMap<>(); // Stores email-OTP pairs
    private final Map<String, String> emailToUserIdMap = new HashMap<>(); // Stores email-userId pairs


    public String registerUser(String firstName, String lastName, String email, String password, String confirmPassword, String phone, boolean isStaff) {
        System.out.println("Registering user from User Service ...");
        // Validate email
        if (authenticationService.checkEmail(email)) {
            System.out.println("Email already exists.");
            return "Email already exists.";
        }

        // Validate password
        if (!authenticationService.validatePassword(password)) {
            System.out.println("Password does not meet security requirements.");
            return "Password does not meet security requirements.\n" +
                    "Password must contain at least 10 characters, including at least one uppercase letter, one lowercase letter, one number, and one special character.";
        }

        // Confirm passwords match
        if (!authenticationService.confirmPassword(password, confirmPassword)) {
            System.out.println("Passwords do not match.");
            return "Passwords do not match.";
        }

        // Generate verification token
        String id = UUID.randomUUID().toString();

        // Generate 6-digit OTP
        int otp = 100000 + random.nextInt(900000); // Ensures a 6-digit OTP


        // Create user object
        User user;
        if (isStaff) {
            user = new WorkspaceStaff(id, firstName, lastName, email, password, phone, WorkspaceStaffType.DEFAULT);
            System.out.println("Staff user created.");
        } else {
            user = new Customer(id, firstName, lastName, email, password, phone, "Default Address");
            System.out.println("Customer user created.");
        }

        // print user data
        System.out.println("User Data: " + user.toString());

        // Store user temporarily for complete profile data
        profileUsers.put(id, user);

        // Store user temporarily
        pendingUsers.put(otp, user);
        System.out.println("User stored temporarily.");
        System.out.println("Verification OTP: " + otp);

        // Send confirmation email with otp
        authenticationService.sendVerificationEmail(email, otp);

        System.out.println("OTP sent to your email. Please verify to complete registration.");
        return user.getId();
    }

    public String verifyUser(int otp) {
        if (!pendingUsers.containsKey(otp)) {
            System.out.println("Invalid or expired verification link.");
            return "Invalid or expired verification link.";
        }

        User user = pendingUsers.remove(otp); // Remove from pending users

        // Save user to the appropriate repository
        if (user instanceof WorkspaceStaff) {
            System.out.println("Saving staff user...");
            workspaceStaffRepository.save((WorkspaceStaff) user);
        } else if (user instanceof Customer) {
            System.out.println("Saving customer user...");
            customerRepository.save((Customer) user);
        }

        System.out.println("Account verified successfully! You can now log in.");
        return "Account verified successfully! You can now log in.";
    }

    public String completeUserProfile(String id, String firstName, String lastName, String phone, String Address) {
        if (!profileUsers.containsKey(id)) {
            System.out.println("User not found.");
            return "User not found.";
        }

        // Validate phone number
        if (!authenticationService.validatePhoneNumber(phone)) {
            System.out.println("Invalid Egyptian phone number.");
            return "Invalid Egyptian phone number.";
        }

        Customer user = (Customer) profileUsers.get(id);
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setPhone(phone);
        user.setAddress(Address);

        // update user in the repository
        customerRepository.update(user);

        System.out.println("User profile completed successfully!");
        return "User profile completed successfully!";
    }

    // Update your login method
    public Map<String, Object> logIn(String email, String password, boolean isStaff) {
        Map<String, Object> response = new HashMap<>();

        try {
            if (isStaff) {
                WorkspaceStaff staff = workspaceStaffRepository.findByEmail(email);
                if (staff != null && staff.getPassword().equals(password)) {
                    String token = jwtUtil.generateToken(email, staff.getId());
                    response.put("user", staff);
                    response.put("token", token);
                    return response;
                }
            } else {
                Customer customer = customerRepository.findByEmail(email);
                if (customer != null && customer.getPassword().equals(password)) {
                    String token = jwtUtil.generateToken(email, customer.getId());
                    response.put("user", customer);
                    response.put("token", token);
                    return response;
                }
            }
        } catch (Exception e) {
            // Log the error if needed
        }

        return null;
    }

    public Map<String, Object> logInWithGoogle(GoogleUser googleUser){
        Customer customer;
        customer = customerRepository.findByEmail(googleUser.getEmail());
        if(customer==null){
            System.out.println("add new google user");
             customer = new Customer(googleUser.getId(), googleUser.getFirstName(), googleUser.getLastName(), googleUser.getEmail(), "googlUserPassword","","");
            customerRepository.save(customer);
        }
        else{
            System.out.println("this user already exist!");
        }
        Map<String,Object> response = new HashMap<>();
        String token = jwtUtil.generateToken(googleUser.getEmail(), googleUser.getId());
        response.put("user", customer);
        response.put("token", token);
        return response;
    }

    // for the password reset
    public String initiatePasswordReset(String email) {
        // Check if email exists
        boolean emailExists = authenticationService.checkEmail(email);
        if (!emailExists) {
            return "Email not found";
        }

        // Generate 6-digit OTP
        int otp = 100000 + random.nextInt(900000);

        // Store OTP and email mapping
        passwordResetOtpMap.put(email, otp);

        // Send OTP via email
        authenticationService.sendPasswordResetEmail(email, otp);

        return "OTP sent to your email";
    }

    public String verifyPasswordResetOtp(String email, int otp) {
        // Check if OTP matches
        if (!passwordResetOtpMap.containsKey(email) || passwordResetOtpMap.get(email) != otp) {
            return "Invalid OTP";
        }

        // OTP is valid, store email for password reset
        emailToUserIdMap.put(email, getUserIdByEmail(email));
        passwordResetOtpMap.remove(email); // Remove used OTP

        return "OTP verified successfully";
    }

    public String resetPassword(String email, String newPassword) {
        // Validate password
        if (!authenticationService.validatePassword(newPassword)) {
            return "Password does not meet security requirements";
        }

        // Check if email is authorized for password reset
        if (!emailToUserIdMap.containsKey(email)) {
            return "Unauthorized password reset request";
        }

        String userId = emailToUserIdMap.get(email);

        // Update password in database
        if (customerRepository.existsByEmail(email)) {
            Customer customer = customerRepository.findByEmail(email);
            customer.setPassword(newPassword);
            customerRepository.update(customer);
        } else if (workspaceStaffRepository.existsByEmail(email)) {
            WorkspaceStaff staff = workspaceStaffRepository.findByEmail(email);
            staff.setPassword(newPassword);
            workspaceStaffRepository.update(staff);
        } else {
            return "User not found";
        }

        // Clean up
        emailToUserIdMap.remove(email);

        return "Password updated successfully";
    }

    private String getUserIdByEmail(String email) {
        if (customerRepository.existsByEmail(email)) {
            return customerRepository.findByEmail(email).getId();
        } else if (workspaceStaffRepository.existsByEmail(email)) {
            return workspaceStaffRepository.findByEmail(email).getId();
        }
        return null;
    }
    //Function create user and staff is already exist (Register function)
    //Create find by id (Read User)
    public  User getUserById(String id){
        if(customerRepository.existsById(id)){
            Customer customer = customerRepository.findById(id);
            return customer;
        }
        else if(workspaceStaffRepository.existsById(id)){
            return workspaceStaffRepository.findById(id);
        }
        return null;
    }
    public  User getUserByEmail(String email){
        if(customerRepository.existsByEmail(email)){
            Customer customer = customerRepository.findByEmail(email);
            return customer;
        }
        else if(workspaceStaffRepository.existsByEmail(email)){
            return workspaceStaffRepository.findByEmail(email);
        }
        return null;
    }

    //Create Update function
    public boolean updateUser(User user){
        if(customerRepository.existsById(user.getId())){
            customerRepository.update((Customer) user);
            return true;
        }
        else if (workspaceStaffRepository.existsById(user.getId())){
            workspaceStaffRepository.update((WorkspaceStaff) user);
            return true;
        }
        return false;
    }

    public boolean updateUserPartial(String id, Map<String, Object> updates) {
        User user = getUserById(id);
        if (user == null) {
            return false;
        }

        // Apply updates to the user object
        if (updates.containsKey("firstName")) {
            user.setFirstName((String) updates.get("firstName"));
        }
        if (updates.containsKey("lastName")) {
            user.setLastName((String) updates.get("lastName"));
        }
        if (updates.containsKey("phone")) {
            user.setPhone((String) updates.get("phone"));
        }

        // Handle Customer-specific field
        if (user instanceof Customer && updates.containsKey("address")) {
            ((Customer) user).setAddress((String) updates.get("address"));
        }

        // Handle WorkspaceStaff-specific field
        if (user instanceof WorkspaceStaff && updates.containsKey("type")) {
            try {
                WorkspaceStaffType type = WorkspaceStaffType.valueOf((String) updates.get("type"));
                ((WorkspaceStaff) user).setType(type);
            } catch (IllegalArgumentException e) {
                // Invalid type value, skip this update
            }
        }

        // Save the updated user
        return updateUser(user);
    }

    public boolean deleteUser(String id){
        if(customerRepository.existsById(id)){
            customerRepository.deleteById(id);
            return true;
        }
        else if(workspaceStaffRepository.existsById(id)){
            workspaceStaffRepository.deleteById(id);
            return true;
        }
        return false;
    }

    public void blockUser(String staffId, String userId){
        workspaceStaffRepository.blockUser(staffId,userId);
    }

    public void unblockUser(String staffId, String userId){
        workspaceStaffRepository.unblockUser(staffId,userId);
    }

    public List<String> getBlockedUsers(String staffId) {
        return workspaceStaffRepository.getBlockedUsers(staffId);
    }

}


