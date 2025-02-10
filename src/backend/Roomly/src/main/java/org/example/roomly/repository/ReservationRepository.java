package org.example.roomly.repository;

import org.example.roomly.model.Reservation;
import org.springframework.jdbc.core.JdbcTemplate;

import java.util.Date;
import java.util.List;

public class ReservationRepository {
    private final JdbcTemplate jdbcTemplate;

    public ReservationRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public int save(String id, Date bookingDate, Date startTime, Date endTime, String status, Double totalCost) {
        String sql = "INSERT INTO reservation (Id, BookingDate, StartTime, EndTime, Status, TotalCost) VALUES (?, ?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql, id, bookingDate, startTime, endTime, status, totalCost);
    }

    public Reservation find(String id) {
        String sql = "SELECT * FROM reservation WHERE Id = ?";
        return jdbcTemplate.queryForObject(sql,(rs, rowNum) ->
                new Reservation(
                        rs.getString("Id"),
                        rs.getDate("BookingDate"),
                        rs.getTime("StartTime"),
                        rs.getTime("EndTime"),
                        rs.getString("Status"),
                        rs.getDouble("TotalCost")
                ),id);
    }

    public List<Reservation> findAll() {
        String sql = "SELECT * FROM reservation";
        return jdbcTemplate.query(sql,(rs, rowNum) -> new Reservation(
                rs.getString("Id"),
                rs.getTimestamp("BookingDate"),
                rs.getTimestamp("StartTime"),
                rs.getTimestamp("EndTime"),
                rs.getString("Status"),
                rs.getDouble("TotalCost")
        ));
    }
    public int update(String id, Date bookingDate, Date startTime, Date endTime, String status, Double totalCost) {
        String sql = "UPDATE reservation SET BookingDate = ?, StartTime = ?, EndTime = ?, Status = ?, TotalCost = ? WHERE Id = ?";
        return jdbcTemplate.update(sql, bookingDate, startTime, endTime, status, totalCost, id);
    }

    public int delete(String id) {
        String sql = "DELETE FROM reservation WHERE Id = ?";
        return jdbcTemplate.update(sql, id);
    }
}
