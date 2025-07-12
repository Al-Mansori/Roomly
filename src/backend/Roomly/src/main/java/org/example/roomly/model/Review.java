package org.example.roomly.model;

import org.springframework.stereotype.Component;

import java.sql.Date;

@Component
public class Review {
    private String id;

    private double rating;

    private String comment;

    private Date reviewDate;
    private String userId;

    // constructors
    public Review(){}
//    public Review(String id, double rating, String comment, Date reviewDate) {
//        this.id = id;
//        this.rating = rating;
//        this.comment = comment;
//        this.reviewDate = reviewDate;
//    }

    public Review(String id, double rating, String comment, Date reviewDate, String userId) {
        this.id = id;
        this.rating = rating;
        this.comment = comment;
        this.reviewDate = reviewDate;
        this.userId = userId;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }
    //setters


    public void setId(String id) {
        this.id = id;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public void setComments(String comments) {
        this.comment = comments;
    }

    public void setReviewDate(Date reviewDate) {
        this.reviewDate = reviewDate;
    }

    //getters


    public String getId() {
        return id;
    }

    public double getRating() {
        return rating;
    }

    public String getComments() {
        return comment;
    }

    public Date getReviewDate() {
        return reviewDate;
    }


    @Override
    public String toString() {
        return "Review{" +
                "id='" + id + '\'' +
                ", rating=" + rating +
                ", comment='" + comment + '\'' +
                ", reviewDate=" + reviewDate +
                '}';
    }
}
