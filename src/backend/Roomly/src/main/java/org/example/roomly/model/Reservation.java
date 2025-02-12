package org.example.roomly.model;
import java.util.Date;

public class Reservation {
    private String id;
    private Date reservationDate;
    private Date startTime;
    private Date endTime;
    private ReservationStatus status;
    private double totalCost;
    private Payment payment;

    public Reservation(){}

    public Reservation(String id, Date reservationDate, Date startTime, Date endTime, ReservationStatus status, double totalCost, Payment payment) {
        this.id = id;
        this.reservationDate = reservationDate;
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

    public Date getReservationDate() {
        return reservationDate;
    }

    public void setReservationDate(Date reservationDate) {
        this.reservationDate = reservationDate;
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

    public ReservationStatus getStatus() {
        return status;
    }

    public void setStatus(ReservationStatus status) {
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

    @Override
    public String toString() {
        return "Reservation{" +
                "id='" + id + '\'' +
                ", reservationDate=" + reservationDate +
                ", startTime=" + startTime +
                ", endTime=" + endTime +
                ", status=" + status +
                ", totalCost=" + totalCost +
                ", payment=" + payment +
                '}';
    }
}