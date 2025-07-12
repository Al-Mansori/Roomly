package org.example.roomly.service;

import org.example.roomly.model.*;
import org.example.roomly.repository.ReservationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.example.roomly.repository.RoomAvailabilityRepository;
import java.text.SimpleDateFormat;
import java.text.ParseException;

import java.text.ParseException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Calendar;

import java.sql.Timestamp;
import java.util.*;

@Service
public class ReservationService {

    @Autowired
    private ReservationRepository reservationRepository ;
    @Autowired
    private RoomAvailabilityRepository roomAvailabilityRepository;
    @Autowired
    private RoomService roomService;
    @Autowired
    private WorkspaceScheduleService workspaceScheduleService;

    @Autowired
    public ReservationService(ReservationRepository reservationRepository,
                              RoomAvailabilityRepository roomAvailabilityRepository,
                              RoomService roomService) {
        this.reservationRepository = reservationRepository;
        this.roomAvailabilityRepository = roomAvailabilityRepository;
        this.roomService = roomService;
    }

    public Reservation createReservation(Date startTime, Date endTime, double totalCost,
                                         ReservationStatus status, int amenitiesCount, Payment payment, ReservationType reservationType) {
        String reservationId = UUID.randomUUID().toString();
        Date reservationDate = new Date();
        // Generate access code (6-digit number)
        String accessCode = String.format("%06d", new Random().nextInt(999999));
        return new Reservation(reservationId, reservationDate, startTime, endTime,
                status, amenitiesCount, totalCost, payment, accessCode, reservationType);
    }

    public void addPayment(Reservation reservation,Payment payment){
        reservation.setPayment(payment);
    }

    public void deletePayment(Reservation reservation){
        reservation.setPayment(null);
    }

    public void saveReservation(Reservation reservation){
        reservationRepository.save(reservation);
    }

    public void deleteRservation(String id){
        reservationRepository.delete(id);
    }

    public void updateReservation(Reservation reservation){
        reservationRepository.update(reservation);
    }

    public Reservation getReservation(String id){
        return reservationRepository.find(id);
    }

    public List<Reservation> getAll(){
        return reservationRepository.findAll();
    }

    public void saveBooking(String userId, String reservationId, String workspaceId, String roomId){
        reservationRepository.saveBooking(userId, reservationId, workspaceId, roomId);
    }
    public void deleteBooking(String userId, String reservationId){
        reservationRepository.deleteBooking(userId, reservationId);
    }

    public Map<String, Object> getBooking(String userId, String reservationId) {
        return reservationRepository.getBooking(userId, reservationId);
    }

    public void CancelReservation(double fees, Timestamp cancellationDate, String userId, String reservationId) {
        reservationRepository.CancelReservation(fees, cancellationDate, userId ,reservationId);
    }

    public void deleteCancellation(String reservationId) {
        reservationRepository.deleteCancellation(reservationId);
    }

    public List<Reservation> getUserReservations(String userId) {
        return reservationRepository.findReservationsByUserId(userId);
    }

    public List<Reservation> getUserCancelledReservations(String userId) {
        return reservationRepository.findCancelledReservationsByUserId(userId);
    }

    public List<Reservation> getWorkspaceReservations(String workspaceId) {
        return reservationRepository.findReservationsByWorkspaceId(workspaceId);
    }

    public List<Reservation> getWorkspaceCancelledReservations(String workspaceId) {
        return reservationRepository.findCancelledReservationsByWorkspaceId(workspaceId);
    }

    public List<Map<String, Object>> getUserReservationsWithBooking(String userId) {
        return reservationRepository.findReservationsWithBookingByUserId(userId);
    }

    public boolean checkAvailability(String roomId, Date startTime, Date endTime, int amenitiesCount) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(startTime);
        int startHour = calendar.get(Calendar.HOUR_OF_DAY);

        calendar.setTime(endTime);
        int endHour = calendar.get(Calendar.HOUR_OF_DAY);

        LocalDate date = startTime.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
        Room room = roomService.getRoomById(roomId);

