package org.example.roomly.controller;


import org.example.roomly.model.*;
import org.example.roomly.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.text.SimpleDateFormat;
import java.util.*;


@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private ReservationService reservationService;

    @Autowired
    private PaymentService paymentService;

    @Autowired
    private WorkspaceService workspaceService;

    @Autowired
    private CreditCardService creditCardService;

    // hello endpoint
    @GetMapping("/hello")
    public ResponseEntity<String> hello() {
        return ResponseEntity.ok("Hello, World!");
    }

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
        if (response.startsWith("Email") || response.startsWith("Password") || response.startsWith("Passwords")) {
            responseBody.put("error", response);
            responseBody.put("registrationStatus", false);
        } else {
            responseBody.put("userId", response);
            responseBody.put("registrationStatus", true);
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
            responseBody.put("user",userService.getUserById(id));
        } else {
            responseBody.put("error", response);
            responseBody.put("profileCompletionStatus", false);
        }

        return ResponseEntity.ok(responseBody);
    }

    @PostMapping("/auth/login")
    public ResponseEntity<Map<String, Object>> logIn(@RequestBody LogInRequest logInRequest) {
        System.out.println("Logging in........");
        Map<String, Object> result = userService.logIn(
                logInRequest.getEmail(),
                logInRequest.getPassword(),
                logInRequest.isStaff()
        );

        Map<String, Object> response = new HashMap<>();
        if (result == null) {
            response.put("error", "Wrong Credentials");
        } else {
            response.put("user", result.get("user"));
            response.put("token", result.get("token"));
        }
        return ResponseEntity.ok(response);
    }

    @PostMapping("/auth/continue-google")
    public ResponseEntity<Map<String,Object>> googleAuth(@RequestBody GoogleUser googleUser){
        return ResponseEntity.ok(userService.logInWithGoogle(googleUser));
    }

    // for password reset
    @PostMapping("/auth/forgot-password")
    public ResponseEntity<Map<String, Object>> forgotPassword(@RequestBody ForgotPasswordRequest request) {
        String response = userService.initiatePasswordReset(request.getEmail());

        Map<String, Object> responseBody = new HashMap<>();
        if (response.equals("OTP sent to your email")) {
            responseBody.put("message", response);
            responseBody.put("status", true);
        } else {
            responseBody.put("error", response);
            responseBody.put("status", false);
        }
        return ResponseEntity.ok(responseBody);
    }

    @PostMapping("/auth/verify-reset-otp")
    public ResponseEntity<Map<String, Object>> verifyResetOtp(@RequestBody VerifyOtpRequest request) {
        String response = userService.verifyPasswordResetOtp(request.getEmail(), request.getOtp());

        Map<String, Object> responseBody = new HashMap<>();
        if (response.equals("OTP verified successfully")) {
            responseBody.put("message", response);
            responseBody.put("status", true);
        } else {
            responseBody.put("error", response);
            responseBody.put("status", false);
        }
        return ResponseEntity.ok(responseBody);
    }

    @PostMapping("/auth/reset-password")
    public ResponseEntity<Map<String, Object>> resetPassword(@RequestBody ResetPasswordRequest request) {
        String response = userService.resetPassword(request.getEmail(), request.getNewPassword());

        Map<String, Object> responseBody = new HashMap<>();
        if (response.equals("Password updated successfully")) {
            responseBody.put("message", response);
            responseBody.put("status", true);
        } else {
            responseBody.put("error", response);
            responseBody.put("status", false);
        }
        return ResponseEntity.ok(responseBody);
    }

    @GetMapping("/get-info")
    public ResponseEntity<User> getUser(@RequestParam String id){
        User response =  userService.getUserById(id);
        return ResponseEntity.ok(response);
    }

//    @PutMapping("/update-user")
//    public ResponseEntity<String> updateUser(@RequestBody User user){
//        if(userService.updateUser(user)){
//            return ResponseEntity.ok("updated successfully");
//        }
//        return ResponseEntity.ok("not updated");
//    }

    @PutMapping("/update-user")
    public ResponseEntity<String> updateUser(@RequestBody Map<String, Object> updates) {
        // Get the user ID from the updates
        String id = (String) updates.get("id");
        if (id == null) {
            return ResponseEntity.badRequest().body("User ID is required");
        }

        // Remove email and password from updates if present
        updates.remove("email");
        updates.remove("password");

        if (userService.updateUserPartial(id, updates)) {
            return ResponseEntity.ok("updated successfully");
        }
        return ResponseEntity.ok("not updated");
    }

    @DeleteMapping("/delete")
    public ResponseEntity<String> deleteUser(@RequestParam String id){
        if(userService.deleteUser(id)){
            return ResponseEntity.ok("deleted successfully");
        }
        return ResponseEntity.ok("not found");
    }

    @PostMapping("/add-favorites")
    public ResponseEntity<String> addToFavorites(
            @RequestParam String workspaceId,
            @RequestParam String userId,
            @RequestParam String roomId) {

        workspaceService.addToFavourites(workspaceId, userId, roomId);
        return ResponseEntity.ok("added successfully");
    }

