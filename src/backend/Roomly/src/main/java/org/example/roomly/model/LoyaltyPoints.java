package org.example.roomly.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.util.Date;

@Entity
@Table(name = "loyaltypoints")
public class LoyaltyPoints {

    @Id
    @Column(name = "PointsId")
    private String pointsId;

    @Column(name = "Points")
    private int points;

    @Column(name = "StartDate")
    private Date startDate;

    @Column(name = "ExpiryDate")
    private Date expiryDate;

    @Column(name = "UserId")
    private String userId;

    public LoyaltyPoints() {}

    public LoyaltyPoints(String pointsId, int points, Date startDate, Date expiryDate, String userId) {
        this.pointsId = pointsId;
        this.points = points;
        this.startDate = startDate;
        this.expiryDate = expiryDate;
        this.userId = userId;
    }

    public String getPointsId() {
        return pointsId;
    }

    public void setPointsId(String pointsId) {
        this.pointsId = pointsId;
    }

    public int getPoints() {
        return points;
    }

    public void setPoints(int points) {
        this.points = points;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    @Override
    public String toString() {
        return "LoyaltyPoints{" +
                "pointsId='" + pointsId + '\'' +
                ", points=" + points +
                ", startDate=" + startDate +
                ", expiryDate=" + expiryDate +
                ", userId='" + userId + '\'' +
                '}';
    }
}