        for (int hour = startHour; hour < endHour; hour++) {
            RoomAvailability availability = roomAvailabilityRepository.getByKey(roomId, date, hour);

            // Create new slot if doesn't exist
            if (availability == null) {
                availability = new RoomAvailability(
                        roomId, date, hour,
                        room.getCapacity(), room.getCapacity(),
                        RoomStatus.AVAILABLE
                );
                roomAvailabilityRepository.save(availability);
            }

            // Check if slot is available and has enough seats
            if (availability.getRoomStatus() != RoomStatus.AVAILABLE ||
                    availability.getAvailableSeats() < amenitiesCount) {
                return false;
            }
        }
        return true;
    }

    // Add this method to update availability
    public void updateAvailability(String roomId, Date startTime, Date endTime,
                                   int amenitiesCount, boolean isReserve) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(startTime);
        int startHour = calendar.get(Calendar.HOUR_OF_DAY);

        calendar.setTime(endTime);
        int endHour = calendar.get(Calendar.HOUR_OF_DAY);

        LocalDate date = startTime.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();

        for (int hour = startHour; hour < endHour; hour++) {
            RoomAvailability availability = roomAvailabilityRepository.getByKey(roomId, date, hour);

            if (availability == null) {
                Room room = roomService.getRoomById(roomId);
                availability = new RoomAvailability(
                        roomId, date, hour,
                        room.getCapacity(), room.getCapacity(),
                        RoomStatus.AVAILABLE
                );
                roomAvailabilityRepository.save(availability);
            }

            int newSeats = isReserve ?
                    availability.getAvailableSeats() - amenitiesCount :
                    availability.getAvailableSeats() + amenitiesCount;

            // Ensure we don't exceed capacity
            newSeats = Math.min(newSeats, availability.getCapacity());
            newSeats = Math.max(newSeats, 0);

            availability.setAvailableSeats(newSeats);

            // Simplified status update
            availability.setRoomStatus(
                    newSeats > 0 ? RoomStatus.AVAILABLE : RoomStatus.UNAVAILABLE
            );

            roomAvailabilityRepository.update(availability);
        }
    }

    public Map<String, Date> getWorkspaceOperatingHours(String workspaceId, Date date, boolean for_reserve) {
        Map<String, Date> operatingHours = new HashMap<>();
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);

        // Get day of week
        int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
        String[] days = {"SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY"};
        String dayName = days[dayOfWeek - 1];

        // Get workspace schedule
        WorkspaceSchedule schedule = workspaceScheduleService.getSchedule(workspaceId, dayName);

        try {
            SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
            Date startTime, endTime;

            if (schedule != null) {
                // Parse schedule times
                startTime = timeFormat.parse(schedule.getStartTime());
                endTime = timeFormat.parse(schedule.getEndTime());
            } else {
                // Default to full day
                startTime = timeFormat.parse("00:00");
                endTime = timeFormat.parse("23:59");
            }

            // Create Calendar instances for start and end times
            Calendar startCal = Calendar.getInstance();
            startCal.setTime(date);
            Calendar scheduleStartCal = Calendar.getInstance();
            scheduleStartCal.setTime(startTime);
            startCal.set(Calendar.HOUR_OF_DAY, scheduleStartCal.get(Calendar.HOUR_OF_DAY));
            startCal.set(Calendar.MINUTE, scheduleStartCal.get(Calendar.MINUTE));

            Calendar endCal = Calendar.getInstance();
            endCal.setTime(date);
            Calendar scheduleEndCal = Calendar.getInstance();
            scheduleEndCal.setTime(endTime);
            endCal.set(Calendar.HOUR_OF_DAY, scheduleEndCal.get(Calendar.HOUR_OF_DAY));
            endCal.set(Calendar.MINUTE, scheduleEndCal.get(Calendar.MINUTE));

            // If it's today and current time is after opening, use current time as start
            if(for_reserve){
                Calendar today = Calendar.getInstance();
                if (cal.get(Calendar.YEAR) == today.get(Calendar.YEAR) &&
                        cal.get(Calendar.DAY_OF_YEAR) == today.get(Calendar.DAY_OF_YEAR)) {
                    if (today.after(startCal)) {
                        startCal = today;
                    }
                }
            }

            operatingHours.put("startTime", startCal.getTime());
            operatingHours.put("endTime", endCal.getTime());

        } catch (ParseException e) {
            // Fallback to full day
            cal.set(Calendar.HOUR_OF_DAY, 0);
            cal.set(Calendar.MINUTE, 0);
            operatingHours.put("startTime", cal.getTime());

            cal.set(Calendar.HOUR_OF_DAY, 23);
            cal.set(Calendar.MINUTE, 59);
            operatingHours.put("endTime", cal.getTime());
        }

        return operatingHours;
    }

    public List<String> getUserIdsByWorkspaceIds(List<String> workspaceIds) {
        return reservationRepository.findUserIdsByWorkspaceIds(workspaceIds);
    }
}
