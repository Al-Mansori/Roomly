package org.example.roomly.repository;

import org.example.roomly.model.Review;
import java.util.List;

public interface ReviewRepository {
    int save(Review review);
    Review find(String id);
    List<Review> findAll();
    int update(Review review);
    int delete(String id);
}
