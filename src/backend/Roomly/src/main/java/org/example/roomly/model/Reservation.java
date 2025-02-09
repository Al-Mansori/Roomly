package org.example.roomly.model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Reservation") // Match the table name in SQL schema
public class Reservation {
    @Id
    @Column(name = "Id") // Match the column name in SQL schema
    private String id;

    @Column(name = "BookingDate") // Match the column name in SQL schema
    private Date bookingDate;

    @Column(name = "StartTime") // Match the column name in SQL schema
    private Date startTime;

    @Column(name = "EndTime") // Match the column name in SQL schema
    private Date endTime;

    @Column(name = "Status") // Match the column name in SQL schema
    private String status; // Change type to String to match SQL schema

    @Column(name = "TotalCost") // Match the column name in SQL schema
    private double totalCost;

    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "paymentId", referencedColumnName = "Id") // Match the foreign key in SQL schema
    private Payment payment;

    public Reservation(){}

    public Reservation(String id, Date bookingDate, Date startTime, Date endTime, String status, double totalCost, Payment payment) {
        this.id = id;
        this.bookingDate = bookingDate;
        this.startTime = startTime;
        this.endTime = endTime;
        this.status = status;
        this.totalCost = totalCost;
        this.payment = payment;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Date getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(Date bookingDate) {
        this.bookingDate = bookingDate;
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public double getTotalCost() {
        return totalCost;
    }

    public void setTotalCost(double totalCost) {
        this.totalCost = totalCost;
    }

    public Payment getPayment() {
        return payment;
    }

    public void setPayment(Payment payment) {
        this.payment = payment;
    }
}