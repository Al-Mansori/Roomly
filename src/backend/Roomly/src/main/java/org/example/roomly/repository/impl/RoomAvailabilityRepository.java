package org.example.roomly.repository.impl;

import org.example.roomly.model.RoomAvailability;
import org.example.roomly.model.RoomStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

@Repository
public class RoomAvailabilityRepository implements org.example.roomly.repository.RoomAvailabilityRepository {

    private final JdbcTemplate jdbcTemplate;

    @Autowired
    public RoomAvailabilityRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public void save(RoomAvailability availability) {
        String sql = "INSERT INTO RoomAvailability (RoomId, Date, Hour, AvailableSeats, Capacity, RoomStatus) " +
                "VALUES (?, ?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql,
                availability.getRoomId(),
                availability.getDate(),
                availability.getHour(),
                availability.getAvailableSeats(),
                availability.getCapacity(),
                availability.getRoomStatus().name());
    }

    @Override
    public void delete(String roomId, LocalDate date, int hour) {
        String sql = "DELETE FROM RoomAvailability WHERE RoomId = ? AND Date = ? AND Hour = ?";
        jdbcTemplate.update(sql, roomId, date, hour);
    }

    @Override
    public void update(RoomAvailability availability) {
        String sql = "UPDATE RoomAvailability SET AvailableSeats = ?, Capacity = ?, RoomStatus = ? " +
                "WHERE RoomId = ? AND Date = ? AND Hour = ?";
        jdbcTemplate.update(sql,
                availability.getAvailableSeats(),
                availability.getCapacity(),
                availability.getRoomStatus().name(),
                availability.getRoomId(),
                availability.getDate(),
                availability.getHour());
    }

    @Override
    public RoomAvailability getByKey(String roomId, LocalDate date, int hour) {
        String sql = "SELECT * FROM RoomAvailability WHERE RoomId = ? AND Date = ? AND Hour = ?";
        try {
            return jdbcTemplate.queryForObject(sql, new RoomAvailabilityRowMapper(), roomId, date, hour);
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    @Override
    public List<RoomAvailability> findByRoomId(String roomId) {
        String sql = "SELECT * FROM RoomAvailability WHERE RoomId = ?";
        return jdbcTemplate.query(sql, new RoomAvailabilityRowMapper(), roomId);
    }

    @Override
    public List<RoomAvailability> findByDateRange(String roomId, LocalDate startDate, LocalDate endDate) {
        String sql = "SELECT * FROM RoomAvailability " +
                "WHERE RoomId = ? AND Date BETWEEN ? AND ? " +
                "ORDER BY Date, Hour";
        return jdbcTemplate.query(sql, new RoomAvailabilityRowMapper(), roomId, startDate, endDate);
    }

    public List<RoomAvailability> findByDate(String roomId, LocalDate date) {
        String sql = "SELECT * FROM RoomAvailability " +
                "WHERE RoomId = ? AND Date = ? " +
                "ORDER BY Date, Hour";
        return jdbcTemplate.query(sql, new RoomAvailabilityRowMapper(), roomId, date);
    }

    private static class RoomAvailabilityRowMapper implements RowMapper<RoomAvailability> {
        @Override
        public RoomAvailability mapRow(ResultSet rs, int rowNum) throws SQLException {
            RoomAvailability availability = new RoomAvailability();
            availability.setRoomId(rs.getString("RoomId"));
            availability.setDate(rs.getDate("Date").toLocalDate());
            availability.setHour(rs.getInt("Hour"));
            availability.setAvailableSeats(rs.getInt("AvailableSeats"));
            availability.setRoomStatus(RoomStatus.valueOf(rs.getString("RoomStatus")));
            availability.setCapacity(rs.getInt("Capacity"));
            return availability;
        }
    }
}