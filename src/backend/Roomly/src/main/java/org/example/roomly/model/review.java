package org.example.roomly.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.sql.Date;

@Entity
@Table(name="Review")
public class review {
    @Id
    @Column(name="ReviewId")
    private int reviewId;

    @Column(name="UserId")
    private int userId;

    @Column(name="WorkspaceId")
    private int workspaceId;

    @Column(name="Rating")
    private double rating;

    @Column(name="Comments")
    private String comments;

    @Column(name="ReviewDate")
    private Date reviewDate;

    // constructors
    public review(){}

    public review(int reviewId, int userId, int workspaceId, double rating, String comments, Date reviewDate) {
        this.reviewId = reviewId;
        this.userId = userId;
        this.workspaceId = workspaceId;
        this.rating = rating;
        this.comments = comments;
        this.reviewDate = reviewDate;
    }

    //setters


    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public void setWorkspaceId(int workspaceId) {
        this.workspaceId = workspaceId;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }

    public void setReviewDate(Date reviewDate) {
        this.reviewDate = reviewDate;
    }

    //getters


    public int getReviewId() {
        return reviewId;
    }

    public int getUserId() {
        return userId;
    }

    public int getWorkspaceId() {
        return workspaceId;
    }

    public double getRating() {
        return rating;
    }

    public String getComments() {
        return comments;
    }

    public Date getReviewDate() {
        return reviewDate;
    }
}
