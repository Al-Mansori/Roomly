// RecoveryRepositoryImpl.java
package org.example.roomly.repository.impl;

import org.example.roomly.repository.RecoveryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public class RecoveryRepositoryImpl implements RecoveryRepository {

    private final JdbcTemplate jdbcTemplate;

    @Autowired
    public RecoveryRepositoryImpl(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public boolean isRoomInRecovery(String roomId) {
        String sql = "SELECT COUNT(*) FROM Recovery WHERE RoomId = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, roomId);
        return count != null && count > 0;
    }

    @Override
    public void addRoomToRecovery(String roomId, String reason) {
        String sql = "INSERT INTO Recovery (RoomId, RecoveryRoomId, Reason) VALUES (?, ?, ?)";
        jdbcTemplate.update(sql, roomId, "rm001", reason);
    }

    @Override
    public void removeRoomFromRecovery(String roomId) {
        String sql = "DELETE FROM Recovery WHERE RoomId = ?";
        jdbcTemplate.update(sql, roomId);
    }

    @Override
    public List<String> getAllRecoveryRoomIds() {
        String sql = "SELECT RoomId FROM Recovery";
        return jdbcTemplate.queryForList(sql, String.class);
    }
}