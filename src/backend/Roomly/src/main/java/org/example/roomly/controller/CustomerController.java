package org.example.roomly.controller;

import org.example.roomly.model.*;
import org.example.roomly.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

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

    @GetMapping("home")
    public List<Workspace> getHome(){
        List<Workspace> workspaces = workspaceService.getAllWorkspaces().subList(0,5);
        for (Workspace workspace: workspaces) {
            workspace.setWorkspaceImages(imageService.getWorkspaceImages(workspace.getId()));
        }
        return workspaces;
    }

    @GetMapping("workspace/details")
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

    @GetMapping("room/details")
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

    @PostMapping("/reserve")
    public String createReservation(@RequestParam String paymentMethod, @RequestParam int amenitiesCount, @RequestParam String startTime, @RequestParam String endTime,
    @RequestParam String userId, @RequestParam String workspaceId, @RequestParam String roomId) {

        try {

            // Parse dates
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
            Date start = dateFormat.parse(startTime);
            Date end = dateFormat.parse(endTime);

            // Calculate the difference in milliseconds
            long diffInMillis = end.getTime() - start.getTime();

            // Convert milliseconds to hours
            long reservedHours = TimeUnit.MILLISECONDS.toHours(diffInMillis);

            Room room = roomService.getRoomById(roomId);
            if(room.getStatus().toString().equals("Unavailable") || room.getAvailableCount() < amenitiesCount){
                return "Room is unavailable for reservation";
            }

            room.setAvailableCount(room.getAvailableCount()-amenitiesCount);
            double hourPrice = room.getPricePerHour();
            double totalCost = hourPrice * amenitiesCount * reservedHours;

            // Create payment and reservation
            Payment payment = paymentService.createPayment(paymentMethod, totalCost, PaymentStatus.CONFIRMED);
            Reservation reservation = reservationService.createReservation(start, end, totalCost, ReservationStatus.CONFIRMED, amenitiesCount, payment);

            roomService.updateRoom(room);

            // Save payment and reservation
            reservationService.saveReservation(reservation);
            paymentService.savePayment(payment, reservation.getId());
            reservationService.saveBooking(userId, reservation.getId(), workspaceId, roomId);

            return "Successful reservation";

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to process reservation: " + e.getMessage());
        }
    }

    @PutMapping("/CancelReservation")
    public String cancelReservation(String reservationId, String userId){
        Reservation reservation = reservationService.getReservation(reservationId);
        reservation.setStatus(ReservationStatus.CANCELLED);
        reservationService.updateReservation(reservation);
        Timestamp cancellationDate = Timestamp.valueOf(LocalDateTime.now());
        double fees = 999.999 ;
        reservationService.CancelReservation(fees, cancellationDate, userId, reservationId);
        return "Canceled Successfully";
    }

    @PostMapping("/review")
    public String addReview(@RequestBody double rating, @RequestParam String comment, @RequestParam String userId, @RequestParam String workspaceId) {
        Review review = reviewService.createReview(rating, comment);
        reviewService.saveReview(review, userId, workspaceId);
        return ("Review added successfully");
    }

    @GetMapping("/review")
    public Review getReview(@RequestParam String id) {
        return reviewService.getReviewById(id);
    }

    @GetMapping("/review")
    public List<Review> getAllReviews() {
        return reviewService.getAllReviews();
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
    public Request updateRequest(@RequestParam String requestId) {
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
}
