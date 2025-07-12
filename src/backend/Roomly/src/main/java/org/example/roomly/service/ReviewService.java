package org.example.roomly.service;

import org.example.roomly.model.Review;
import org.example.roomly.repository.ReviewRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.Date;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Service
public class ReviewService {
    private final ReviewRepository reviewRepository;

    @Autowired
    public ReviewService(ReviewRepository reviewRepository) {
        this.reviewRepository = reviewRepository;
    }

    public Review createReview(double rating, String comment, String userId){
        String id = UUID.randomUUID().toString();
        Date today = Date.valueOf(LocalDate.now());
        Review review = new Review(id,rating,comment,today, userId);
        return review;
    }
    public int saveReview(Review review, String userId, String workspaceId) {
        return reviewRepository.save(review, userId, workspaceId);
    }

    public Review getReviewById(String id) {
        return reviewRepository.find(id);
    }

    public List<Review> getAllReviews() {
        return reviewRepository.findAll();
    }

    public List<Review> getWorkspaceReviews(String workspaceId){
        return reviewRepository.findWorkspaceReviews(workspaceId);
    }

    public int updateReview(Review review) {
        return reviewRepository.update(review);
    }

    public int deleteReview(String id) {
        return reviewRepository.delete(id);
    }
}