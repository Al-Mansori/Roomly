package org.example.roomly.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.example.roomly.model.*;
import org.example.roomly.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.context.annotation.RequestScope;

import java.io.Serializable;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

@RestController
@RequestMapping("api/customer")
public class CustomerController {

    @Autowired
    private ImageService imageService;

    @Autowired
    private WorkspaceService workspaceService;

    @Autowired
    private RoomService roomService;

    @Autowired
    private AmenityService amenityService;

    @Autowired
    private ReservationService reservationService;

    @Autowired
    private PaymentService paymentService;

    @Autowired
    private ReviewService reviewService;

    @Autowired
    private RequestService requestService;

    @Autowired
    private LoyaltyPointsService loyaltyPointsService;

    @Autowired
    private CreditCardService creditCardService;

    @Autowired
    private LocationService locationService;

    @Autowired
    private PreferenceService preferenceService;

    @Autowired
    private WorkspacePlanService workspacePlanService;

    @Autowired
    private RoomAvailabilityService roomAvailabilityService;

    @GetMapping("/images/workspace")
    public List<Image> getWorkspaceImages(@RequestParam String workspaceId) {
        return imageService.getWorkspaceImages(workspaceId);
    }

    @GetMapping("/images/room")
    public List<Image> getRoomImages(@RequestParam String roomId) {
        return imageService.getRoomImages(roomId);
    }

    @GetMapping("/images/amenity")
    public List<Image> getAmenityImages(@RequestParam String amenityId) {
        return imageService.getAmenityImages(amenityId);
    }

    @GetMapping("/home")
    public List<Workspace> getHome(){
        List<Workspace> workspaces = workspaceService.getAllWorkspaces().subList(0,5);
        for (Workspace workspace: workspaces) {
            workspace.setWorkspaceImages(imageService.getWorkspaceImages(workspace.getId()));
        }
        return workspaces;
    }

    @GetMapping("/workspace/details")
    public Workspace getWorkspaceDetails(@RequestParam String workspaceId){
        Workspace workspace = workspaceService.getWorkspaceById(workspaceId);
        workspace.setWorkspaceImages(imageService.getWorkspaceImages(workspaceId));
        List<Room> rooms = roomService.getRoomsByWorkspaceId(workspaceId);
        for (Room room: rooms) {
            room.setRoomImages(imageService.getRoomImages(room.getId()));
        }
        workspace.setRooms(rooms);
        return workspace;
    }

    @GetMapping("/room/details")
    public Room getRoomDetails(@RequestParam String roomId){
        Room room = roomService.getRoomById(roomId);
        room.setRoomImages(imageService.getRoomImages(roomId));
        List<Amenity> amenities = amenityService.getAmenitiesByRoomId(roomId);
        for (Amenity amenity: amenities) {
            amenity.setAmenityImages(imageService.getAmenityImages(amenity.getId()));
        }
        room.setAmenities(amenities);
        return room;
    }

//    @PostMapping("/reserve")
//    public ResponseEntity<Map<String, Object>> createReservation(
//            @RequestParam String paymentMethod,
//            @RequestParam int amenitiesCount,
//            @RequestParam String startTime,
//            @RequestParam(required = false) String endTime,
//            @RequestParam ReservationType reservationType,
//            @RequestParam String userId,
//            @RequestParam String workspaceId,
//            @RequestParam String roomId) {
//
//        try {
//            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
//            Date start = dateFormat.parse(startTime);
//            Date end = null;
//
//            // Get room and workspace info
//            Room room = roomService.getRoomById(roomId);
//            String actualWorkspaceId = roomService.getWorkspaceIdByRoomId(roomId);
//
//            // Handle DAILY reservations
//            if (reservationType == ReservationType.DAILY) {
//                // Get operating hours for this workspace on the reservation day
//                Map<String, Date> operatingHours =
//                        reservationService.getWorkspaceOperatingHours(actualWorkspaceId, start);
//
//                start = operatingHours.get("startTime");
//                end = operatingHours.get("endTime");
//
//                // For private rooms, reserve all seats
//                if (room.getType() == RoomType.PRIVATE ||
//                        room.getType() == RoomType.MEETING ||
//                        room.getType() == RoomType.SEMINAR) {
//                    amenitiesCount = room.getCapacity();
//                }
//            } else {
//                // HOURLY reservation requires endTime
//                if (endTime == null || endTime.isEmpty()) {
//                    return ResponseEntity.badRequest()
//                            .body(Map.of("message", "End time is required for hourly reservations"));
//                }
//                end = dateFormat.parse(endTime);
//            }
//
//            // Check availability
//            if (!reservationService.checkAvailability(roomId, start, end, amenitiesCount)) {
//                return ResponseEntity.status(HttpStatus.CONFLICT)
//                        .body(Map.of("message", "Room not available for requested time slot"));
//            }
//
//            // Calculate cost based on reservation type
//            double totalCost;
//            if (reservationType == ReservationType.DAILY) {
//                // Get daily price from workspace plan
//                WorkspacePlan plan = workspacePlanService.findByWorkspaceId(actualWorkspaceId);
//                if (room.getType() == RoomType.PRIVATE ||
//                        room.getType() == RoomType.MEETING ||
//                        room.getType() == RoomType.SEMINAR) {
//                        totalCost = plan.getDailyPrice();
//                }
//                else{
//                    totalCost = plan.getDailyPrice() * amenitiesCount;
//                }
//            } else {
//                // Hourly pricing
//                long diffInMillis = end.getTime() - start.getTime();
//                long reservedHours = TimeUnit.MILLISECONDS.toHours(diffInMillis);
//
//                if (room.getType() == RoomType.PRIVATE ||
//                        room.getType() == RoomType.MEETING ||
//                        room.getType() == RoomType.SEMINAR) {
//                    totalCost = room.getPricePerHour() * reservedHours;
//                }
//                else{
//                    totalCost = room.getPricePerHour() * amenitiesCount * reservedHours;
//                }
//            }
//
//            // Create payment and reservation
//            Payment payment = paymentService.createPayment(paymentMethod, totalCost, PaymentStatus.PENDING);
//            Reservation reservation = reservationService.createReservation(start, end, totalCost,
//                    ReservationStatus.PENDING, amenitiesCount, payment, reservationType);
//
//            // Update availability
//            reservationService.updateAvailability(roomId, start, end, amenitiesCount, true);
//
//            // Save payment and reservation
//            reservationService.saveReservation(reservation);
//            paymentService.savePayment(payment, reservation.getId());
//            reservationService.saveBooking(userId, reservation.getId(), workspaceId, roomId);
//
//            // Update user preferences
//            Preference preference = preferenceService.getPreferenceByUserId(userId);
//            if (preference != null) {
//                preference.setBudgetPreference("50-" + totalCost);
//                preference.setWorkspaceTypePreference(workspaceService.getWorkspaceById(workspaceId).getType());
//                preferenceService.updatePreference(preference.getBudgetPreference(),
//                        preference.getWorkspaceTypePreference(),
//                        userId);
//            } else {
//                preferenceService.savePreference("50-" + totalCost,
//                        workspaceService.getWorkspaceById(workspaceId).getType(),
//                        userId);
//            }
//
//            return ResponseEntity.ok(Map.of(
//                    "message", "Successful reservation",
//                    "reservationId", reservation.getId(),
//                    "startTime", dateFormat.format(start),
//                    "endTime", dateFormat.format(end)
//            ));
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
//                    .body(Map.of("message", "Failed to process reservation: " + e.getMessage()));
//        }
//    }

