package org.example.roomly.repository;

import org.example.roomly.model.Review;
import java.util.List;

public interface ReviewRepository {
    int save(Review review, String userId, String workspaceId);
    Review find(String id);
    List<Review> findAll();
    public List<Review> findWorkspaceReviews(String workspaceId);
    int update(Review review);
    int delete(String id);
}
