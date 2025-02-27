package org.example.roomly.repository.impl;

import org.example.roomly.model.Review;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.util.List;

@Repository
public class ReviewRepository implements org.example.roomly.repository.ReviewRepository {
    private final JdbcTemplate jdbcTemplate;

    public ReviewRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public int save(Review review, String userId, String workspaceId) {
        String sql = "INSERT INTO review (Id, Rating, Comment, ReviewDate, UserId, WorkspaceId) VALUES (?, ?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql, review.getId(), review.getRating(), review.getComments(), review.getReviewDate(), userId, workspaceId);
    }

    @Override
    public Review find(String id) {
        String sql = "SELECT * FROM review WHERE Id = ?";
        return jdbcTemplate.queryForObject(sql, new ReviewRowMapper(), id);
    }

    @Override
    public List<Review> findAll() {
        String sql = "SELECT * FROM review";
        return jdbcTemplate.query(sql, new ReviewRowMapper());
    }

    @Override
    public int update(Review review) {
        String sql = "UPDATE review SET Rating = ?, Comment = ?, ReviewDate = ? WHERE Id = ?";
        return jdbcTemplate.update(sql, review.getRating(), review.getComments(), review.getReviewDate(), review.getId());
    }

    @Override
    public int delete(String id) {
        String sql = "DELETE FROM review WHERE Id = ?";
        return jdbcTemplate.update(sql, id);
    }

    private static class ReviewRowMapper implements RowMapper<Review> {
        @Override
        public Review mapRow(ResultSet rs, int rowNum) throws SQLException {
            Review review = new Review();
            review.setId(rs.getString("Id"));
            review.setRating(rs.getDouble("Rating"));
            review.setComments(rs.getString("Comment"));
            review.setReviewDate(rs.getDate("ReviewDate"));
            return review;
        }
    }

}
