package org.example.roomly.repository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import org.example.roomly.model.Payment;
import org.example.roomly.model.PaymentStatus;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;

@Repository
public class PaymentRepo {
    private EntityManager entityManager;
    public PaymentRepo(EntityManager e){
        entityManager = e;
    }

    public String save(Payment payment){
        entityManager.persist(payment);
        return "saved successfully";
    }

    public Payment findByBookingId(int id){
        return entityManager.find(Payment.class,id);
    }

    public List<Payment> findByStatus(PaymentStatus paymentStatus){
        TypedQuery<Payment> query = entityManager.createQuery("FROM payment WHERE PaymentStatus =:theStatus",Payment.class);
        query.setParameter("theStatus",paymentStatus);
        return query.getResultList();
    }
    public Payment updatePaymentStatus(int id, PaymentStatus status){
        Payment payment = entityManager.find(Payment.class,id);
        payment.setStatus(status);
        entityManager.merge(payment);
        return payment;
    }
}
