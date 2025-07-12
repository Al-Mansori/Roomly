package org.example.roomly.controller;

import org.example.roomly.model.*;
import org.example.roomly.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.*;

import org.example.roomly.service.ImageService;
import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;


@RestController
@RequestMapping("api/staff")
@CrossOrigin(origins = "http://localhost:3000")
public class WorkspaceStaffController {

    private static final Pattern PUBLIC_ID_PATTERN = Pattern.compile(".*/upload/(v\\d+/)?([^.]+)");

    @Autowired
    private ImageService imageService;

    @Autowired
    private RequestService requestService;

    @Autowired
    private PaymentService paymentService;

    @Autowired
    private WorkspacePlanService workspacePlanService;
    @Autowired
    private  UserService userService;

    @Autowired
    private LoyaltyPointsService loyaltyPointsService;

    @Autowired
    private WorkspaceService workspaceService;

    @Autowired
    private PreferenceService preferenceService;

    @Autowired
    private AmenityService amenityService;

    @Autowired
    private RoomService roomService;

    @Autowired
    private OfferService offerService;

    @Autowired
    CloudinaryService cloudinaryService;

    @Autowired
    private ReservationService reservationService;

    @Autowired
    private  WorkspaceScheduleService workspaceScheduleService;

    @Autowired
    private RecoveryService recoveryService;

    @Autowired
    private WorkspaceStaffService workspaceStaffService;

    @Autowired
    private LocationService locationService;

    @PostMapping("/images/upload")
    @ResponseBody
    public ResponseEntity<String> uploadImage(@RequestParam("file") MultipartFile multipartFile,
                                              @RequestParam("staffId") String staffId,
                                              @RequestParam("workspaceId") String workspaceId,
                                              @RequestParam("roomId") String roomId,
                                              @RequestParam("amenityId") String amenityId) throws IOException {
        BufferedImage bi = ImageIO.read(multipartFile.getInputStream());
        if (bi == null) {
            return ResponseEntity.badRequest().body("Invalid image file");
        }
        try {
            // Upload the image to Cloudinary
            Map result = cloudinaryService.upload(multipartFile);
            String imageUrl = (String) result.get("url");

            // make the roomId and amenityId optional
            if (roomId == null || roomId.isEmpty()) {
                roomId = null; // Set to null if not provided
            }

            if (amenityId == null || amenityId.isEmpty()) {
                amenityId = null; // Set to null if not provided
            }

            // Save the image URL and other details to the database
            imageService.addImage(imageUrl, staffId, workspaceId, roomId, amenityId);

            return ResponseEntity.ok("Image uploaded successfully: " + imageUrl);
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Error uploading image: " + e.getMessage());
        }
    }

    // Upload Image and Return it without add to images in the database
    @PostMapping("/images/upload-image")
    @ResponseBody
    public ResponseEntity<String> uploadImageAndGetURL(@RequestParam("file") MultipartFile multipartFile) throws IOException {
        BufferedImage bi = ImageIO.read(multipartFile.getInputStream());
        if (bi == null) {
            return ResponseEntity.badRequest().body("Invalid image file");
        }
        try {
            // Upload the image to Cloudinary
            Map result = cloudinaryService.upload(multipartFile);
            String imageUrl = (String) result.get("url");

            return ResponseEntity.ok(imageUrl);
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Error uploading image: " + e.getMessage());
        }
    }

    // Helper method to extract public ID
    private String extractPublicIdFromUrl(String imageUrl) {
        Matcher matcher = PUBLIC_ID_PATTERN.matcher(imageUrl);
        if (matcher.find()) {
            String version = matcher.group(1); // Includes trailing slash if present (e.g., "v12345/")
            String path = matcher.group(2);
            return (version != null ? version : "") + path;
        }
        return null;
    }

    // New endpoint to delete by full Image URL
    @DeleteMapping("/images/delete")
    public ResponseEntity<String> deleteImage(@RequestParam("imageUrl") String imageUrl) {
        if (imageUrl == null || imageUrl.trim().isEmpty()) {
            return ResponseEntity.badRequest().body("Image URL parameter is required.");
        }

        try {
            // 1. Extract Public ID from URL
            String publicId = extractPublicIdFromUrl(imageUrl);
            if (publicId == null) {
                return ResponseEntity.badRequest().body("Invalid Cloudinary image URL format provided.");
            }

            // 2. Delete from Cloudinary using Public ID
            Map cloudinaryResult = cloudinaryService.delete(publicId);

            // Check Cloudinary result - consider 'ok' or 'not found' as success
            if (!"ok".equals(cloudinaryResult.get("result")) && !"not found".equals(cloudinaryResult.get("result"))) {
                // Decide if you want to stop or continue to DB deletion. Let's stop here.
                return ResponseEntity.status(500).body("Failed to delete image from Cloudinary. Result: " + cloudinaryResult.get("result"));
            }

            // 3. Delete from Database using the full Image URL
            imageService.deleteImage(imageUrl); // Assumes this method uses the full URL

            return ResponseEntity.ok("Image deleted successfully from Cloudinary and database for URL: " + imageUrl);

        } catch (Exception e) {
            return ResponseEntity.status(500).body("An unexpected error occurred while deleting the image.");
        }
    }

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


//    @PostMapping("/images/upload")
//    public void uploadImage(@RequestParam("file") MultipartFile file,
//                            @RequestParam String staffId,
//                            @RequestParam String workspaceId,
//                            @RequestParam(required = false) String roomId,
//                            @RequestParam(required = false) String amenityId) throws IOException {
//        imageService.addImage(file, staffId, workspaceId, roomId, amenityId);
//    }

//    @DeleteMapping("/images/delete")
//    public void deleteImage(@RequestParam String imageUrl) throws IOException {
//        imageService.deleteImage(imageUrl);
//    }

