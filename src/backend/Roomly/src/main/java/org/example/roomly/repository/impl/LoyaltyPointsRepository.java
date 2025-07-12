package org.example.roomly.repository.impl;

import org.example.roomly.model.LoyaltyPoints;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.Timestamp;
import java.util.Optional;

@Repository
public class LoyaltyPointsRepository implements org.example.roomly.repository.LoyaltyPointsRepository {
    private final JdbcTemplate jdbcTemplate;

    public LoyaltyPointsRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // 1. Add a new LoyaltyPoints record
    @Override
    public void save(LoyaltyPoints loyaltyPoints) {
        String sql = "INSERT INTO LoyaltyPoints (TotalPoints, LastAddedPoint, LastUpdatedDate, UserId) VALUES (?, ?, ?, ?)";
        jdbcTemplate.update(sql, loyaltyPoints.getTotalPoints(), loyaltyPoints.getLastAddedPoint(),
                new Timestamp(loyaltyPoints.getLastUpdatedDate().getTime()), loyaltyPoints.getUserId());
    }

    // 2. Retrieve LoyaltyPoints by userId
    @Override
    public LoyaltyPoints findById(String userId) {
        String sql = "SELECT * FROM LoyaltyPoints WHERE UserId = ?";
        try {
            return jdbcTemplate.queryForObject(sql, new LoyaltyPointsRowMapper(), userId);
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    // 3. Update LoyaltyPoints for a specific user
    @Override
    public void update(LoyaltyPoints loyaltyPoints) {
        String sql = "UPDATE LoyaltyPoints SET TotalPoints = ?, LastAddedPoint = ?, LastUpdatedDate = ? WHERE UserId = ?";
        jdbcTemplate.update(sql, loyaltyPoints.getTotalPoints(), loyaltyPoints.getLastAddedPoint(),
                new Timestamp(loyaltyPoints.getLastUpdatedDate().getTime()), loyaltyPoints.getUserId());
    }

    // 4. Delete LoyaltyPoints record for a user
    @Override
    public void deleteById(String userId) {
        String sql = "DELETE FROM LoyaltyPoints WHERE UserId = ?";
        jdbcTemplate.update(sql, userId);
    }

    // 5. Get all LoyaltyPoints records
    @Override
    public List<LoyaltyPoints> findAll() {
        String sql = "SELECT * FROM LoyaltyPoints";
        return jdbcTemplate.query(sql, new LoyaltyPointsRowMapper());
    }

    private static class LoyaltyPointsRowMapper implements RowMapper<LoyaltyPoints> {
        @Override
        public LoyaltyPoints mapRow(ResultSet rs, int rowNum) throws SQLException {
            LoyaltyPoints loyaltyPoints = new LoyaltyPoints();
            loyaltyPoints.setUserId(rs.getString("UserId"));
            loyaltyPoints.setTotalPoints(rs.getInt("TotalPoints"));
            loyaltyPoints.setLastAddedPoint(rs.getInt("LastAddedPoint"));
            loyaltyPoints.setLastUpdatedDate(rs.getTimestamp("LastUpdatedDate"));
            return loyaltyPoints;
        }
    }
}