    @PostMapping("/reserve")
    public ResponseEntity<Map<String, Object>> createReservation(
            @RequestParam String paymentMethod,
            @RequestParam int amenitiesCount,
            @RequestParam String startTime,
            @RequestParam(required = false) String endTime,
            @RequestParam ReservationType reservationType,
            @RequestParam String userId,
            @RequestParam String workspaceId,
            @RequestParam String roomId,
            @RequestParam(required = false) Integer loyaltyPoints) {

        try {
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
            Date start = dateFormat.parse(startTime);
            Date end = null;

            // Get room and workspace info
            Room room = roomService.getRoomById(roomId);

            // For private rooms, reserve all seats
            if (room.getType() == RoomType.PRIVATE ||
                    room.getType() == RoomType.MEETING ||
                    room.getType() == RoomType.SEMINAR) {
                amenitiesCount = room.getCapacity();
            }

            // Handle DAILY reservations
            if (reservationType == ReservationType.DAILY) {
                // Get operating hours for this workspace on the reservation day
                Map<String, Date> operatingHours =
                        reservationService.getWorkspaceOperatingHours(workspaceId, start,true);

                start = operatingHours.get("startTime");
                end = operatingHours.get("endTime");

            } else {
                // HOURLY reservation requires endTime
                if (endTime == null || endTime.isEmpty()) {
                    return ResponseEntity.badRequest()
                            .body(Map.of("message", "End time is required for hourly reservations"));
                }
                end = dateFormat.parse(endTime);
            }

            // Check availability
            if (!reservationService.checkAvailability(roomId, start, end, amenitiesCount)) {
                return ResponseEntity.status(HttpStatus.CONFLICT)
                        .body(Map.of("message", "Room not available for requested time slot"));
            }

            // Calculate cost based on reservation type
            double totalCost;
            if (reservationType == ReservationType.DAILY) {
                // Get daily price from workspace plan
                WorkspacePlan plan = workspacePlanService.findByWorkspaceId(workspaceId);
                if (room.getType() == RoomType.PRIVATE ||
                        room.getType() == RoomType.MEETING ||
                        room.getType() == RoomType.SEMINAR) {
                    totalCost = plan.getDailyPrice();
                }
                else{
                    totalCost = plan.getDailyPrice() * amenitiesCount;
                }
            } else {
                // Hourly pricing
                long diffInMillis = end.getTime() - start.getTime();
                long reservedHours = TimeUnit.MILLISECONDS.toHours(diffInMillis);

                if (room.getType() == RoomType.PRIVATE ||
                        room.getType() == RoomType.MEETING ||
                        room.getType() == RoomType.SEMINAR) {
                    totalCost = room.getPricePerHour() * reservedHours;
                }
                else{
                    totalCost = room.getPricePerHour() * amenitiesCount * reservedHours;
                }
            }

            // Handle loyalty points if provided
            if (loyaltyPoints != null && loyaltyPoints > 0) {
                // Check if user wants to use loyalty points for full payment
                if (loyaltyPoints < totalCost) {
                    return ResponseEntity.badRequest()
                            .body(Map.of("message", "Loyalty points must cover the full reservation cost. Required: " + totalCost +
                                    ", Provided: " + loyaltyPoints));
                }

                // Verify user has enough points
                LoyaltyPoints userLoyalty = loyaltyPointsService.getLoyalty(userId);
                if(userLoyalty == null){
                    loyaltyPointsService.createLoyalty(userId,0);
                }

                if (userLoyalty == null || userLoyalty.getTotalPoints() < totalCost) {
                    return ResponseEntity.badRequest()
                            .body(Map.of("message", "Insufficient loyalty points. Required: " + totalCost +
                                    ", Available: " + (userLoyalty != null ? userLoyalty.getTotalPoints() : 0)));
                }

                // Deduct points from user's account
                loyaltyPointsService.deductPoints(userId, (int) Math.ceil(totalCost));

                // Set payment method to LOYALTY and amount to 0
                paymentMethod = "LOYALTY";
                totalCost = 0; // Full amount covered by points
            }

            // Create payment and reservation
            Payment payment = paymentService.createPayment(paymentMethod, totalCost,
                    totalCost == 0 ? PaymentStatus.COMPLETED : PaymentStatus.PENDING);
            Reservation reservation = reservationService.createReservation(start, end, totalCost,
                    ReservationStatus.PENDING, amenitiesCount, payment, reservationType);

            // Update availability
            reservationService.updateAvailability(roomId, start, end, amenitiesCount, true);

            // Save payment and reservation
            reservationService.saveReservation(reservation);
            paymentService.savePayment(payment, reservation.getId());
            reservationService.saveBooking(userId, reservation.getId(), workspaceId, roomId);

            try {
                Preference preference = preferenceService.getPreferenceByUserId(userId);

                if (preference != null) {
                    preference.setBudgetPreference("50-" + totalCost);
                    preference.setWorkspaceTypePreference(workspaceService.getWorkspaceById(workspaceId).getType());
                    preferenceService.updatePreference(
                            preference.getBudgetPreference(),
                            preference.getWorkspaceTypePreference(),
                            userId
                    );
                } else {
                    // Create new preferences if none exist
                    preferenceService.savePreference(
                            "50-" + totalCost,
                            workspaceService.getWorkspaceById(workspaceId).getType(),
                            userId
                    );
                }
            } catch (EmptyResultDataAccessException e) {
                // Handle case where no preference exists
                preferenceService.savePreference(
                        "50-" + totalCost,
                        workspaceService.getWorkspaceById(workspaceId).getType(),
                        userId
                );
            }

            Map<String, Object> response = new HashMap<>();
            response.put("message", "Successful reservation");
            response.put("reservationId", reservation.getId());
            response.put("startTime", dateFormat.format(start));
            response.put("endTime", dateFormat.format(end));

            if (loyaltyPoints != null && loyaltyPoints > 0) {
                response.put("loyaltyPointsUsed", loyaltyPoints);
                response.put("discountApplied", Math.min(loyaltyPoints, totalCost + Math.min(loyaltyPoints, totalCost)));
                response.put("finalAmount", totalCost);
            }

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("message", "Failed to process reservation: " + e.getMessage()));
        }
    }


    @PutMapping("/CancelReservation")
    public ResponseEntity<String> cancelReservation(
            @RequestParam String reservationId,
            @RequestParam String userId) {

        Reservation reservation = reservationService.getReservation(reservationId);
        if (reservation == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body("Reservation not found");
        }

        Map<String, Object> booking = reservationService.getBooking(userId, reservationId);
        if (booking == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body("Booking not found");
        }

        String roomId = (String) booking.get("RoomId");

        // Update availability
        reservationService.updateAvailability(roomId,
                reservation.getStartTime(),
                reservation.getEndTime(),
                reservation.getAmenitiesCount(),
                false);

        // Update reservation status
        reservation.setStatus(ReservationStatus.CANCELLED);
        reservationService.updateReservation(reservation);

        Timestamp cancellationDate = Timestamp.valueOf(LocalDateTime.now());
        double fees = 999.999 ;
        reservationService.CancelReservation(fees, cancellationDate, userId, reservationId);

        return ResponseEntity.ok("Canceled Successfully");
    }

