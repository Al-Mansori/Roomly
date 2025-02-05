package org.example.roomly.model;

import java.util.Date;

public class Reservation {
    private String id;
    private Date startTime;
    private Date endTime;
    private double totalCost;
    private ReservationStatus status;
    private Payment payment;
    private Date cancellationDate;
    private double fees;

    // Constructor
    public Reservation(String id, Date startTime, Date endTime, double totalCost, Payment payment) {
        this.id = id;
        this.startTime = startTime;
        this.endTime = endTime;
        this.totalCost = totalCost;
        this.payment = payment;
        this.status = ReservationStatus.CONFIRMED;
        this.cancellationDate = null;
        this.fees = 0;
    }

    // Getters and Setters
    public String getBookingId() {
        return id;
    }

    public void setBookingId(String id) {
        this.id = id;
    }

    public Date getStartTime() {
        return startTime;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public Date getEndTime() {
        return endTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    public double getTotalCost() {
        return totalCost;
    }

    public void setTotalCost(double totalCost) {
        this.totalCost = totalCost;
    }

    public ReservationStatus getStatus() {
        return status;
    }

    public void setStatus(ReservationStatus status) {
        this.status = status;
    }

    public Payment getPayment() {
        return payment;
    }

    public void setPayment(Payment payment) {
        this.payment = payment;
    }

    public Date getCancellationDate() {
        return cancellationDate;
    }

    public void setCancellationDate(Date cancellationDate) {
        this.cancellationDate = cancellationDate;
    }

    public double getFees() {
        return fees;
    }

    public void setFees(double fees) {
        this.fees = fees;
    }
}