//    @GetMapping("/get-favorites")
//    public ResponseEntity<List<Map<String, String>>> getFavorites(@RequestParam String userId) {
//        return ResponseEntity.ok(workspaceService.getFavoriteWorkspaceRooms(userId));
//    }

//    @GetMapping("/get-favorites")
//    public ResponseEntity<List<Map<String, String>>> getFavorites(@RequestParam String userId) {
//        List<Map<String, String>> favoriteRooms = workspaceService.getFavoriteWorkspaceRooms(userId);
//        // loop over each favorite room and if workspace is not null, set the workspace Id
//        for (Map<String, String> room : favoriteRooms) {
//            String workspaceId = room.get("workspaceId");
//            // check if workspaceId is null or empty
//            if (workspaceId.isEmpty() || workspaceId == null) {
//                // use Workspace getWorkspacesByRoomId(String roomId) to set the workspaceId
//                Workspace workspace = workspaceService.getWorkspacesByRoomId(room.get("roomId"));
//                workspaceId = workspace.getId();
//            }
//            if (workspaceId != null) {
//                room.put("workspaceId", workspaceId);
//            } else {
//                room.put("workspaceId", null);
//            }
//        }
//        return ResponseEntity.ok(favoriteRooms);
//    }

    @GetMapping("/get-favorites")
    public ResponseEntity<List<Map<String, String>>> getFavorites(@RequestParam String userId) {
        List<Map<String, String>> favoriteRooms = workspaceService.getFavoriteWorkspaceRooms(userId);

        if (favoriteRooms == null) {
            return ResponseEntity.ok(Collections.emptyList());
        }

        for (Map<String, String> room : favoriteRooms) {
            String workspaceId = room.get("workspaceId");
            String roomId = room.get("roomId");

            // Skip if roomId is missing
            if (roomId == null) {
                continue;
            }

            // If workspaceId is missing or empty, try to find it
            if (workspaceId == null || workspaceId.isEmpty()) {
                Workspace workspace = workspaceService.getWorkspacesByRoomId(roomId);
                if (workspace != null) {
                    room.put("workspaceId", workspace.getId());
                } else {
                    room.put("workspaceId", null); // or consider removing the entry
                }
            }
        }

        return ResponseEntity.ok(favoriteRooms);
    }

    @PostMapping("/add-favorite-room")
    public ResponseEntity<String> addFavoriteRoom(
            @RequestParam String userId,
            @RequestParam String roomId) {

        boolean added = workspaceService.addFavoriteWorkspaceRoom(userId, roomId);
        if (!added) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Failed to add favorite room");
        }
        return ResponseEntity.ok("added successfully");
    }

    @DeleteMapping("/remove-favorite-room")
    public ResponseEntity<String> removeFromFavorites(
            @RequestParam String userId,
            @RequestParam String roomId) {

        boolean deleted = workspaceService.deleteFavoriteWorkspaceRoom(userId, roomId);
        if (!deleted) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("not found");
        }
        return ResponseEntity.ok("removed successfully");
    }

    @PostMapping("/add-favorite-workspace")
    public ResponseEntity<String> addFavoriteWorkspace(
            @RequestParam String userId,
            @RequestParam String workspaceId) {

        boolean added = workspaceService.addFavoriteWorkspace(userId, workspaceId);
        if (!added) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Failed to add favorite workspace");
        }
        return ResponseEntity.ok("added successfully");
    }

    @DeleteMapping("/remove-favorite-workspace")
    public ResponseEntity<String> removeFavoriteWorkspace(
            @RequestParam String userId,
            @RequestParam String workspaceId) {

        boolean deleted = workspaceService.deleteFavoriteWorkspace(userId, workspaceId);
        if (!deleted) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("not found");
        }
        return ResponseEntity.ok("removed successfully");
    }

    @GetMapping("/username")
    public ResponseEntity<Map<String, String>> getUserName(@RequestParam String userId) {
        User user = userService.getUserById(userId);
        if (user == null) {
            return ResponseEntity.notFound().build();
        }

        Map<String, String> response = new HashMap<>();
        response.put("name", user.getFirstName() + " " + user.getLastName());

        return ResponseEntity.ok(response);
    }

}
