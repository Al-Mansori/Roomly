package org.example.roomly.model;
import org.springframework.stereotype.Component;

import java.util.Date;

@Component
public class Reservation {
    private String id;
    private Date reservationDate;
    private Date startTime;
    private Date endTime;
    private ReservationStatus status;
    private int amenitiesCount;
    private double totalCost;
    private Payment payment;
    private String AccessCode;
    private ReservationType reservationType;

    public Reservation(){}

    public Reservation(String id, Date reservationDate, Date startTime, Date endTime, ReservationStatus status, int amenitiesCount, double totalCost, Payment payment, String accessCode, ReservationType reservationType) {
        this.id = id;
        this.reservationDate = reservationDate;
        this.startTime = startTime;
        this.endTime = endTime;
        this.status = status;
        this.amenitiesCount = amenitiesCount;
        this.totalCost = totalCost;
        this.payment = payment;
        AccessCode = accessCode;
        this.reservationType = reservationType;
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

    public int getAmenitiesCount() {
        return amenitiesCount;
    }

    public void setAmenitiesCount(int amenitiesCount) {
        this.amenitiesCount = amenitiesCount;
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

    public String getAccessCode() {
        return AccessCode;
    }

    public void setAccessCode(String accessCode) {
        AccessCode = accessCode;
    }

    public ReservationType getReservationType() {
        return reservationType;
    }

    public void setReservationType(ReservationType reservationType) {
        this.reservationType = reservationType;
    }

    @Override
    public String toString() {
        return "Reservation{" +
                "id='" + id + '\'' +
                ", reservationDate=" + reservationDate +
                ", startTime=" + startTime +
                ", endTime=" + endTime +
                ", status=" + status +
                ", amenitiesCount=" + amenitiesCount +
                ", totalCost=" + totalCost +
                ", payment=" + payment +
                ", AccessCode='" + AccessCode + '\'' +
                ", reservationType=" + reservationType +
                '}';
    }
}