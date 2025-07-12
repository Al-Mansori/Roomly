package org.example.roomly.service;

import org.example.roomly.repository.CustomerRepository;
import org.example.roomly.repository.WorkspaceStaffRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.regex.Pattern;

@Service
public class AuthenticationService {

    @Autowired
    private CustomerRepository customerRepository;

    @Autowired
    private WorkspaceStaffRepository workspaceStaffRepository;

    @Autowired
    private EmailSenderService emailSenderService;

    public boolean checkEmail(String email) {
        return customerRepository.existsByEmail(email) || workspaceStaffRepository.existsByEmail(email);
    }

    public boolean validatePassword(String password) {
        String pattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@#$%^&+=!])(?=\\S+$).{10,}$";
        return Pattern.matches(pattern, password);
    }

    public boolean confirmPassword(String password, String confirmPassword) {
        return password.equals(confirmPassword);
    }

    public boolean validatePhoneNumber(String phone) {
        String egyptianPhonePattern = "^(010|011|012|015)\\d{8}$";
        return Pattern.matches(egyptianPhonePattern, phone);
    }

    public void sendVerificationEmail(String email, int otp) {
        // Simulate sending an email (replace this with actual email sending logic)
        System.out.println("Sending email to: " + email);
        System.out.println("Your OTP for verification: " + otp);

        // Send email
        emailSenderService.sendMail(email, "Roomly Account Verification", "Your OTP for verification: " + otp);

        System.out.println("Email sent successfully to: " + email);
    }

    public void sendPasswordResetEmail(String email, int otp) {
        String subject = "Password Reset OTP";
        String body = "Your OTP for password reset is: " + otp + "\nThis OTP is valid for 10 minutes.";
        emailSenderService.sendMail(email, subject, body);
    }
}
