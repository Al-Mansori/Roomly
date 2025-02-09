package org.example.roomly.repository;

import org.example.roomly.model.Payment;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PaymentRep extends JpaRepository<Payment,Integer> {
}
