package org.example.roomly.service;

import org.springframework.stereotype.Service;

import org.example.roomly.model.Customer;
import org.example.roomly.model.User;
import org.example.roomly.model.WorkspaceStaff;
import org.example.roomly.model.WorkspaceStaffType;
import org.example.roomly.repository.CustomerRepository;
import org.example.roomly.repository.WorkspaceStaffRepository;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;
import java.util.UUID;

@Service
public class UserService {

    @Autowired
    private CustomerRepository customerRepository;

    @Autowired
    private WorkspaceStaffRepository workspaceStaffRepository;

    @Autowired
    private AuthenticationService authenticationService;

    private final Map<Integer, User> pendingUsers = new HashMap<Integer, User>(); // Temp storage for unverified users
    private final Random random = new Random();

    private final Map<String, User> profileUsers = new HashMap<String, User>();


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

    public User logIn(String email , String password, boolean isStaff){
        if(isStaff){
            if(authenticationService.checkEmail(email)){
                WorkspaceStaff workspaceStaff = workspaceStaffRepository.findByEmail(email);
                if(workspaceStaff.getPassword().equals(password)){
                    return workspaceStaff;
                }
                else{
                    return null;
                }
            }
            else{
                return null;
            }
        }
        else{
            if(authenticationService.checkEmail(email)){
                Customer customer = customerRepository.findByEmail(email);
                if(customer.getPassword().equals(password)){
                    return customer;
                }
                else{
                    return null;
                }
            }
            else{
                return null;
            }

        }
    }
}
