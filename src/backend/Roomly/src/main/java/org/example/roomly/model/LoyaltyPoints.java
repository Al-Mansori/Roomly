package org.example.roomly.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.util.Date;

@Entity
@Table(name = "LoyaltyPoints")
public class LoyaltyPoints {

    @Id
    @Column(name = "Id")
    private String pointsId;

    @Column(name = "TotalPoints")
    private int totalPoints;

    @Column(name = "LastAddedPoint")
    private int lastAddedPoint;

    @Column(name = "LastUpdatedDate")
    private Date lastUpdatedDate;

    @Column(name = "UserId")
    private String userId;

    public LoyaltyPoints() {}

    public LoyaltyPoints(String pointsId, int totalPoints, int lastAddedPoint, Date lastUpdatedDate, String userId) {
        this.pointsId = pointsId;
        this.totalPoints = totalPoints;
        this.lastAddedPoint = lastAddedPoint;
        this.lastUpdatedDate = lastUpdatedDate;
        this.userId = userId;
    }

    public String getPointsId() {
        return pointsId;
    }

    public void setPointsId(String pointsId) {
        this.pointsId = pointsId;
    }

    public int getTotalPoints() {
        return totalPoints;
    }

    public void setTotalPoints(int totalPoints) {
        this.totalPoints = totalPoints;
    }

    public int getLastAddedPoint() {
        return lastAddedPoint;
    }

    public void setLastAddedPoint(int lastAddedPoint) {
        this.lastAddedPoint = lastAddedPoint;
    }

    public Date getLastUpdatedDate() {
        return lastUpdatedDate;
    }

    public void setLastUpdatedDate(Date lastUpdatedDate) {
        this.lastUpdatedDate = lastUpdatedDate;
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
                ", totalPoints=" + totalPoints +
                ", lastAddedPoint=" + lastAddedPoint +
                ", lastUpdatedDate=" + lastUpdatedDate +
                ", userId='" + userId + '\'' +
                '}';
    }
}