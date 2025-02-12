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
    
    @Autowired
    private ReservationService reservationService;

    @Autowired
    private PaymentService paymentService;

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
    @PostMapping("/reserve")
    public void createReservation(@RequestBody Map<String, Object> reservationData) {
        System.out.println("Received reservation: " + reservationData);

        try {
            // Extract data
            String userId = (String) reservationData.get("userId");
            String workspaceId = (String) reservationData.get("workspaceId");
            String roomId = (String) reservationData.get("roomId");
            String paymentMethod = (String) reservationData.get("paymentMethod");
            int amenitiesCount = (Integer) reservationData.get("amenitiesCount");

            // Parse dates
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
            Date startTime = dateFormat.parse((String) reservationData.get("startTime"));
            Date endTime = dateFormat.parse((String) reservationData.get("endTime"));


            // Generate random total cost
            Random random = new Random();
            double totalCost = 15 + (9999 - 15) * random.nextDouble();

            // Create payment and reservation
            Payment payment = paymentService.createPayment(paymentMethod, totalCost, PaymentStatus.CONFIRMED);
            Reservation reservation = reservationService.createReservation(startTime, endTime, totalCost, ReservationStatus.CONFIRMED, payment);

            // Save payment and reservation
            reservationService.saveReservation(reservation);
            paymentService.savePayment(payment, reservation.getId());
            reservationService.addBooking(userId, reservation.getId(), workspaceId, roomId);

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to process reservation: " + e.getMessage());
        }
    }
}

