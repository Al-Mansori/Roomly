package org.example.roomly.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import org.springframework.beans.factory.annotation.Autowired;

import java.sql.Date;
import java.time.LocalDate;

public class review {
    private String id;

    private double rating;

    private String comment;

    private LocalDate reviewDate;

    private String userId;

    private String workspaceId;

    // constructors
    public review(){}
    public review(String reviewId, String userId, String workspaceId, double rating, String comment, LocalDate reviewDate) {
        this.id = reviewId;
        this.userId = userId;
        this.workspaceId = workspaceId;
        this.rating = rating;
        this.comment = comment;
        this.reviewDate = reviewDate;
    }

    //setters


    public void setReviewId(String reviewId) {
        this.id = reviewId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public void setWorkspaceId(String workspaceId) {
        this.workspaceId = workspaceId;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public void setComments(String comments) {
        this.comment = comments;
    }

    public void setReviewDate(LocalDate reviewDate) {
        this.reviewDate = reviewDate;
    }

    //getters


    public String getReviewId() {
        return id;
    }

    public String getUserId() {
        return userId;
    }

    public String getWorkspaceId() {
        return workspaceId;
    }

    public double getRating() {
        return rating;
    }

    public String getComments() {
        return comment;
    }

    public LocalDate getReviewDate() {
        return reviewDate;
    }
}
