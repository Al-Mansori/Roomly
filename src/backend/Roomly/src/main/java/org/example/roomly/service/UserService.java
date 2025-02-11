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
import java.util.UUID;

@Service
public class UserService {

    @Autowired
    private CustomerRepository customerRepository;

    @Autowired
    private WorkspaceStaffRepository workspaceStaffRepository;

    @Autowired
    private AuthenticationService authenticationService;

    private final Map<String, User> pendingUsers = new HashMap<>(); // Temp storage for unverified users

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

        // Validate phone number
        if (!authenticationService.validatePhoneNumber(phone)) {
            System.out.println("Invalid Egyptian phone number.");
            return "Invalid Egyptian phone number.";
        }

        // Generate verification token
        String token = UUID.randomUUID().toString();

        // Create user object
        User user;
        if (isStaff) {
            user = new WorkspaceStaff(token, firstName, lastName, email, password, phone, WorkspaceStaffType.DEFAULT);
            System.out.println("Staff user created.");
        } else {
            user = new Customer(token, firstName, lastName, email, password, phone, "Default Address");
            System.out.println("Customer user created.");
        }

        // Store user temporarily
        pendingUsers.put(token, user);
        System.out.println("User stored temporarily.");
        System.out.println("Verification token: " + token);
        System.out.println("Verification link: http://localhost:8080/api/users/auth/verify?token=" + token);

        // Send confirmation email with verification link
        String verificationLink = "http://localhost:8080/api/users/auth/verify?token=" + token;
        authenticationService.sendVerificationEmail(email, verificationLink);

        System.out.println("Registration initiated. Please check your email for verification.");
        return "Registration initiated. Please check your email for verification.";
    }

    public String verifyUser(String token) {
        if (!pendingUsers.containsKey(token)) {
            System.out.println("Invalid or expired verification link.");
            return "Invalid or expired verification link.";
        }

        User user = pendingUsers.remove(token); // Remove from pending users

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
}