//    @PostMapping("/review")
//    public String addReview(@RequestParam double rating, @RequestParam String comment, @RequestParam String userId, @RequestParam String workspaceId) {
//        Review review = reviewService.createReview(rating, comment);
//        reviewService.saveReview(review, userId, workspaceId);
//        return ("Review added successfully");
//    }
    @PostMapping("/review")
    public String addReview(@RequestParam double rating, @RequestParam String comment,
                            @RequestParam String userId, @RequestParam String workspaceId) {
        Review review = reviewService.createReview(rating, comment, userId);
        reviewService.saveReview(review, userId, workspaceId);

        // Update workspace average rating
        workspaceService.updateWorkspaceAverageRating(workspaceId);

        return "Review added successfully";
    }

    @GetMapping("/review")
    public Review getReview(@RequestParam String id) {
        return reviewService.getReviewById(id);
    }


    @GetMapping("/WorkspaceReviews")
    public List<Review> getWorkspaceReviews(@RequestParam String workspaceId){
        return reviewService.getWorkspaceReviews(workspaceId);
    }

    @PutMapping("/review")
    public String updateReview(@RequestBody Review review) {
        reviewService.updateReview(review);
        return "Review updated successfully";
    }

    @DeleteMapping("/review")
    public String deleteReview(@RequestParam String id) {
        reviewService.deleteReview(id);
        return "Review deleted successfully";
    }

    @GetMapping("/request")
    public Request getRequest(@RequestParam String requestId) {
        return requestService.findRequestById(requestId);
    }

    @PostMapping("/request")
    public String sendRequest(@RequestParam String type, @RequestParam String details, @RequestParam String userId, @RequestParam String staffId) {
        Request request = requestService.createRequest(type, details);
        requestService.saveRequest(request);
        requestService.saveUserRequesting(userId,request.getId(),staffId);
        return "Send Successfully";
    }

    @PutMapping("/request")
    public String updateRequest(@RequestBody Request updatedRequest) {
        requestService.updateRequest(updatedRequest);
        return "Updated Successfully";
    }

    @DeleteMapping("/request")
    public String cancelRequest(@RequestParam String requestId) {
        Request request = requestService.findRequestById(requestId);
        request.setStatus(RequestStatus.CANCELLED);
        requestService.updateRequest(request);
        return "Canceled Successfully";
    }

