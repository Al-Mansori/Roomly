package org.example.roomly.controller;


import org.example.roomly.model.*;
import org.example.roomly.service.PaymentService;
import org.example.roomly.service.ReservationService;
import org.example.roomly.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;


@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private ReservationService reservationService;

    @Autowired
    private PaymentService paymentService;

    @PostMapping("/auth/register-customer")
    public ResponseEntity<Map<String, Object>> registerCustomer(@RequestBody Map<String, Object> request) {

        System.out.println("Registering Customer from User Controller ...");

        // Extracting values from the request body
        String email = (String) request.get("email");
        String password = (String) request.get("password");
        String confirmPassword = (String) request.get("confirmPassword");
        boolean isStaff = Boolean.parseBoolean(request.get("isStaff").toString());

        System.out.println("Is Staff: " + isStaff);

        String response = userService.registerUser(
                null,  // First Name (Not Provided)
                null,  // Last Name (Not Provided)
                email,
                password,
                confirmPassword,
                null,  // Phone (Not Provided)
                isStaff
        );

        System.out.println("Response from Controller: " + response);

        Map<String, Object> responseBody = new HashMap<>();

        if (response.startsWith("Email") || response.startsWith("Password") || response.startsWith("Passwords")) {
            responseBody.put("error", response);
            responseBody.put("registrationStatus", false);

        } else {
            responseBody.put("userId", response);
            responseBody.put("registrationStatus", true);
        }

        return ResponseEntity.ok(responseBody);
    }

    @PostMapping("/auth/register-staff")
    public ResponseEntity<Map<String, Object>> registerStaff(@RequestBody RegistrationRequest request) {
        System.out.println("Registering user from User Controller ...");
        System.out.println("Print IsSteff: " + request.isStaff());

        String response = userService.registerUser(
                request.getFirstName(),
                request.getLastName(),
                request.getEmail(),
                request.getPassword(),
                request.getConfirmPassword(),
                request.getPhone(),
                request.isStaff()
        );

        System.out.println("Response from Controller : " + response);

        Map<String, Object> responseBody = new HashMap<>();
        if (response.startsWith("OTP sent")) {
            responseBody.put("message", response);
            responseBody.put("registrationStatus", true);
        } else {
            responseBody.put("error", response);
            responseBody.put("registrationStatus", false);
        }

        return ResponseEntity.ok(responseBody);
    }

    @PostMapping("/auth/verify")
    public ResponseEntity<Map<String, Object>> verifyUser(@RequestParam int otp) {
        System.out.println("Verifying user from User Controller ...");

        String response = userService.verifyUser(otp);

        System.out.println("Response from Controller : " + response);

        Map<String, Object> responseBody = new HashMap<>();
        if (response.startsWith("Account verified")) {
            responseBody.put("message", response);
            responseBody.put("registrationStatus", true);
        } else {
            responseBody.put("error", response);
            responseBody.put("registrationStatus", false);
        }

        return ResponseEntity.ok(responseBody);
    }

    @PostMapping("/auth/complete-profile")
    public ResponseEntity<Map<String, Object>> completeUserProfile(@RequestBody Map<String, Object> request) {
        System.out.println("Completing user profile from User Controller ...");

        String id = (String) request.get("id");
        String firstName = (String) request.get("firstName");
        String lastName = (String) request.get("lastName");
        String phone = (String) request.get("phone");
        String address = (String) request.get("address");

        String response = userService.completeUserProfile(
                id,
                firstName,
                lastName,
                phone,
                address
        );

        System.out.println("Response from Controller : " + response);

        Map<String, Object> responseBody = new HashMap<>();
        if (response.startsWith("User profile completed")) {
            responseBody.put("message", response);
            responseBody.put("profileCompletionStatus", true);
        } else {
            responseBody.put("error", response);
            responseBody.put("profileCompletionStatus", false);
        }

        return ResponseEntity.ok(responseBody);
    }

    @PostMapping("/auth/login")
    public ResponseEntity<Map<String, Object>> logIn(@RequestBody LogInRequest logInRequest){
        System.out.println("Logging in........");
        User result = userService.logIn(logInRequest.getEmail(),logInRequest.getPassword(),logInRequest.isStaff());
        Map<String , Object> response = new HashMap<>();
        if(result == null){
            response.put("Error","Wrong Credentials");
        }
        else{
            response.put("User",result);
        }
        return ResponseEntity.ok(response);
    }
}
