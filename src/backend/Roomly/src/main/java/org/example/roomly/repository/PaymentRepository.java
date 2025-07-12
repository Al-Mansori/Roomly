package org.example.roomly.repository;

import org.example.roomly.model.Payment;
import java.util.List;

public interface PaymentRepository {
    int save(Payment payment, String reservationId);
    Payment find(String id);
    List<Payment> findAll();
    int update(Payment payment);
    int delete(String id);
    Payment findByReservation(String reservationId);
}