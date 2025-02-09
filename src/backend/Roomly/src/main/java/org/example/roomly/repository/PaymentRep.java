package org.example.roomly.repository;

import org.example.roomly.model.Payment;
import org.example.roomly.model.PaymentStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface PaymentRep extends JpaRepository<Payment,Integer> {
    @Query(value = "select * from payment where PaymentStatus=:status",nativeQuery = true)
    List<Payment> findByStatus(@Param("status")PaymentStatus status);

    //findByBookingId postponed//
    @Query("UPDATE payment set PaymentStatus=:newStatus")
    Payment updateStatus(@Param("newStatus")PaymentStatus newStatus);
}
