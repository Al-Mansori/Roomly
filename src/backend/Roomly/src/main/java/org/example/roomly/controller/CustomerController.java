package org.example.roomly.controller;

import org.example.roomly.model.*;
import org.example.roomly.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.text.SimpleDateFormat;
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
    ReservationService reservationService;

    @Autowired
    PaymentService paymentService;

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
    public String createReservation(@RequestBody Map<String, Object> reservationData) {
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

            // Calculate the difference in milliseconds
            long diffInMillis = endTime.getTime() - startTime.getTime();

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
            Reservation reservation = reservationService.createReservation(startTime, endTime, totalCost, ReservationStatus.CONFIRMED, amenitiesCount, payment);

            roomService.updateRoom(room);

            // Save payment and reservation
            reservationService.saveReservation(reservation);
            paymentService.savePayment(payment, reservation.getId());
            reservationService.addBooking(userId, reservation.getId(), workspaceId, roomId);

            return "Successful reservation";

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to process reservation: " + e.getMessage());
        }
    }
}
