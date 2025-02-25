package org.example.roomly.repository;

import org.example.roomly.model.Reservation;
import java.util.List;

public interface ReservationRepository {
    int save(Reservation reservation);
    Reservation find(String id);
    List<Reservation> findAll();
    int update(Reservation reservation);
    int delete(String id);
    void addBooking(String userId, String reservationId, String workspaceId, String roomId);
    void deleteBooking(String userId, String reservationId);
}
