package org.example.roomly.repository;

import org.example.roomly.model.Reservation;

import java.sql.Timestamp;
import java.util.List;
import java.util.Map;

public interface ReservationRepository {
    int save(Reservation reservation);
    Reservation find(String id);
    List<Reservation> findAll();
    int update(Reservation reservation);
    int delete(String id);
    void saveBooking(String userId, String reservationId, String workspaceId, String roomId);
    void deleteBooking(String userId, String reservationId);
    Map<String, Object> getBooking(String userId, String reservationId);
    // Help for Scheduling service to find all expired reservations
    Map<String, Object> getReservedBooking(String reservationId);
    public int CancelReservation(double fees, Timestamp cancellationDate, String userId, String reservationId);
    public int deleteCancellation(String reservationId);
    List<Reservation> findReservationsByUserId(String userId);
    List<Reservation> findCancelledReservationsByUserId(String userId);
    List<Reservation> findReservationsByWorkspaceId(String workspaceId);
    List<Reservation> findCancelledReservationsByWorkspaceId(String workspaceId);
    List<Map<String, Object>> findReservationsWithBookingByUserId(String userId);

    // Method for the scheduling service to find all expired reservations
    List<Reservation> findExpiredReservations(Timestamp currentTime);

    // method for recovery schedule
    List<Reservation> findReservationsByRoomId(String roomId);

    List<String> findUserIdsByWorkspaceIds(List<String> workspaceIds);
}
