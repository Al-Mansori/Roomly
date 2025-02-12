package org.example.roomly.controller;


import org.example.roomly.model.LogInRequest;
import org.example.roomly.model.RegistrationRequest;
import org.example.roomly.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    @PostMapping("/auth/register")
    public ResponseEntity<String> registerUser(@RequestBody RegistrationRequest request) {
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

        return ResponseEntity.ok(response);
    }

    @GetMapping("/auth/verify")
    public ResponseEntity<String> verifyUser(@RequestParam String token) {
        System.out.println("Verifying user from User Controller ...");
        String response = userService.verifyUser(token);

        System.out.println("Response from Controller : " + response);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/auth/login")
    public ResponseEntity<String> logIn(@RequestBody LogInRequest logInRequest){
        System.out.println("Logging in........");
        String response = userService.LogIn(logInRequest.getEmail(),logInRequest.getPassword(),logInRequest.isStaff());
        return ResponseEntity.ok(response);
    }
}