    @PutMapping("/request/reject")
    public ResponseEntity<String> rejectedRequest(@RequestParam String requestId) {
        Request request = requestService.findRequestById(requestId);
        if (request.getStatus() == RequestStatus.APPROVED) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("Cannot reject an already approved request");
        } else if (request.getStatus() == RequestStatus.COMPLETED) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("Cannot reject a completed request");
        } else if (request.getStatus() == RequestStatus.CANCELLED) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("Cannot reject a cancelled request");
        }
        request.setStatus(RequestStatus.REJECTED);
        requestService.updateRequest(request);
        return ResponseEntity.ok("Rejected Successfully");
    }

    @PutMapping("/request/approve")
    public ResponseEntity<String> approvedRequest(@RequestParam String requestId) {
        Request request = requestService.findRequestById(requestId);
        if (request.getStatus() == RequestStatus.REJECTED) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("Cannot approve a rejected request");
        } else if (request.getStatus() == RequestStatus.COMPLETED) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("Cannot approve a completed request");
        } else if (request.getStatus() == RequestStatus.CANCELLED) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("Cannot approve a cancelled request");
        }
        request.setStatus(RequestStatus.APPROVED);
        requestService.updateRequest(request);
        return ResponseEntity.ok("Approved Successfully");
    }

    @PostMapping("/workspacePlan")
    public ResponseEntity<Void> saveWorkspacePlan(
            @RequestParam String workspaceId,
            @RequestBody WorkspacePlan plan) {
        if(workspacePlanService.findByWorkspaceId(workspaceId) == null){
            workspacePlanService.save(plan, workspaceId);
            return ResponseEntity.status(HttpStatus.CREATED).build();
        }
        else{
            return ResponseEntity.status(HttpStatus.ALREADY_REPORTED).build();
        }
    }

    @DeleteMapping("/workspacePlan")
    public ResponseEntity<Void> deleteWorkspacePlan(@RequestParam String workspaceId) {
        workspacePlanService.delete(workspaceId);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/workspacePlan")
    public ResponseEntity<WorkspacePlan> findWorkspacePlanById(@RequestParam String workspaceId) {
        WorkspacePlan plan = workspacePlanService.findByWorkspaceId(workspaceId);
        return plan != null ?
                ResponseEntity.ok(plan) :
                ResponseEntity.notFound().build();
    }

    @PutMapping("/workspacePlan")
    public ResponseEntity<Void> updateWorkspacePlan(
            @RequestParam String workspaceId,
            @RequestBody WorkspacePlan plan) {
        workspacePlanService.update(plan, workspaceId);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/workspace")
    public String createWorkspace(@RequestBody Workspace workspace, @RequestParam String locationId){
        workspaceService.saveWorkspace(workspace,locationId);
        return "created";
    }

    @GetMapping("/workspace")
    public ResponseEntity<Workspace> getWorkspace(@RequestParam String workspaceId){
        return ResponseEntity.ok(workspaceService.getWorkspaceById(workspaceId));
    }

    @PutMapping("/workspace")
    public ResponseEntity<Workspace> updateWorkspace(@RequestParam Workspace workspace){
        workspaceService.updateWorkspace(workspace);
        return ResponseEntity.ok(workspaceService.getWorkspaceById(workspace.getId()));
    }

    @DeleteMapping("/workspace")
    public ResponseEntity<String> deleteWorkspace(@RequestParam String workspaceId) {
        workspaceService.deleteWorkspace(workspaceId);
        return ResponseEntity.ok("Workspace deleted successfully");
    }

    //test loyalty points crud
//    @PostMapping("/newloyalty")
//    public String createLoyaltyPoint(@RequestParam String userId, @RequestParam int points){
//        boolean new_ = loyaltyPointsService.createLoyalty(userId,points);
//        if(new_){
//            return "created";
//        }
//        return"not created";
//    }
//
//    @PostMapping("/addpoints")
//    public String addLoyaltyPoint(@RequestParam String userId, @RequestParam int points){
//        loyaltyPointsService.addPoints(userId,points);
//        return "added";
//    }
//
//    @GetMapping("/getLoyalty")
//    public ResponseEntity<LoyaltyPoints> getLoyalty(@RequestParam String userId){
//        return ResponseEntity.ok(loyaltyPointsService.getLoyalty(userId));
//    }
//
//    @DeleteMapping("deleteLoyalty")
//    public String deleteLoyalty(@RequestParam String userId){
//        loyaltyPointsService.deleteLoyalty(userId);
//        return "successfully deleted";
//    }

    @PostMapping("/amenity/{roomId}")
    public void saveAmenity(@RequestBody Amenity amenity, @PathVariable String roomId) {
        amenityService.saveAmenity(amenity, roomId);
    }

    @DeleteMapping("/amenity/{id}")
    public ResponseEntity<String> deleteAmenity(@PathVariable String id) {
        amenityService.deleteAmenity(id);
        return ResponseEntity.ok("Amenity deleted successfully");
    }
    @PutMapping("/amenity")
    public void updateAmenity(@RequestBody Amenity amenity) {
        amenityService.updateAmenity(amenity);
    }

    @GetMapping("/amenity/{id}")
    public Amenity getAmenityById(@PathVariable String id) {
        return amenityService.getAmenityById(id);
    }

    @GetMapping("/amenity")
    public List<Amenity> getAllAmenities() {
        return amenityService.getAllAmenities();
    }

    @GetMapping("/amenity/room/{roomId}")
    public List<Amenity> getAmenitiesByRoomId(@PathVariable String roomId) {
        List<Amenity> amenities = amenityService.getAmenitiesByRoomId(roomId);
        for (Amenity amenity : amenities) {
            amenity.setAmenityImages(imageService.getAmenityImages(amenity.getId()));
        }
        return amenities;
    }

    @PostMapping("/room/{workspaceId}")
    public void saveRoom(@RequestBody Room room, @PathVariable String workspaceId) {
        roomService.saveRoom(room, workspaceId);
    }

    @DeleteMapping("/room")
    public ResponseEntity<String> deleteRoom(@RequestParam String id) {
        roomService.deleteRoom(id);
        return ResponseEntity.ok("Room deleted successfully");
    }

    @PutMapping("/room")
    public void updateRoom(@RequestBody Room room) {
        roomService.updateRoom(room);
    }

    @GetMapping("/room/{id}")
    public Room getRoomById(@PathVariable String id) {
        Room room = roomService.getRoomById(id);
        room.setRoomImages(imageService.getRoomImages(room.getId()));
        return room ;
    }

    @GetMapping("/room")
    public List<Room> getAllRooms() {
        return roomService.getAllRooms();
    }

    @GetMapping("/room/workspace/{workspaceId}")
    public List<Room> getRoomsByWorkspaceId(@PathVariable String workspaceId) {
        return roomService.getRoomsByWorkspaceId(workspaceId);
    }

    @PostMapping("/offer")
    public ResponseEntity<Map<String, Object>> createOffer(
            @RequestBody Map<String, Object> requestBody) {

        try {
            // Extract fields from the request body
            String offerTitle = (String) requestBody.get("offerTitle");
            String description = (String) requestBody.get("description");
            double discountPercentage = Double.parseDouble(requestBody.get("discountPercentage").toString());
            Date validFrom = new SimpleDateFormat("yyyy-MM-dd").parse((String) requestBody.get("validFrom"));
            Date validTo = new SimpleDateFormat("yyyy-MM-dd").parse((String) requestBody.get("validTo"));
            String staffId = (String) requestBody.get("staffId");
            String roomId = (String) requestBody.get("roomId");

            // Call service with extracted fields
            int result = offerService.saveOffer(offerTitle, description, discountPercentage,
                    validFrom, validTo, staffId, roomId);

            if (result > 0) {
                return ResponseEntity.ok(Map.of(
                        "message", "Offer created successfully",
                        "status", HttpStatus.CREATED.value()
                ));
            } else {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                        .body(Map.of("error", "Failed to create offer"));
            }
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(Map.of("error", "Invalid request data: " + e.getMessage()));
        }
    }

    @GetMapping("/offer/{id}")
    public Offer getOffer(@PathVariable String id) {
        return offerService.getOfferById(id);
    }

    @GetMapping("/offer")
    public List<Offer> getAllOffers() {
        return offerService.getAllOffers();
    }

    @PutMapping("/offer")
    public int updateOffer(@RequestBody Offer offer) {
        return offerService.updateOffer(offer);
    }

    @DeleteMapping("/offer/{id}")
    public int deleteOffer(@PathVariable String id) {
        return offerService.deleteOffer(id);
    }

    @GetMapping("/offers/room/{roomId}")
    public ResponseEntity<List<Offer>> getOffersByRoomId(@PathVariable String roomId) {
        List<Offer> offers = offerService.getOffersByRoomId(roomId);
        if (offers.isEmpty()) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(offers);
    }

    @GetMapping("/offers/staff/{staffId}")
    public ResponseEntity<List<Offer>> getOffersByStaffId(@PathVariable String staffId) {
        List<Offer> offers = offerService.getOffersByStaffId(staffId);
        if (offers.isEmpty()) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(offers);
    }

    @PostMapping("/block/user")
    public ResponseEntity<String> blockUser(@RequestParam String staffId, @RequestParam String userId){
        userService.blockUser(staffId,userId);
        return ResponseEntity.ok("user "+userId+" blocked");
    }

    @PostMapping("/unblock/user")
    public ResponseEntity<String> unblockUser(@RequestParam String staffId, @RequestParam String userId){
        userService.unblockUser(staffId,userId);
        return ResponseEntity.ok("user "+userId+" unblocked");
    }

    @GetMapping("/blocked/users")
    public ResponseEntity<List<String>> getBlockedUsers(@RequestParam String staffId){
        List<String> blockedUsers = userService.getBlockedUsers(staffId);
        if (blockedUsers.isEmpty()) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(blockedUsers);
    }

    // Add this method to WorkspaceStaffController
    @GetMapping("/workspaces/location/{locationId}")
    public ResponseEntity<List<Workspace>> getWorkspacesByLocationStaff(@PathVariable String locationId) {
        List<Workspace> workspaces = workspaceService.getWorkspacesByLocationId(locationId);
        return workspaces.isEmpty() ?
                ResponseEntity.status(HttpStatus.NOT_FOUND).body(Collections.emptyList()) :
                ResponseEntity.ok(workspaces);
    }


    @PostMapping("/workspace-schedules")
    public ResponseEntity<WorkspaceSchedule> createSchedule(@RequestBody WorkspaceSchedule schedule) {
        workspaceScheduleService.saveSchedule(schedule);
        return ResponseEntity.ok(schedule);
    }

    @DeleteMapping("/workspace-schedules/{workspaceId}/{day}")
    public ResponseEntity<Void> deleteSchedule(
            @PathVariable String workspaceId,
            @PathVariable String day) {
        workspaceScheduleService.deleteSchedule(workspaceId, day);
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/workspace-schedules")
    public ResponseEntity<WorkspaceSchedule> updateSchedule(@RequestBody WorkspaceSchedule schedule) {
        workspaceScheduleService.updateSchedule(schedule);
        return ResponseEntity.ok(schedule);
    }

    @GetMapping("/workspace-schedules/{workspaceId}/{day}")
    public ResponseEntity<WorkspaceSchedule> getSchedule(
            @PathVariable String workspaceId,
            @PathVariable String day) {
        return ResponseEntity.ok(workspaceScheduleService.getSchedule(workspaceId, day));
    }

    @GetMapping("/workspace-schedules/workspace/{workspaceId}")
    public ResponseEntity<List<WorkspaceSchedule>> getSchedulesForWorkspace(
            @PathVariable String workspaceId) {
        return ResponseEntity.ok(workspaceScheduleService.getSchedulesForWorkspace(workspaceId));
    }

    @GetMapping("/workspace-schedules")
    public ResponseEntity<List<WorkspaceSchedule>> getAllSchedules() {
        return ResponseEntity.ok(workspaceScheduleService.getAllSchedules());
    }

    @PutMapping("/workspace-schedules-list")
    public ResponseEntity<List<WorkspaceSchedule>> updateSchedules(
            @RequestBody List<WorkspaceSchedule> schedules)
    {
        List<WorkspaceSchedule> updated = new ArrayList<>();
        for (WorkspaceSchedule sched : schedules) {
            WorkspaceSchedule saved = workspaceScheduleService.updateSchedule(sched);
            updated.add(saved);
        }
        return ResponseEntity.ok(updated);
    }

    @PostMapping("/workspace-schedules-list")
    public ResponseEntity<List<WorkspaceSchedule>> createSchedules(
            @RequestBody List<WorkspaceSchedule> schedules)
    {
        List<WorkspaceSchedule> created = new ArrayList<>();
        for (WorkspaceSchedule sched : schedules) {
            WorkspaceSchedule saved = workspaceScheduleService.saveSchedule(sched);
            created.add(saved);
        }
        return ResponseEntity.ok(created);
    }

    // Add access code verification endpoint for staff
    @GetMapping("/reservation/verify")
    public ResponseEntity<?> verifyAccessCodeStaff(
            @RequestParam String reservationId,
            @RequestParam String accessCode) {

        Reservation reservation = reservationService.getReservation(reservationId);
        if (reservation == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body("Reservation not found");
        }

        if (reservation.getAccessCode().equals(accessCode)) {
            return ResponseEntity.ok(Map.of(
                    "status", "VALID",
                    "reservation", reservation
            ));
        }

        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body("Invalid access code");
    }

    // Get all reservations for a workspace
    @GetMapping("/reservations/workspace/{workspaceId}")
    public ResponseEntity<List<Reservation>> getWorkspaceReservations(
            @PathVariable String workspaceId) {
        List<Reservation> reservations = reservationService.getWorkspaceReservations(workspaceId);
        return ResponseEntity.ok(reservations);
    }

    // Get cancelled reservations for a workspace
    @GetMapping("/reservations/workspace/{workspaceId}/cancelled")
    public ResponseEntity<List<Reservation>> getWorkspaceCancelledReservations(
            @PathVariable String workspaceId) {
        List<Reservation> reservations = reservationService.getWorkspaceCancelledReservations(workspaceId);
        return ResponseEntity.ok(reservations);
    }

    // Get a specific reservation by ID (staff)
    @GetMapping("/reservation/{reservationId}")
    public ResponseEntity<Reservation> getReservationStaff(
            @PathVariable String reservationId) {
        Reservation reservation = reservationService.getReservation(reservationId);
        if (reservation == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(reservation);
    }

    // Update a reservation (staff)
    @PutMapping("/reservation")
    public ResponseEntity<Reservation> updateReservationStaff(
            @RequestBody Reservation reservation) {
        reservationService.updateReservation(reservation);
        return ResponseEntity.ok(reservation);
    }

//    @GetMapping("/room/type")
//    public ResponseEntity<?> getRoomsByType(@RequestParam String type) {
//        RoomType roomType;
//        try {
//            roomType = RoomType.valueOf(type.toUpperCase());
//        } catch (IllegalArgumentException e) {
//            // Invalid enum constant: return 400 with message listing valid values
//            String valid = Arrays.stream(RoomType.values())
//                    .map(RoomType::name)
//                    .collect(Collectors.joining(", "));
//            String msg = "Invalid room type: '" + type + "'. Valid values are: " + valid;
//            return ResponseEntity.badRequest().body(msg);
//        }
//
//        List<Room> rooms = roomService.getRoomsByType(roomType);
//        return ResponseEntity.ok(rooms);
//    }

    @GetMapping("/room/type")
    public ResponseEntity<List<Map<String, Object>>> getRoomsByType(@RequestParam String type) {
        RoomType roomType;
        try {
            roomType = RoomType.valueOf(type.toUpperCase());
        } catch (IllegalArgumentException e) {
            // Invalid enum constant: return 400 with message listing valid values
            String valid = Arrays.stream(RoomType.values())
                    .map(RoomType::name)
                    .collect(Collectors.joining(", "));
            String msg = "Invalid room type: '" + type + "'. Valid values are: " + valid;
            return ResponseEntity.badRequest().body(Collections.singletonList(Map.of("error", msg)));
        }
        // Step 1: Fetch rooms by type
        List<Room> rooms = roomService.getRoomsByType(roomType); // assuming your service returns List<Room>

        // Step 2: Build new response with added workspaceId
        List<Map<String, Object>> enrichedRooms = new ArrayList<>();

        for (Room room : rooms) {
            room.setRoomImages(imageService.getRoomImages(room.getId()));
            Map<String, Object> roomMap = new HashMap<>();
            roomMap.put("id", room.getId());
            roomMap.put("name", room.getName());
            roomMap.put("type", room.getType());
            roomMap.put("description", room.getDescription());
            roomMap.put("capacity", room.getCapacity());
            roomMap.put("availableCount", room.getAvailableCount());
            roomMap.put("pricePerHour", room.getPricePerHour());
            roomMap.put("status", room.getStatus());
            roomMap.put("amenities", room.getAmenities());
            roomMap.put("roomImages", room.getRoomImages());
            roomMap.put("offers", room.getOffers());

            // Add workspaceId using your existing function
            Workspace workspace = workspaceService.getWorkspacesByRoomId(room.getId()); // or wherever the function is
            roomMap.put("workspaceId", workspace.getId());

            enrichedRooms.add(roomMap);
        }

        return ResponseEntity.ok(enrichedRooms);
    }

    @GetMapping("/room/recovery/check")
    public ResponseEntity<Boolean> checkRoomInRecovery(@RequestParam String roomId) {
        boolean isInRecovery = recoveryService.isRoomInRecovery(roomId);
        return ResponseEntity.ok(isInRecovery);
    }

    @PostMapping("/room/recovery/add")
    public ResponseEntity<String> addRoomToRecovery(
            @RequestParam String roomId,
            @RequestParam(required = false, defaultValue = "Maintenance") String reason) {
        recoveryService.putRoomInRecovery(roomId, reason);
        return ResponseEntity.ok("Room added to recovery successfully");
    }

    @DeleteMapping("/room/recovery/remove")
    public ResponseEntity<String> removeRoomFromRecovery(@RequestParam String roomId) {
        recoveryService.removeRoomFromRecovery(roomId);
        return ResponseEntity.ok("Room removed from recovery successfully");
    }

    @GetMapping("/workspace/staff")
    public ResponseEntity<List<String>> getStaffIdsByWorkspaceId(@RequestParam String workspaceId) {
        List<String> staffIds = workspaceStaffService.getStaffIdsByWorkspaceId(workspaceId);
        return ResponseEntity.ok(staffIds);
    }
    @GetMapping("/requests")
    public ResponseEntity<Object> getOwnerRequests(@RequestParam String staffId){
        List<Request> requests = requestService.findAllRequestsByStaffId(staffId);
        return ResponseEntity.ok(requests);
    }

    @GetMapping("/workspaces")
    public ResponseEntity<Object> getOwnerWorkspaces(@RequestParam String staffId){
        List<Workspace> workspaces = workspaceService.getOwnerWorkspaces(staffId);
        return ResponseEntity.ok(workspaces);
    }

//    @GetMapping("/reservations")
//    public ResponseEntity<List<Reservation>> getOwnerReservations(@RequestParam String staffId){
//        String workspaceId = workspaceService.getOwnerWorkspaces(staffId).get(0).getId();
//        List<Reservation> reservations = reservationService.getWorkspaceReservations(workspaceId);
//        return ResponseEntity.ok(reservations);
//    }

    @GetMapping("/reservations")
    public ResponseEntity<List<Reservation>> getOwnerReservations(@RequestParam String staffId) {
        // Get all workspaces for this staff member
        List<Workspace> workspaces = workspaceService.getOwnerWorkspaces(staffId);
        if (workspaces.isEmpty()) {
            return ResponseEntity.ok(Collections.emptyList());
        }

        // Get reservations for all workspaces
        List<Reservation> reservations = new ArrayList<>();
        for (Workspace workspace : workspaces) {
            reservations.addAll(reservationService.getWorkspaceReservations(workspace.getId()));
        }

        // Enrich reservations with payment data
        for (Reservation reservation : reservations) {
            Payment payment = paymentService.getByReservation(reservation.getId());
            reservation.setPayment(payment);
        }

        return ResponseEntity.ok(reservations);
    }


    @PostMapping("/reserve")
    public ResponseEntity<Map<String, Object>> createReservation(
            @RequestParam String paymentMethod,
            @RequestParam int amenitiesCount,
            @RequestParam String startTime,
            @RequestParam(required = false) String endTime,
            @RequestParam ReservationType reservationType,
            @RequestParam String workspaceId,
            @RequestParam String roomId) {

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

            // Create payment and reservation
            Payment payment = paymentService.createPayment(paymentMethod, totalCost, PaymentStatus.COMPLETED);
            Reservation reservation = reservationService.createReservation(start, end, totalCost,
                    ReservationStatus.CONFIRMED, amenitiesCount, payment, reservationType);

            // Update availability
            reservationService.updateAvailability(roomId, start, end, amenitiesCount, true);

            // Save payment and reservation
            reservationService.saveReservation(reservation);
            paymentService.savePayment(payment, reservation.getId());
            reservationService.saveBooking(null, reservation.getId(), workspaceId, roomId);

            return ResponseEntity.ok(Map.of(
                    "message", "Successful reservation",
                    "reservationId", reservation.getId(),
                    "startTime", dateFormat.format(start),
                    "endTime", dateFormat.format(end)
            ));

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("message", "Failed to process reservation: " + e.getMessage()));
        }
    }

    @PostMapping("/create-workspace")
    public ResponseEntity<?> createWorkspace(
            @RequestParam String name,
            @RequestParam(required = false) String description,
            @RequestParam String address,
            @RequestParam(required = false) String workspaceType,
            @RequestParam String paymentType,
            @RequestParam String city,
            @RequestParam String town,
            @RequestParam String country,
            @RequestParam(required = false) double longitude,
            @RequestParam(required = false) double latitude,
            @RequestParam(required = false) List<String> imageUrls,
            @RequestParam String staffId) {

        try {
            // Create and save location
            Location location = new Location();
            location.setCity(city);
            location.setTown(town);
            location.setCountry(country);
            location.setLongitude(longitude);
            location.setLatitude(latitude);
            Location savedLocation = locationService.saveLocation(location);

            // Create workspace
            Workspace workspace = new Workspace();
            workspace.setName(name);
            workspace.setDescription(description);
            workspace.setAddress(address);
            workspace.setType(workspaceType);
            workspace.setPaymentType(PaymentType.valueOf(paymentType.toUpperCase()));
            workspace.setCreationDate(Date.from(LocalDate.now().atStartOfDay(ZoneId.systemDefault()).toInstant()));
            workspace.setAvgRating(0.0);

            // Save workspace with location ID
            workspace = workspaceService.saveWorkspace(workspace, savedLocation.getId());

            workspaceService.addSupervisorToWorkspace(staffId,workspace.getId());

            // Save images
            for (String imageUrl : imageUrls) {
                imageService.addImage(
                        imageUrl,
                        staffId,
                        workspace.getId(),
                        null,
                        null
                );
            }

            // Build response
            Map<String, Object> response = new HashMap<>();
            response.put("message", "Workspace created successfully");
            response.put("workspaceId", workspace.getId());
            response.put("locationId", savedLocation.getId());

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Workspace creation failed: " + e.getMessage()));
        }
    }

    @PostMapping("/create-room")
    public ResponseEntity<?> createRoom(
            @RequestParam String name,
            @RequestParam String type,
            @RequestParam(required = false) String description,
            @RequestParam int capacity,
            @RequestParam double pricePerHour,
            @RequestParam String workspaceId,
            @RequestParam(required = false) List<String> imageUrls,
            @RequestParam String staffId) {

        try {
            // Create room object
            Room room = new Room();
            room.setName(name);
            room.setType(RoomType.valueOf(type.toUpperCase()));
            room.setDescription(description);
            room.setCapacity(capacity);
            room.setAvailableCount(capacity);
            room.setPricePerHour(pricePerHour);
            room.setStatus(RoomStatus.AVAILABLE);

            // Save room to workspace
            room = roomService.saveRoom(room, workspaceId);

            // Save images
            for (String imageUrl : imageUrls) {
                imageService.addImage(
                        imageUrl,
                        staffId,
                        workspaceId,
                        room.getId(),  // Set room ID
                        null
                );
            }

            // Build response
            Map<String, Object> response = new HashMap<>();
            response.put("message", "Room created successfully");
            response.put("roomId", room.getId());
            response.put("workspaceId", workspaceId);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Room creation failed: " + e.getMessage()));
        }
    }

    @PostMapping("/create-amenity")
    public ResponseEntity<?> createAmenity(
            @RequestParam String name,
            @RequestParam(required = false) String type,
            @RequestParam(required = false) String description,
            @RequestParam int totalCount,
            @RequestParam String roomId,
            @RequestParam(required = false) List<String> imageUrls,
            @RequestParam String staffId) {

        try {
            // Create amenity object
            Amenity amenity = new Amenity();
            amenity.setName(name);
            amenity.setType(type);
            amenity.setDescription(description);
            amenity.setTotalCount(totalCount);

            // Save amenity to room
            amenity = amenityService.saveAmenity(amenity, roomId);

            // Get workspace ID from room
            String workspaceId = roomService.getWorkspaceIdByRoomId(roomId);

            // Save images
            for (String imageUrl : imageUrls) {
                imageService.addImage(
                        imageUrl,
                        staffId,
                        workspaceId,
                        roomId,
                        amenity.getId()  // Set amenity ID
                );
            }

            // Build response
            Map<String, Object> response = new HashMap<>();
            response.put("message", "Amenity created successfully");
            response.put("amenityId", amenity.getId());
            response.put("roomId", roomId);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Amenity creation failed: " + e.getMessage()));
        }

    }
    @DeleteMapping("/request")
    public ResponseEntity<Map<String,Object>> deleteRequest(@RequestParam String requestId){
        try{
            requestService.deleteRequestById(requestId);
            return ResponseEntity.ok(Map.of("requestId",requestId));
        }
        catch (Exception e){
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of("requestId",requestId,"message","Failed to delete request: "+e.getMessage()));
        }
    }

    @GetMapping("/users-list")
    public ResponseEntity<List<User>> getUsersWithReservations(@RequestParam String staffId) {
        // 1. Get all workspace IDs for the staff member
        List<String> workspaceIds = workspaceStaffService.getWorkspaceIdsByStaffId(staffId);

        if (workspaceIds.isEmpty()) {
            return ResponseEntity.ok(Collections.emptyList());
        }

        // 2. Get all unique user IDs who have reservations in these workspaces
        List<String> userIds = reservationService.getUserIdsByWorkspaceIds(workspaceIds);

        if (userIds.isEmpty()) {
            return ResponseEntity.ok(Collections.emptyList());
        }

        // 3. Get user details for each user ID
        List<User> users = new ArrayList<>();
        for (String userId : userIds) {
            User user = userService.getUserById(userId);
            if (user != null) {
                users.add(user);
            }
        }
        
        return ResponseEntity.ok(users);
    }
    
    @GetMapping("/staffdetails")
    public ResponseEntity<WorkspaceStaff> getStaffDetails(@RequestParam String staffId){
        WorkspaceStaff staff = workspaceStaffService.getWrokspaceStaff(staffId);
        return ResponseEntity.ok(staff);
    }

    @PutMapping("/update-staff")
    public ResponseEntity<WorkspaceStaff> updateStaff(@RequestBody WorkspaceStaff staff){
        WorkspaceStaff updatedStaff = workspaceStaffService.updateWorkspaceStaff(staff);
        return ResponseEntity.ok(staff);
    }

    @PutMapping("/update-workspace")
    public ResponseEntity<?> updateWorkspace(
            @RequestParam String workspaceId,
            @RequestParam(required = false) String name,
            @RequestParam(required = false) String description,
            @RequestParam(required = false) String address,
            @RequestParam(required = false) String workspaceType,
            @RequestParam(required = false) String paymentType,
            @RequestParam(required = false) String city,
            @RequestParam(required = false) String town,
            @RequestParam(required = false) String country,
            @RequestParam(required = false) Double longitude,
            @RequestParam(required = false) Double latitude,
            @RequestParam(required = false) List<String> imageUrls,
            @RequestParam String staffId) {

        try {
            // Get existing workspace
            Workspace workspace = workspaceService.getWorkspaceById(workspaceId);
            if (workspace == null) {
                return ResponseEntity.notFound().build();
            }

            // Get location ID from workspace
            String locationId = workspace.getLocation().getId();
            Location location = locationService.getLocationById(locationId);

            // Update location if provided
            if (city != null) location.setCity(city);
            if (town != null) location.setTown(town);
            if (country != null) location.setCountry(country);
            if (longitude != null) location.setLongitude(longitude);
            if (latitude != null) location.setLatitude(latitude);
            locationService.updateLocation(location);

            // Update workspace fields
            if (name != null) workspace.setName(name);
            if (description != null) workspace.setDescription(description);
            if (address != null) workspace.setAddress(address);
            if (workspaceType != null) workspace.setType(workspaceType);
            if (paymentType != null) workspace.setPaymentType(PaymentType.valueOf(paymentType.toUpperCase()));
            workspaceService.updateWorkspace(workspace);

            // Update images if provided
            if (imageUrls != null) {
                // Delete existing workspace images
                List<Image> existingImages = imageService.getWorkspaceImages(workspaceId);
                for (Image img : existingImages) {
                    imageService.deleteImage(img.getImageUrl());
                }

                // Add new images
                for (String imageUrl : imageUrls) {
                    imageService.addImage(
                            imageUrl,
                            staffId,
                            workspaceId,
                            null,
                            null
                    );
                }
            }

            return ResponseEntity.ok(Map.of(
                    "message", "Workspace updated successfully",
                    "workspaceId", workspaceId
            ));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Workspace update failed: " + e.getMessage()));
        }
    }

    @PutMapping("/update-room")
    public ResponseEntity<?> updateRoom(
            @RequestParam String roomId,
            @RequestParam(required = false) String name,
            @RequestParam(required = false) String type,
            @RequestParam(required = false) String description,
            @RequestParam(required = false) Integer capacity,
            @RequestParam(required = false) Double pricePerHour,
            @RequestParam(required = false) List<String> imageUrls,
            @RequestParam String staffId) {

        try {
            // Get existing room
            Room room = roomService.getRoomById(roomId);
            if (room == null) {
                return ResponseEntity.notFound().build();
            }

            // Update room fields
            if (name != null) room.setName(name);
            if (type != null) room.setType(RoomType.valueOf(type.toUpperCase()));
            if (description != null) room.setDescription(description);
            if (capacity != null) {
                room.setCapacity(capacity);
                room.setAvailableCount(capacity); // Reset available count
            }
            if (pricePerHour != null) room.setPricePerHour(pricePerHour);
            roomService.updateRoom(room);

            // Update images if provided
            if (imageUrls != null) {
                // Delete existing room images
                List<Image> existingImages = imageService.getRoomImages(roomId);
                for (Image img : existingImages) {
                    imageService.deleteImage(img.getImageUrl());
                }

                // Add new images
                String workspaceId = roomService.getWorkspaceIdByRoomId(roomId);
                for (String imageUrl : imageUrls) {
                    imageService.addImage(
                            imageUrl,
                            staffId,
                            workspaceId,
                            roomId,
                            null
                    );
                }
            }

            return ResponseEntity.ok(Map.of(
                    "message", "Room updated successfully",
                    "roomId", roomId
            ));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Room update failed: " + e.getMessage()));
        }
    }

    @PutMapping("/update-amenity")
    public ResponseEntity<?> updateAmenity(
            @RequestParam String amenityId,
            @RequestParam(required = false) String name,
            @RequestParam(required = false) String type,
            @RequestParam(required = false) String description,
            @RequestParam(required = false) Integer totalCount,
            @RequestParam(required = false) List<String> imageUrls,
            @RequestParam String staffId) {

        try {
            // Get existing amenity
            Amenity amenity = amenityService.getAmenityById(amenityId);
            if (amenity == null) {
                return ResponseEntity.notFound().build();
            }

            // Update amenity fields
            if (name != null) amenity.setName(name);
            if (type != null) amenity.setType(type);
            if (description != null) amenity.setDescription(description);
            if (totalCount != null) amenity.setTotalCount(totalCount);
            amenityService.updateAmenity(amenity);

            // Update images if provided
            if (imageUrls != null) {
                // Delete existing amenity images
                List<Image> existingImages = imageService.getAmenityImages(amenityId);
                for (Image img : existingImages) {
                    imageService.deleteImage(img.getImageUrl());
                }

                // Add new images
                String roomId = amenityService.getRoomIdByAmenityId(amenityId);
                String workspaceId = roomService.getWorkspaceIdByRoomId(roomId);
                for (String imageUrl : imageUrls) {
                    imageService.addImage(
                            imageUrl,
                            staffId,
                            workspaceId,
                            roomId,
                            amenityId
                    );
                }
            }

            return ResponseEntity.ok(Map.of(
                    "message", "Amenity updated successfully",
                    "amenityId", amenityId
            ));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Amenity update failed: " + e.getMessage()));
        }
    }

    @GetMapping("/staff-plans")
    public ResponseEntity<Map<String,WorkspacePlan>> getWorkspacePlansByStaff(@RequestParam String staffId) {
        Map<String,WorkspacePlan> plans = workspacePlanService.getPlansByStaffId(staffId);
        System.out.println(plans);
        return ResponseEntity.ok(plans);
    }

}
