package org.example.roomly.service;

import org.example.roomly.model.Payment;
import org.example.roomly.model.Reservation;
import org.example.roomly.model.ReservationStatus;
import org.example.roomly.repository.ReservationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.UUID;

@Service
public class ReservationService {

    private ReservationRepository reservationRepository ;

    @Autowired
    public ReservationService(ReservationRepository reservationRepository) {
        this.reservationRepository = reservationRepository;
    }

    public  Reservation createReservation(Date startTime, Date endTime, double totalCost, ReservationStatus status, Payment payment){
        String reseervationId = UUID.randomUUID().toString();
        Date reservationDate = new Date();
        Reservation reservation = new Reservation(reseervationId, reservationDate, startTime, endTime, status, totalCost, payment);
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

    public void addBooking(String userId, String reservationId, String workspaceId, String roomId){
        reservationRepository.addBooking(userId, reservationId, workspaceId, roomId);
    }
    public void deleteBooking(String userId, String reservationId){
        reservationRepository.deleteBooking(userId, reservationId);
    }
}
