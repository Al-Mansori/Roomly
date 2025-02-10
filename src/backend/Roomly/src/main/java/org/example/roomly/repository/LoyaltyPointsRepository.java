package org.example.roomly.repository;

import org.example.roomly.model.LoyaltyPoints;

import java.util.List;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.Timestamp;
import java.util.Optional;

@Repository
public class LoyaltyPointsRepository {
    private final JdbcTemplate jdbcTemplate;

    public LoyaltyPointsRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private final RowMapper<LoyaltyPoints> rowMapper = (rs, rowNum) -> new LoyaltyPoints(
            rs.getInt("TotalPoints"),
            rs.getInt("LastAddedPoint"),
            rs.getTimestamp("LastUpdatedDate"),
            rs.getString("UserId")
    );

    // 1. Add a new LoyaltyPoints record
    public void save(LoyaltyPoints loyaltyPoints) {
        String sql = "INSERT INTO LoyaltyPoints (TotalPoints, LastAddedPoint, LastUpdatedDate, UserId) VALUES (?, ?, ?, ?)";
        jdbcTemplate.update(sql, loyaltyPoints.getTotalPoints(), loyaltyPoints.getLastAddedPoint(),
                new Timestamp(loyaltyPoints.getLastUpdatedDate().getTime()), loyaltyPoints.getUserId());
    }

    // 2. Retrieve LoyaltyPoints by userId
    public Optional<LoyaltyPoints> findById(String userId) {
        String sql = "SELECT * FROM LoyaltyPoints WHERE UserId = ?";
        return jdbcTemplate.query(sql, rowMapper, userId).stream().findFirst();
    }

    // 3. Update LoyaltyPoints for a specific user
    public void update(LoyaltyPoints loyaltyPoints) {
        String sql = "UPDATE LoyaltyPoints SET TotalPoints = ?, LastAddedPoint = ?, LastUpdatedDate = ? WHERE UserId = ?";
        jdbcTemplate.update(sql, loyaltyPoints.getTotalPoints(), loyaltyPoints.getLastAddedPoint(),
                new Timestamp(loyaltyPoints.getLastUpdatedDate().getTime()), loyaltyPoints.getUserId());
    }

    // 4. Delete LoyaltyPoints record for a user
    public void deleteById(String userId) {
        String sql = "DELETE FROM LoyaltyPoints WHERE UserId = ?";
        jdbcTemplate.update(sql, userId);
    }

    // 5. Get all LoyaltyPoints records
    public List<LoyaltyPoints> findAll() {
        String sql = "SELECT * FROM LoyaltyPoints";
        return jdbcTemplate.query(sql, rowMapper);
    }
}
