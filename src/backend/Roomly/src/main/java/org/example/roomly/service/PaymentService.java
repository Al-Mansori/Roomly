package org.example.roomly.service;

import org.example.roomly.model.Payment;
import org.example.roomly.model.PaymentStatus;
import org.example.roomly.repository.PaymentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.UUID;

@Service
public class PaymentService {

    private PaymentRepository paymentRepository ;

    @Autowired
    public PaymentService(PaymentRepository paymentRepository) {
        this.paymentRepository = paymentRepository;
    }

    public Payment createPayment(String paymentMethod, double amount, PaymentStatus status){
        String paymentId = UUID.randomUUID().toString();
        Date paymentDate = new Date();
        Payment payment = new Payment(paymentId, paymentMethod, paymentDate, amount, status);
        return payment;
    }

    public void savePayment(Payment payment, String reservationId){
        paymentRepository.save(payment, reservationId);
    }

    public void deletePayment(String id){
        paymentRepository.delete(id);
    }

    public void updatePayment(Payment payment){
        paymentRepository.update(payment);
    }

    public Payment getPayment(String id){
        return paymentRepository.find(id);
    }

    public List<Payment> getAll(){
        return paymentRepository.findAll();
    }
}
