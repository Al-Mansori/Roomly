package org.example.roomly.service;

import org.example.roomly.model.Payment;
import org.example.roomly.model.Reservation;
import org.example.roomly.model.ReservationStatus;
import org.example.roomly.repository.ReservationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@Service
public class ReservationService {

    @Autowired
    private ReservationRepository reservationRepository ;

//    @Autowired
//    public ReservationService(ReservationRepository reservationRepository) {
//        this.reservationRepository = reservationRepository;
//    }

    public  Reservation createReservation(Date startTime, Date endTime, double totalCost, ReservationStatus status, int amenitiesCount, Payment payment){
        String reseervationId = UUID.randomUUID().toString();
        Date reservationDate = new Date();
        Reservation reservation = new Reservation(reseervationId, reservationDate, startTime, endTime, status, amenitiesCount, totalCost, payment);
        return reservation;
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

    public void CancelReservation(double fees, Timestamp cancellationDate, String userId, String reservationId) {
        reservationRepository.CancelReservation(fees, cancellationDate, userId ,reservationId);
    }

    public void deleteCancellation(String reservationId) {
        reservationRepository.deleteCancellation(reservationId);
    }
}
