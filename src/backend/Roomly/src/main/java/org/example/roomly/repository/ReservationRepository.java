package org.example.roomly.repository;
import org.example.roomly.model.Reservation;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;
@Repository
public class ReservationRepository {
    private final JdbcTemplate jdbcTemplate;

    public ReservationRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public int save(String id, String bookingDate, Date startTime, Date endTime, String status, Double totalCost) {
        String sql = "INSERT INTO reservation (Id, BookingDate, StartTime, EndTime, Status, TotalCost) VALUES (?, ?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql, id, bookingDate, startTime, endTime, status, totalCost);
    }

    public Reservation find(String id) {
        String sql = "SELECT * FROM reservation WHERE Id = ?";
        return jdbcTemplate.queryForObject(sql,Reservation.class,id);
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
    public int delete(String id) {
        String sql = "DELETE FROM reservation WHERE Id = ?";
        return jdbcTemplate.update(sql, id);
    }
}
