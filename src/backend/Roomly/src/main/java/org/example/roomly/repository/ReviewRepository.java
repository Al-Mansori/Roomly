package org.example.roomly.repository;

import org.example.roomly.model.Review;
import org.springframework.jdbc.core.JdbcTemplate;

import java.util.Date;
import java.util.List;

public class ReviewRepository {
    private final JdbcTemplate jdbcTemplate;

    public ReviewRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public int save(Review review) {
        String sql = "INSERT INTO review (Id, Rating, Comment, ReviewDate, UserId, WorkspaceId) VALUES (?, ?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql, review.getReviewId(), review.getRating(), review.getComments(), review.getReviewDate(), review.getUserId(), review.getWorkspaceId());
    }

    public Review find(String id) {
        String sql = "SELECT * FROM review WHERE Id = ?";
        return jdbcTemplate.queryForObject(sql, (rs, rowNum) -> new Review(
                rs.getString("Id"),
                rs.getString("UserId"),
                rs.getString("WorkspaceId"),
                rs.getDouble("Rating"),
                rs.getString("Comment"),
                rs.getDate("ReviewDate")
        ), id);
    }

    public List<Review> findAll() {
        String sql = "SELECT * FROM review";
        return jdbcTemplate.query(sql, (rs, rowNum) -> new Review(
                rs.getString("Id"),
                rs.getString("UserId"),
                rs.getString("WorkspaceId"),
                rs.getDouble("Rating"),
                rs.getString("Comment"),
                rs.getDate("ReviewDate")
        ));
    }

    public int update(Review review) {
        String sql = "UPDATE review SET Rating = ?, Comment = ?, ReviewDate = ? WHERE Id = ?";
        return jdbcTemplate.update(sql, review.getRating(), review.getComments(), review.getReviewDate(), review.getReviewId());
    }

    public int delete(String id) {
        String sql = "DELETE FROM review WHERE Id = ?";
        return jdbcTemplate.update(sql, id);
    }
}
