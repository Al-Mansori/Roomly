package org.example.roomly.service;

import org.example.roomly.model.Reservation;
import org.example.roomly.model.ReservationStatus;
import org.example.roomly.model.Room;
import org.example.roomly.model.RoomStatus;
import org.example.roomly.repository.ReservationRepository;
import org.example.roomly.repository.RoomRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Timestamp;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
public class ReservationCheckService {

    private final ReservationRepository reservationRepository;
    private final RoomRepository roomRepository;

    @Autowired
    public ReservationCheckService(ReservationRepository reservationRepository, RoomRepository roomRepository) {
        this.reservationRepository = reservationRepository;
        this.roomRepository = roomRepository;
    }

    // Run every 30 minutes (1800000 milliseconds)
    @Scheduled(fixedRate = 1800000) // 300000 milliseconds = 5 minutes
    @Transactional
    public void checkAndUpdateExpiredReservations() {
        System.out.println("[ReservationCheckService] Start checkAndUpdateExpiredReservations");
        Date now = new Date();
        Timestamp currentTimestamp = new Timestamp(now.getTime());

        // Get all reservations that are not completed or cancelled and have ended
        List<Reservation> expiredReservations = reservationRepository.findAll().stream()
                .filter(reservation ->
                        reservation.getStatus() != ReservationStatus.COMPLETED &&
                                reservation.getStatus() != ReservationStatus.CANCELLED &&
                                reservation.getEndTime().before(currentTimestamp)
                )
                .toList();

        for (Reservation reservation : expiredReservations) {
            // Update reservation status to CANCELLED
            reservation.setStatus(ReservationStatus.CANCELLED);
            reservationRepository.update(reservation);

            // Get the associated room through booking
            Map<String, Object> booking = reservationRepository.getReservedBooking(reservation.getId());
            if (booking != null && booking.containsKey("roomId")) {
                String roomId = (String) booking.get("roomId");
                Room room = roomRepository.getById(roomId);

                if (room != null) {
                    // Increase available count by amenities count
                    int newAvailableCount = room.getAvailableCount() + reservation.getAmenitiesCount();
                    room.setAvailableCount(newAvailableCount);

                    // If room was unavailable, set to available if now has capacity
                    if (room.getStatus() == RoomStatus.UNAVAILABLE && newAvailableCount > 0) {
                        room.setStatus(RoomStatus.AVAILABLE);
                    }

                    roomRepository.update(room);
                }
            }
        }
    }
}
