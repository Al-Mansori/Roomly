package org.example.roomly.repository.impl;

import org.example.roomly.model.Reservation;
import org.example.roomly.model.ReservationStatus;
import org.example.roomly.model.ReservationType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class ReservationRepository implements org.example.roomly.repository.ReservationRepository {

    private final JdbcTemplate jdbcTemplate;

    @Autowired
    public ReservationRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public int save(Reservation reservation) {
        String sql = "INSERT INTO Reservation (Id, BookingDate, StartTime, EndTime, Status, TotalCost, AmenitiesCount, AccessCode, ReservationType) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        return jdbcTemplate.update(sql,
                reservation.getId(),
                reservation.getReservationDate(),
                reservation.getStartTime(),
                reservation.getEndTime(),
                reservation.getStatus().toString(),
                reservation.getTotalCost(),
                reservation.getAmenitiesCount(),
                reservation.getAccessCode(),
                reservation.getReservationType().name()
        );
    }


    //    @Override
//    public Reservation find(String id) {
//        String sql = "SELECT * FROM reservation WHERE Id = ?";
//        return jdbcTemplate.queryForObject(sql, new ReservationRowMapper(), id);
//    }
    @Override
    public Reservation find(String id) {
        String sql = "SELECT * FROM reservation WHERE Id = ?";
        try {
            return jdbcTemplate.queryForObject(sql, new ReservationRowMapper(), id);
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    @Override
    public List<Reservation> findAll() {
        String sql = "SELECT * FROM reservation";
        return jdbcTemplate.query(sql, new ReservationRowMapper());
    }
    @Override
    public int update(Reservation reservation) {
        String sql = "UPDATE Reservation SET BookingDate = ?, StartTime = ?, EndTime = ?, Status = ?, TotalCost = ?, AmenitiesCount = ?, AccessCode = ?, ReservationType = ? WHERE Id = ?";

        return jdbcTemplate.update(sql,
                reservation.getReservationDate(),
                reservation.getStartTime(),
                reservation.getEndTime(),
                reservation.getStatus().toString(),
                reservation.getTotalCost(),
                reservation.getAmenitiesCount(),
                reservation.getAccessCode(),
                reservation.getReservationType().name(),
                reservation.getId()
        );
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
    public Map<String, Object> getBooking(String userId, String reservationId) {
        String sql = "SELECT * FROM Booking WHERE UserId = ? AND ReservationId = ?";
        try {
            // queryForMap returns a Map<String,Object> for the row
            return jdbcTemplate.queryForMap(sql, userId, reservationId);
        } catch (EmptyResultDataAccessException ex) {
            // no matching row
            return null;
        }
    }

    // Method helping the scheduling service to find all expired reservations
    public Map<String, Object> getReservedBooking(String reservationId) {
        String sql = "SELECT * FROM Booking WHERE ReservationId = ?";
        try {
            // queryForMap returns a Map<String,Object> for the row
            return jdbcTemplate.queryForMap(sql, reservationId);
        } catch (EmptyResultDataAccessException ex) {
            // no matching row
            return null;
        }
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

    @Override
    public List<Reservation> findReservationsByUserId(String userId) {
        String sql = "SELECT r.* FROM Reservation r " +
                "JOIN Booking b ON r.Id = b.ReservationId " +
                "WHERE b.UserId = ?";
        return jdbcTemplate.query(sql, new ReservationRowMapper(), userId);
    }

    @Override
    public List<Reservation> findCancelledReservationsByUserId(String userId) {
        String sql = "SELECT r.* FROM Reservation r " +
                "JOIN Booking b ON r.Id = b.ReservationId " +
                "JOIN Cancellation c ON r.Id = c.ReservationId " +
                "WHERE b.UserId = ?";
        return jdbcTemplate.query(sql, new ReservationRowMapper(), userId);
    }

    @Override
    public List<Reservation> findReservationsByWorkspaceId(String workspaceId) {
        String sql = "SELECT r.* FROM Reservation r " +
                "JOIN Booking b ON r.Id = b.ReservationId " +
                "WHERE b.WorkspaceId = ?";
        return jdbcTemplate.query(sql, new ReservationRowMapper(), workspaceId);
    }

    @Override
    public List<Reservation> findCancelledReservationsByWorkspaceId(String workspaceId) {
        String sql = "SELECT r.* FROM Reservation r " +
                "JOIN Booking b ON r.Id = b.ReservationId " +
                "JOIN Cancellation c ON r.Id = c.ReservationId " +
                "WHERE b.WorkspaceId = ?";
        return jdbcTemplate.query(sql, new ReservationRowMapper(), workspaceId);
    }

    @Override
    public List<Map<String, Object>> findReservationsWithBookingByUserId(String userId) {
        String sql = "SELECT r.*, b.WorkspaceId, b.RoomId " +
                "FROM Reservation r " +
                "JOIN Booking b ON r.Id = b.ReservationId " +
                "WHERE b.UserId = ?";

        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            Map<String, Object> result = new HashMap<>();

            // Add reservation data
            Reservation reservation = new ReservationRowMapper().mapRow(rs, rowNum);
            result.put("reservation", reservation);

            // Add booking data
            result.put("workspaceId", rs.getString("WorkspaceId"));
            result.put("roomId", rs.getString("RoomId"));

            return result;
        }, userId);
    }

    private static class ReservationRowMapper implements RowMapper<Reservation> {
        @Override
        public Reservation mapRow(ResultSet rs, int rowNum) throws SQLException {
            Reservation reservation = new Reservation();
            reservation.setId(rs.getString("Id"));
            reservation.setReservationDate(rs.getTimestamp("BookingDate"));
            reservation.setStartTime(rs.getTimestamp("StartTime"));
            reservation.setEndTime(rs.getTimestamp("EndTime"));

            // Handle case differences in status
            String statusStr = rs.getString("Status").toUpperCase();
            try {
                reservation.setStatus(ReservationStatus.valueOf(statusStr));
            } catch (IllegalArgumentException e) {
                // Handle unknown status values - you might want to log this
                reservation.setStatus(ReservationStatus.PENDING); // or some default
            }

            reservation.setTotalCost(rs.getDouble("TotalCost"));
            reservation.setAmenitiesCount(rs.getInt("AmenitiesCount"));
            reservation.setAccessCode(rs.getString("AccessCode"));
            reservation.setReservationType(ReservationType.valueOf(rs.getString("ReservationType").toUpperCase()));
            return reservation;
        }
    }

    // Method for the scheduling service to find all expired reservations
    @Override
    public List<Reservation> findExpiredReservations(Timestamp currentTime) {
        String sql = "SELECT * FROM Reservation WHERE Status NOT IN ('COMPLETED', 'CANCELLED') AND EndTime < ?";
        return jdbcTemplate.query(sql, new ReservationRowMapper(), currentTime);
    }

    @Override
    public List<Reservation> findReservationsByRoomId(String roomId) {
        String sql = "SELECT r.* FROM Reservation r " +
                "JOIN Booking b ON r.Id = b.ReservationId " +
                "WHERE b.RoomId = ?";
        return jdbcTemplate.query(sql, new ReservationRowMapper(), roomId);
    }

    @Override
    public List<String> findUserIdsByWorkspaceIds(List<String> workspaceIds) {
        if (workspaceIds.isEmpty()) {
            return Collections.emptyList();
        }
        String sql = "SELECT DISTINCT b.UserId FROM Booking b WHERE b.WorkspaceId IN (" +
                String.join(",", Collections.nCopies(workspaceIds.size(), "?")) + ")";
        return jdbcTemplate.queryForList(sql, String.class, workspaceIds.toArray());
    }
}
