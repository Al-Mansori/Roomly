package org.example.roomly.model;

import jakarta.persistence.*;
import java.util.Date;

public class Payment {
    private String id; // Change type to String to match SQL schema

    private String paymentMethod;

    private Date paymentDate;

    private double amount;

    private PaymentStatus status; // Change type to String to match SQL schema

    // Constructors
    public Payment() {}

    public Payment(String id, String paymentMethod, Date paymentDate, double amount, PaymentStatus status) {
        this.id = id;
        this.paymentMethod = paymentMethod;
        this.paymentDate = paymentDate;
        this.amount = amount;
        this.status = status;
    }

    // Getters and Setters

    public String getPaymentId() {
        return id;
    }

    public void setPaymentId(String paymentId) {
        this.id = paymentId;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public Date getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(Date paymentDate) {
        this.paymentDate = paymentDate;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public PaymentStatus getStatus() {
        return status;
    }

    public void setStatus(PaymentStatus status) {
        this.status = status;
    }
}