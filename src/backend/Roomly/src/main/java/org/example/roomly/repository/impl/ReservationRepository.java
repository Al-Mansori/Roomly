package org.example.roomly.repository.impl;

import org.example.roomly.model.Reservation;
import org.example.roomly.model.ReservationStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;

@Repository
public class ReservationRepository implements org.example.roomly.repository.ReservationRepository {

    private final JdbcTemplate jdbcTemplate;

    @Autowired
    public ReservationRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public int save(Reservation reservation) {
        String sql = "INSERT INTO reservation (Id, BookingDate, StartTime, EndTime, Status, TotalCost, AmenitiesCount) VALUES (?, ?, ?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql, reservation.getId(), reservation.getReservationDate(), reservation.getStartTime(), reservation.getEndTime(), reservation.getStatus().toString(), reservation.getTotalCost(), reservation.getAmenitiesCount());
    }

    @Override
    public Reservation find(String id) {
        String sql = "SELECT * FROM reservation WHERE Id = ?";
        return jdbcTemplate.queryForObject(sql, new ReservationRowMapper(), id);
    }

    @Override
    public List<Reservation> findAll() {
        String sql = "SELECT * FROM reservation";
        return jdbcTemplate.query(sql, new ReservationRowMapper());
    }
    @Override
    public int update(Reservation reservation) {
        String sql = "UPDATE reservation SET BookingDate = ?, StartTime = ?, EndTime = ?, Status = ?, TotalCost = ?, AmenitiesCount = ? WHERE Id = ?";
        return jdbcTemplate.update(sql, reservation.getReservationDate(), reservation.getStartTime(), reservation.getEndTime(), reservation.getStatus(), reservation.getTotalCost(), reservation.getAmenitiesCount(), reservation.getId());
    }

    @Override
    public int delete(String id) {
        String sql = "DELETE FROM reservation WHERE Id = ?";
        return jdbcTemplate.update(sql, id);
    }

    @Override
    public void saveBooking(String userId, String reservationId, String workspaceId, String roomId) {
        String sql = "INSERT INTO Booking (UserId, ReservationId, WorkspaceId, RoomId) VALUES (?, ?, ?, ?)";
        jdbcTemplate.update(sql, userId, reservationId, workspaceId, roomId);
    }

    // Delete a booking by UserId and ReservationId
    @Override
    public void deleteBooking(String userId, String reservationId) {
        String sql = "DELETE FROM Booking WHERE UserId = ? AND ReservationId = ?";
        jdbcTemplate.update(sql, userId, reservationId);
    }

    @Override
    public int CancelReservation(double fees, Timestamp cancellationDate, String userId, String reservationId) {
        String sql = "INSERT INTO Cancellation (Fees, CancellationDate, UserId, ReservationId) VALUES (?, ?, ?, ?)";
        return jdbcTemplate.update(sql, fees, cancellationDate, userId, reservationId);
    }

    @Override
    public int deleteCancellation(String reservationId) {
        String sql = "DELETE FROM Cancellation WHERE ReservationId = ?";
        return jdbcTemplate.update(sql, reservationId);
    }

    private static class ReservationRowMapper implements RowMapper<Reservation> {
        @Override
        public Reservation mapRow(ResultSet rs, int rowNum) throws SQLException {
            Reservation reservation = new Reservation();
            reservation.setId(rs.getString("Id"));
            reservation.setReservationDate(rs.getTimestamp("BookingDate"));
            reservation.setStartTime(rs.getTimestamp("StartTime"));
            reservation.setEndTime(rs.getTimestamp("EndTime"));
            reservation.setStatus(ReservationStatus.valueOf(rs.getString("Status")));
            reservation.setTotalCost(rs.getDouble("TotalCost"));
            reservation.setAmenitiesCount(rs.getInt("AmenitiesCount"));
            return reservation;
        }
    }
}
