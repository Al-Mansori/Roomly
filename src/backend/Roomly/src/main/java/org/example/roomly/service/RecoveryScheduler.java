package org.example.roomly.service;

import org.example.roomly.model.*;
import org.example.roomly.repository.ReservationRepository;
import org.example.roomly.repository.RoomRepository;
import org.example.roomly.service.PaymentService;
import org.example.roomly.service.RecoveryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.sql.Timestamp;
import java.util.List;

@Component
public class RecoveryScheduler {

    private final RecoveryService recoveryService;
    private final ReservationRepository reservationRepository;
    private final RoomRepository roomRepository;
    private final PaymentService paymentService;

    @Autowired
    public RecoveryScheduler(RecoveryService recoveryService,
                             ReservationRepository reservationRepository,
                             RoomRepository roomRepository,
                             PaymentService paymentService) {
        this.recoveryService = recoveryService;
        this.reservationRepository = reservationRepository;
        this.roomRepository = roomRepository;
        this.paymentService = paymentService;
    }

//    @Scheduled(fixedRate = 1800000) // Every 30 minutes (30 * 60 * 1000 ms)
    @Scheduled(fixedRate = 1800000) // Every 30 minutes (30 * 60 * 1000 ms)
    public void checkRecoveryRooms() {
        System.out.println("[RecoveryScheduler] Start checkRecoveryRooms");
        List<String> recoveryRoomIds = recoveryService.getAllRecoveryRoomIds();
        System.out.println("[RecoveryScheduler] Recovery room IDs: " + recoveryRoomIds);

        for (String roomId : recoveryRoomIds) {
            System.out.println("[RecoveryScheduler] Processing room in recovery: " + roomId);
            // Get all reservations for this room that are PENDING or CONFIRMED
            List<Reservation> reservations = reservationRepository.findReservationsByRoomId(roomId)
                    .stream()
                    .filter(r -> r.getStatus() == ReservationStatus.PENDING ||
                            r.getStatus() == ReservationStatus.CONFIRMED)
                    .toList();
            System.out.println("[RecoveryScheduler] Found " + reservations.size() + " reservations for room: " + roomId);

            for (Reservation reservation : reservations) {
                System.out.println("[RecoveryScheduler] Processing reservation: " + reservation.getId());
                System.out.println("[RecoveryScheduler] Reservation status: " + reservation.getStatus());
                // Update reservation status to CANCELLED
                reservation.setStatus(ReservationStatus.CANCELLED);
                System.out.println("[RecoveryScheduler] Updating reservation status to CANCELLED: " + reservation.getId());
                System.out.println("[RecoveryScheduler] Current reservation status: " + reservation.getStatus());
                reservationRepository.update(reservation);
                System.out.println("[RecoveryScheduler] Reservation status updated to CANCELLED: " + reservation.getId());

                // Update payment status to CANCELLED
                Payment payment = paymentService.getByReservation(reservation.getId());
                System.out.println("[RecoveryScheduler] Payment for reservation: " + reservation.getId() + " is " + (payment != null ? "found" : "not found"));
                System.out.println("[RecoveryScheduler] Payment status: " + (payment != null ? payment.getStatus() : "N/A"));
                if (payment != null) {
                    payment.setStatus(PaymentStatus.CANCELLED);
                    System.out.println("[RecoveryScheduler] Updating payment status to CANCELLED: " + payment.getId());
                    paymentService.updatePayment(payment);
                    System.out.println("[RecoveryScheduler] Payment status updated to CANCELLED: " + payment.getId());
                }
            }

            // Update room available count to equal capacity
            Room room = roomRepository.getById(roomId);
            System.out.println("[RecoveryScheduler] Updating room available count for room: " + roomId);
            System.out.println("[RecoveryScheduler] Current available count: " + room.getAvailableCount());
            room.setAvailableCount(room.getCapacity());
            System.out.println("[RecoveryScheduler] New available count: " + room.getAvailableCount());
            roomRepository.update(room);
            System.out.println("[RecoveryScheduler] Room available count updated for room: " + roomId);
            System.out.println("[RecoveryScheduler] End processing room in recovery: " + roomId);
        }
        System.out.println("[RecoveryScheduler] End checkRecoveryRooms");
    }
}