//    @GetMapping("/requests")
//    public List<Request> getAllRequests(@RequestParam String userId) {
//        return requestService.findAllRequestsByUserId(userId);
//    }


    // ───────────────────────────────────────────────────────────────────────────
    // 1) CREATE a new Loyalty record (for a given userId + initial points)
    // ───────────────────────────────────────────────────────────────────────────
    @PostMapping("/loyalty")
    public String createLoyalty(
            @RequestParam("userId") String userId,
            @RequestParam("points") int points)
    {
        boolean created = loyaltyPointsService.createLoyalty(userId, points);
        if (created) {
            return "Loyalty record created for userId=" + userId;
        } else {
            return "Loyalty record already exists for userId=" + userId;
        }
    }

    // ───────────────────────────────────────────────────────────────────────────
    // 2) DELETE (cancel) a Loyalty record by userId
    // ───────────────────────────────────────────────────────────────────────────
    @DeleteMapping("/loyalty")
    public String deleteLoyalty(@RequestParam("userId") String userId) {
        loyaltyPointsService.deleteLoyalty(userId);
        return "Loyalty record deleted for userId=" + userId;
    }

    // ───────────────────────────────────────────────────────────────────────────
    // 3) ADD points to an existing Loyalty record
    // ───────────────────────────────────────────────────────────────────────────
    @PutMapping("/loyalty/addPoints")
    public String addLoyaltyPoints(
            @RequestParam("userId") String userId,
            @RequestParam("points") int points)
    {
        // If no record exists, you might get a NullPointerException inside the service.
        // You can choose to check existence first or let service handle it.
        loyaltyPointsService.addPoints(userId, points);
        return "Added " + points + " points to userId=" + userId;
    }

    // ───────────────────────────────────────────────────────────────────────────
    // 4) Get Points for a given userId
    // ───────────────────────────────────────────────────────────────────────────
    @GetMapping("/loyalty/points")
    public Map<String, Serializable> getLoyaltyPoints(@RequestParam("userId") String userId) {
        LoyaltyPoints loyaltyPoints = loyaltyPointsService.getLoyalty(userId);
        // get current data
        Date currentDate = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");

        if (loyaltyPoints != null) {
            return Map.of(
                    "totalPoints", loyaltyPoints.getTotalPoints(),
                    "lastAddedPoint", loyaltyPoints.getLastAddedPoint(),
                    "lastUpdatedDate", loyaltyPoints.getLastUpdatedDate().toString()
            );
        } else {
            return Map.of(
                    "totalPoints", 0,
                    "lastAddedPoint", 0,
                    "lastUpdatedDate", sdf.format(currentDate),
                    "message", "No loyalty record found for this user"
            );
        }
    }

    // User reservations endpoints
    @GetMapping("/reservations/user/{userId}")
    public List<Map<String, Object>> getUserReservations(@PathVariable String userId) {
        return reservationService.getUserReservationsWithBooking(userId);
    }

    @GetMapping("/reservations/user/{userId}/cancelled")
    public List<Map<String, Object>> getUserCancelledReservations(@PathVariable String userId) {
        // You might want to create a similar method for cancelled reservations
        return reservationService.getUserReservationsWithBooking(userId)
                .stream()
                .filter(entry -> {
                    Reservation reservation = (Reservation) entry.get("reservation");
                    return reservation.getStatus() == ReservationStatus.CANCELLED;
                })
                .collect(Collectors.toList());
    }


    // -- Oppad Pay --

