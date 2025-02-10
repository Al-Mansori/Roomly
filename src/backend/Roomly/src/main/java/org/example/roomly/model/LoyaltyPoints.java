package org.example.roomly.model;

import java.util.Date;

public class LoyaltyPoints {
    private int totalPoints;
    private int lastAddedPoint;
    private Date lastUpdatedDate;
    private String userId;

    public LoyaltyPoints() {}

    public LoyaltyPoints(int totalPoints, int lastAddedPoint, Date lastUpdatedDate, String userId) {
        this.totalPoints = totalPoints;
        this.lastAddedPoint = lastAddedPoint;
        this.lastUpdatedDate = lastUpdatedDate;
        this.userId = userId;
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
                ", totalPoints=" + totalPoints +
                ", lastAddedPoint=" + lastAddedPoint +
                ", lastUpdatedDate=" + lastUpdatedDate +
                ", userId='" + userId + '\'' +
                '}';
    }
}