package org.example.roomly.repository;

import org.example.roomly.model.Reservation;

import java.sql.Timestamp;
import java.util.List;

public interface ReservationRepository {
    int save(Reservation reservation);
    Reservation find(String id);
    List<Reservation> findAll();
    int update(Reservation reservation);
    int delete(String id);
    void saveBooking(String userId, String reservationId, String workspaceId, String roomId);
    void deleteBooking(String userId, String reservationId);
    public int CancelReservation(double fees, Timestamp cancellationDate, String userId, String reservationId);
    public int deleteCancellation(String reservationId);

}