//    @PostMapping("/pay")
//    public ResponseEntity<String> pay(
//            @RequestParam String reservationId,
//            @RequestParam String userId,
//            @RequestParam String cardNumber,
//            @RequestParam String cvv) {
//
//        // First check if reservation exists and is not already completed
//        Reservation reservation = reservationService.getReservation(reservationId);
//        if (reservation == null) {
//            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Reservation not found");
//        }
//
//        if (reservation.getStatus() == ReservationStatus.COMPLETED) {
//            return ResponseEntity.badRequest().body("Reservation is already completed");
//        }
//
//        // Check if payment exists or create a new one
//        boolean paymentExists = true;
//        Payment payment = paymentService.getByReservation(reservationId);
//
//        if (payment == null) {
//            paymentExists = false;
//            payment = new Payment(
//                    UUID.randomUUID().toString(),
//                    "credit",
//                    new Date(),
//                    reservation.getTotalCost(),
//                    PaymentStatus.PENDING
//            );
//        }
//
//        // Get user's cards and verify the specific card with CVV
//        List<UserCard> userCards = creditCardService.getByUserId(userId);
//        UserCard userCard = userCards.stream()
//                .filter(card -> card.getCardNumber().equals(cardNumber))
//                .findFirst()
//                .orElse(null);
//
//        if (userCard == null) {
//            if (!paymentExists) {
//                paymentService.savePayment(payment, reservationId);
//            }
//            return ResponseEntity.badRequest().body("Credit card not found for this user");
//        }
//
//        // Verify CVV for this card
//        if (!creditCardService.isCreditReliable(cardNumber, cvv, null)) {
//            if (!paymentExists) {
//                paymentService.savePayment(payment, reservationId);
//            }
//            return ResponseEntity.badRequest().body("Invalid CVV for this card");
//        }
//
//        // Check balance and process payment
//        boolean hasFunds = creditCardService.pay(userCard.getCardNumber(), reservation.getTotalCost());
//
//        if (!hasFunds) {
//            if (!paymentExists) {
//                paymentService.savePayment(payment, reservationId);
//            }
//            return ResponseEntity.badRequest().body("Insufficient balance");
//        }
//
//        // Update reservation and payment status
//        reservation.setStatus(ReservationStatus.COMPLETED);
//        reservationService.updateReservation(reservation);
//        payment.setStatus(PaymentStatus.COMPLETED);
//
//        if (!paymentExists) {
//            paymentService.savePayment(payment, reservationId);
//        } else {
//            paymentService.updatePayment(payment);
//        }
//
//        return ResponseEntity.ok("Payment processed successfully");
//    }

    // -- Mostafa Pay --
    @PostMapping("/pay")
    public ResponseEntity<Map<String,Object>> pay(
            @RequestParam String reservationId,
            @RequestParam String userId,
            @RequestParam String cardNumber,
            @RequestParam String cvv,
            @RequestParam String paymentMethod) {  // Added paymentMethod parameter
        Map<String,Object> response = new HashMap<>();

        try {
            // First check if reservation exists
            Reservation reservation = reservationService.getReservation(reservationId);
            if (reservation == null) {
                response.put("message","Reservation not found");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
            }

            // Check if reservation is already completed or cancelled
            if (reservation.getStatus() == ReservationStatus.COMPLETED || reservation.getStatus() == ReservationStatus.CANCELLED || reservation.getStatus() == ReservationStatus.CONFIRMED) {
                Payment payment = paymentService.getByReservation(reservationId);
                Map<String, Object> booking = reservationService.getBooking(userId, reservationId);
                Room room = roomService.getRoomById(booking.get("RoomId").toString());
                Workspace workspace = workspaceService.getWorkspaceById(booking.get("WorkspaceId").toString());
                response.put("RoomName",room.getName());
                response.put("RoomId",room.getId());
                response.put("RoomType",room.getType());
                response.put("RoomPricePerHour",room.getPricePerHour());
                response.put("WorkspaceName",workspace.getName());
                response.put("WorkspaceId",workspace.getId());
                response.put("WorkspaceType",workspace.getType());
                response.put("PaymentId",payment.getId());
                response.put("ReservationId",reservationId);
                response.put("amenities",reservation.getAmenitiesCount());
                response.put("Date",payment.getPaymentDate());
                response.put("total",payment.getAmount());
                response.put("paymentMethod",payment.getPaymentMethod());
                response.put("AccessCode",reservation.getAccessCode());
                response.put("Status",reservation.getStatus());

                return ResponseEntity.badRequest().body(response);
            }
            //  Canceled and complete reservation are the same
//            if (reservation.getStatus() == ReservationStatus.CANCELLED) {
//                return ResponseEntity.badRequest().body("Cannot pay for a cancelled reservation");
//            }

            // Get the associated payment or create a new one if it doesn't exist
            Payment payment = paymentService.getByReservation(reservationId);
            if (payment == null) {
                payment = paymentService.createPayment(paymentMethod, reservation.getTotalCost(), PaymentStatus.PENDING);
                paymentService.savePayment(payment, reservationId);
            } else {
                // Update payment method if it's different
                payment.setPaymentMethod(paymentMethod);
                paymentService.updatePayment(payment);
            }

            // Additional check for CASH payments
            if (paymentMethod.equalsIgnoreCase("CASH")) {
                List<UserCard> userCards = creditCardService.getByUserId(userId);
                if (userCards.isEmpty()) {
                    response.put("message","Cash payment requires having a credit card on file");
                    return ResponseEntity.badRequest().body(response);
                }

                // Check if any card has at least 20% of the reservation price
                double requiredAmount = reservation.getTotalCost() * 0.2;
                boolean hasSufficientCredit = userCards.stream()
                        .anyMatch(card -> creditCardService.checkBalance(card.getCardNumber(), requiredAmount));

                if (!hasSufficientCredit) {
                    response.put("message","Cash payment requires having a credit card with at least 20% of the reservation price (" + requiredAmount + ")");
                    return ResponseEntity.badRequest().body(response);
                }
            }

            // For CARD payments, proceed with the normal payment flow
            if (paymentMethod.equalsIgnoreCase("CARD")) {
                // Verify user owns the credit card
                List<UserCard> userCards = creditCardService.getByUserId(userId);
                UserCard userCard = userCards.stream()
                        .filter(card -> card.getCardNumber().equals(cardNumber))
                        .findFirst()
                        .orElse(null);

                if (userCard == null) {
                    response.put("message","Credit card not found for this user");
                    return ResponseEntity.badRequest().body(response);
                }

                // Verify CVV for this card
                if (!creditCardService.isCreditReliable(cardNumber, cvv, null)) {
                    response.put("message","Invalid CVV for this card");
                    return ResponseEntity.badRequest().body(response);
                }

                // Check if user has sufficient balance
                if (!creditCardService.checkBalance(cardNumber, reservation.getTotalCost())) {
                    payment.setStatus(PaymentStatus.DENIED);
                    paymentService.updatePayment(payment);
                    response.put("message","Insufficient balance to complete payment");
                    return ResponseEntity.badRequest().body(response);
                }

                // Process payment - deduct amount from card
                boolean paymentSuccess = creditCardService.pay(cardNumber, reservation.getTotalCost());
                if (!paymentSuccess) {
                    payment.setStatus(PaymentStatus.DENIED);
                    paymentService.updatePayment(payment);
                    response.put("message","Payment processing failed");
                    return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
                }
            }

            // Update reservation and payment status
            reservation.setStatus(ReservationStatus.CONFIRMED);
            payment.setStatus(PaymentStatus.COMPLETED);

            reservationService.updateReservation(reservation);
            paymentService.updatePayment(payment);

            // Get the room and update its availability
            Map<String, Object> booking = reservationService.getBooking(userId, reservationId);
            if (booking != null) {
                String roomId = (String) booking.get("RoomId");
                Room room = roomService.getRoomById(roomId);

                // For private/seminar/meeting rooms, set available count to 0
                if (room.getType() == RoomType.PRIVATE || room.getType() == RoomType.SEMINAR || room.getType() == RoomType.MEETING) {
                    room.setAvailableCount(0);
                    room.setStatus(RoomStatus.UNAVAILABLE);
                } else {
                    // For other room types, reduce by amenities count
                    room.setAvailableCount(room.getAvailableCount() - reservation.getAmenitiesCount());
                    if (room.getAvailableCount() == 0) {
                        room.setStatus(RoomStatus.UNAVAILABLE);
                    }
                }
                roomService.updateRoom(room);
            }
            if(booking==null){
                response.put("message","booking not found");
                return ResponseEntity.badRequest().body(response);
            }
            // Update loyalty points if applicable
            LoyaltyPoints loyaltyPoints = loyaltyPointsService.getLoyalty(userId);
            if (loyaltyPoints != null) {
                // Add points based on the reservation cost
                int pointsToAdd = 5;
                loyaltyPointsService.addPoints(userId, pointsToAdd);
            } else {
                // Create a new loyalty record if it doesn't exist
                loyaltyPointsService.createLoyalty(userId, 5);
            }
            Room room = roomService.getRoomById(booking.get("RoomId").toString());
            Workspace workspace = workspaceService.getWorkspaceById(booking.get("WorkspaceId").toString());
            response.put("RoomName",room.getName());
            response.put("RoomId",room.getId());
            response.put("RoomType",room.getType());
            response.put("RoomPricePerHour",room.getPricePerHour());
            response.put("WorkspaceName",workspace.getName());
            response.put("WorkspaceId",workspace.getId());
            response.put("WorkspaceType",workspace.getType());
            response.put("PaymentId",payment.getId());
            response.put("ReservationId",reservationId);
            response.put("amenities",reservation.getAmenitiesCount());
            response.put("Date",payment.getPaymentDate());
            response.put("total",payment.getAmount());
            response.put("paymentMethod",payment.getPaymentMethod());
            response.put("AccessCode",reservation.getAccessCode());
            response.put("Status",reservation.getStatus());

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            response.put("message","An error occurred during payment processing: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(response);
        }
    }


    @GetMapping("/checkCredit")
    public ResponseEntity<String> checkIfHasCredit(@RequestParam String userId) {
        if(!creditCardService.hasCreditCard(userId)) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Credit card not found");
        }
        return ResponseEntity.ok("Has credit card");
    }

    @PostMapping("/add-credit")
    public ResponseEntity<String> addNewCreditCard(@RequestBody CreditCard creditCard){
        if(creditCardService.isCreditReliable(creditCard.getCardNumber(), creditCard.getCvv(), creditCard.getEndDate()))
        {
            UserCard userCard = new UserCard(creditCard.getUserId(), creditCard.getCardNumber());
            creditCardService.createCard(userCard);
            return ResponseEntity.ok("added successfully");
        }

        return ResponseEntity.badRequest().body("Wrong credential");
    }

    @GetMapping("/checkBalance")
    public ResponseEntity<String> checkBalance(@RequestParam String userId, @RequestParam String cardNumber, @RequestParam double amount){
        List<UserCard> userCards = creditCardService.getByUserId(userId);
        // Check if the user has any credit cards
        if(userCards.isEmpty()){
            return ResponseEntity.badRequest().body("No credit card found for this user");
        }
        // Find the specific card by card number
        UserCard userCard = userCards.stream()
                .filter(card -> card.getCardNumber().equals(cardNumber))
                .findFirst()
                .orElse(null);

        if(userCard == null){
            return ResponseEntity.badRequest().body("Credit Not found");
        }
        if(creditCardService.checkBalance(userCard.getCardNumber(), amount)){
            return ResponseEntity.ok("valid balance");
        }
        return ResponseEntity.badRequest().body("invalid balance");
    }

    @GetMapping("/get-credit-cards")
    public ResponseEntity<List<UserCard>> getCreditCards(@RequestParam String userId) {
        List<UserCard> userCards = creditCardService.getByUserId(userId);
        if (userCards.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Collections.emptyList());
        }
        return ResponseEntity.ok(userCards);
    }

    @GetMapping("/location/city/{city}")
    public ResponseEntity<List<Location>> getLocationsByCity(@PathVariable String city) {
        List<Location> locations = locationService.getLocationsByCity(city);
        return locations.isEmpty() ?
                ResponseEntity.status(HttpStatus.NOT_FOUND).body(Collections.emptyList()) :
                ResponseEntity.ok(locations);
    }

    @GetMapping("/location/town/{town}")
    public ResponseEntity<List<Location>> getLocationsByTown(@PathVariable String town) {
        List<Location> locations = locationService.getLocationsByTown(town);
        return locations.isEmpty() ?
                ResponseEntity.status(HttpStatus.NOT_FOUND).body(Collections.emptyList()) :
                ResponseEntity.ok(locations);
    }

    @GetMapping("/location/country/{country}")
    public ResponseEntity<List<Location>> getLocationsByCountry(@PathVariable String country) {
        List<Location> locations = locationService.getLocationsByCountry(country);
        return locations.isEmpty() ?
                ResponseEntity.status(HttpStatus.NOT_FOUND).body(Collections.emptyList()) :
                ResponseEntity.ok(locations);
    }

    // Add this method to CustomerController
    @GetMapping("/workspaces/location/{locationId}")
    public ResponseEntity<List<Workspace>> getWorkspacesByLocation(@PathVariable String locationId) {
        List<Workspace> workspaces = workspaceService.getWorkspacesByLocationId(locationId);
        for (Workspace workspace : workspaces) {
            workspace.setWorkspaceImages(imageService.getWorkspaceImages(workspace.getId()));
        }
        return workspaces.isEmpty() ?
                ResponseEntity.status(HttpStatus.NOT_FOUND).body(Collections.emptyList()) :
                ResponseEntity.ok(workspaces);
    }

    // Get a specific reservation by ID (with ownership check)
    @GetMapping("/reservation/{reservationId}")
    public ResponseEntity<Map<String,Object>> getReservationDetails(
            @PathVariable String reservationId,
            @RequestParam String userId,
            @RequestParam int points) {
        Map<String,Object> response = new HashMap<>();
        Reservation reservation = reservationService.getReservation(reservationId);
        if (reservation == null) {
            return ResponseEntity.notFound().build();
        }

        // Verify user owns this reservation
        boolean userHasReservation = reservationService.getUserReservations(userId).stream()
                .anyMatch(r -> r.getId().equals(reservationId));

        if (!userHasReservation) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        if (reservation.getStatus() != ReservationStatus.CONFIRMED) {
            response.put("message","Reservation is not eligible for points redemption");
            return ResponseEntity.badRequest().body(response);
        }

        LoyaltyPoints loyaltyPoints = loyaltyPointsService.getLoyalty(userId);
        if (loyaltyPoints == null) {
            response.put("message","Loyalty account not found");
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
        }

        if (loyaltyPoints.getTotalPoints() < points) {
            response.put("message","Insufficient loyalty points");
        }
        // Calculate discount (1 point = 1 currency unit)
        double totalCost = reservation.getTotalCost();
        int maxDiscount = (int) Math.floor(totalCost);
        int pointsToRedeem = Math.min(points, maxDiscount);

        if (pointsToRedeem == 0) {
            response.put("message","No points redeemed. Reservation cost too low.");
        }

        double discount = pointsToRedeem;
        double newTotalCost = totalCost - discount;

        // Update records
        reservation.setTotalCost(newTotalCost);
        Payment payment = paymentService.getByReservation(reservationId);
        if(payment != null){
            payment.setAmount(newTotalCost);
            paymentService.updatePayment(payment);
        }

        loyaltyPoints.setTotalPoints(loyaltyPoints.getTotalPoints() - pointsToRedeem);
        loyaltyPoints.setLastUpdatedDate(new Date());
        // Persist changes
        reservationService.updateReservation(reservation);
        loyaltyPointsService.updateLoyalty(loyaltyPoints);

        ObjectMapper mapper = new ObjectMapper();
        Map<String, Object> map = mapper.convertValue(reservation, Map.class);
        response.putAll(map);
        return ResponseEntity.ok(response);
    }

    // Update a reservation (customer)
    @PutMapping("/reservation")
    public ResponseEntity<Reservation> updateReservation(
            @RequestBody Reservation reservation,
            @RequestParam String userId) {

        // Verify user owns this reservation
        boolean userHasReservation = reservationService.getUserReservations(userId).stream()
                .anyMatch(r -> r.getId().equals(reservation.getId()));

        if (!userHasReservation) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }

        reservationService.updateReservation(reservation);
        return ResponseEntity.ok(reservation);
    }


    @PostMapping("/redeem")
    public ResponseEntity<String> redeemPoints(
            @RequestParam String userId,
            @RequestParam String reservationId,
            @RequestParam int points) {

        // Validate points input
        if (points <= 0) {
            return ResponseEntity.badRequest().body("Points must be a positive integer");
        }

        // Verify reservation ownership
        Map<String, Object> booking = reservationService.getBooking(userId, reservationId);
        if (booking == null) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Reservation does not belong to user");
        }

        // Get reservation and payment
        Reservation reservation = reservationService.getReservation(reservationId);
        if (reservation == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Reservation not found");
        }

        Payment payment = paymentService.getByReservation(reservationId);
        if (payment == null) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Payment record not found");
        }

        // Validate reservation state
        if (reservation.getStatus() != ReservationStatus.CONFIRMED ||
                payment.getStatus() != PaymentStatus.CONFIRMED) {
            return ResponseEntity.badRequest().body("Reservation is not eligible for points redemption");
        }

        // Get loyalty points
        LoyaltyPoints loyaltyPoints = loyaltyPointsService.getLoyalty(userId);
        if (loyaltyPoints == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Loyalty account not found");
        }

        // Check sufficient points
        if (loyaltyPoints.getTotalPoints() < points) {
            return ResponseEntity.badRequest().body("Insufficient loyalty points");
        }

        // Calculate discount (1 point = 1 currency unit)
        double totalCost = reservation.getTotalCost();
        int maxDiscount = (int) Math.floor(totalCost);
        int pointsToRedeem = Math.min(points, maxDiscount);

        if (pointsToRedeem == 0) {
            return ResponseEntity.ok("No points redeemed. Reservation cost too low.");
        }

        double discount = pointsToRedeem;
        double newTotalCost = totalCost - discount;

        // Update records
        reservation.setTotalCost(newTotalCost);
        payment.setAmount(newTotalCost);

        loyaltyPoints.setTotalPoints(loyaltyPoints.getTotalPoints() - pointsToRedeem);
        loyaltyPoints.setLastUpdatedDate(new Date());

        // Persist changes
        reservationService.updateReservation(reservation);
        paymentService.updatePayment(payment);
        loyaltyPointsService.updateLoyalty(loyaltyPoints);

        return ResponseEntity.ok("Redeemed " + pointsToRedeem +
                " points. New total cost: " + newTotalCost);
    }

    @GetMapping("/rooms/filter")
    public List<Map<String, Object>> filterRooms(
            @RequestParam(required = false) PaymentType paymentMethod,
            @RequestParam(required = false) String plan,
            @RequestParam(required = false) RoomType roomType,
            @RequestParam(required = false) Integer numberOfSeats,
            @RequestParam(required = false) Double minPrice,
            @RequestParam(required = false) Double maxPrice,
            @RequestParam(required = false) List<String> amenityNames) {

        List<Room> rooms = roomService.filterRooms(
                paymentMethod,
                plan,
                roomType,
                numberOfSeats,
                minPrice,
                maxPrice,
                amenityNames
        );

        List<Map<String, Object>> enhancedRooms = new ArrayList<>();
        for (Room room : rooms) {
            Map<String, Object> roomData = new HashMap<>();
            room.setRoomImages(imageService.getRoomImages(room.getId()));
            roomData.put("room", room);
            roomData.put("workspaceId", roomService.getWorkspaceIdByRoomId(room.getId()));
            enhancedRooms.add(roomData);
        }
        return enhancedRooms;

    }
    @GetMapping("/search")
    public Map<String, Object> search(@RequestParam String query) {
        List<Workspace> workspaces = workspaceService.searchWorkspaces(query);
        List<Room> rooms = roomService.searchRooms(query);

        // Create enhanced room response with workspace ID
        List<Map<String, Object>> enhancedRooms = new ArrayList<>();
        for (Room room : rooms) {
            Map<String, Object> roomData = new HashMap<>();
            room.setRoomImages(imageService.getRoomImages(room.getId()));
            roomData.put("room", room);
            roomData.put("workspaceId", roomService.getWorkspaceIdByRoomId(room.getId()));
            enhancedRooms.add(roomData);
        }

        // Process workspaces with images
        for (Workspace workspace : workspaces) {
            workspace.setWorkspaceImages(imageService.getWorkspaceImages(workspace.getId()));
        }

        return Map.of(
                "workspaces", workspaces,
                "rooms", enhancedRooms
        );
    }

    @GetMapping("/rooms/filter-with-query")
    public List<Map<String, Object>> filterRoomsWithQuery(
            @RequestParam(required = false) PaymentType paymentMethod,
            @RequestParam(required = false) String plan,
            @RequestParam(required = false) RoomType roomType,
            @RequestParam(required = false) Integer numberOfSeats,
            @RequestParam(required = false) Double minPrice,
            @RequestParam(required = false) Double maxPrice,
            @RequestParam(required = false) List<String> amenityNames,
            @RequestParam String query) {

        List<Room> rooms = roomService.filterRoomsWithQuery(
                paymentMethod,
                plan,
                roomType,
                numberOfSeats,
                minPrice,
                maxPrice,
                amenityNames,
                query
        );

        List<Map<String, Object>> enhancedRooms = new ArrayList<>();
        for (Room room : rooms) {
            Map<String, Object> roomData = new HashMap<>();
            room.setRoomImages(imageService.getRoomImages(room.getId()));
            roomData.put("room", room);
            roomData.put("workspaceId", roomService.getWorkspaceIdByRoomId(room.getId()));
            enhancedRooms.add(roomData);
        }
        return enhancedRooms;
    }
    
    @PutMapping("/reservation/direct-update")
    public ResponseEntity<String> directUpdateReservation(@RequestBody Reservation reservation) {
        try {
            reservationService.updateReservation(reservation);
            return ResponseEntity.ok("Reservation updated successfully");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error updating reservation: " + e.getMessage());
        }
    }

    @GetMapping("/reservation/direct-get/{id}")
    public ResponseEntity<Reservation> directGetReservation(@PathVariable String id) {
        try {
            Reservation reservation = reservationService.getReservation(id);
            if (reservation == null) {
                return ResponseEntity.notFound().build();
            }
            return ResponseEntity.ok(reservation);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @GetMapping("/requests")
    public ResponseEntity<Object> getUserRequests(@RequestParam String userId){
        List<Request> requests = requestService.findAllRequestsByUserId(userId);
        return ResponseEntity.ok(requests);
    }
    @GetMapping("/room/availability")
    public ResponseEntity<?> getRoomAvailabilityByDate(
            @RequestParam String roomId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {

        try {
            List<RoomAvailability> availabilities =
                    roomAvailabilityService.getRoomAvailabilitiesByDate(roomId, date);

//            if (availabilities.isEmpty()) {
//                return ResponseEntity.status(HttpStatus.NOT_FOUND)
//                        .body(Map.of("message", "No availability data found"));
//            }

            return ResponseEntity.ok(availabilities);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Failed to fetch availability: " + e.getMessage()));
        }
    }

    @GetMapping("/workspace/operating-hours")
    public ResponseEntity<Map<String, Date>> getWorkspaceOperatingHours(
            @RequestParam String workspaceId,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date date) {

        Map<String, Date> operatingHours =
                reservationService.getWorkspaceOperatingHours(workspaceId, date,false);
        return ResponseEntity.ok(operatingHours);
    }

    @GetMapping("/rooms/top")
    public List<Map<String, Object>> getTopRooms() {
        List<Room> rooms = roomService.getTop5Rooms();

        List<Map<String, Object>> response = new ArrayList<>();

        for (Room room : rooms) {
            Map<String, Object> roomData = new HashMap<>();
            // Get room details
            room.setRoomImages(imageService.getRoomImages(room.getId()));

            // Get workspace ID
            String workspaceId = roomService.getWorkspaceIdByRoomId(room.getId());

            // Add to response
            roomData.put("room", room);
            roomData.put("workspaceId", workspaceId);
            response.add(roomData);
        }

        return response;
    }


}
