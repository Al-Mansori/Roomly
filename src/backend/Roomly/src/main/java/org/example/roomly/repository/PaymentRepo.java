package org.example.roomly.repository;

import org.example.roomly.model.Payment;
import org.example.roomly.model.PaymentStatus;
import org.springframework.jdbc.core.JdbcTemplate;

import java.util.Date;
import java.util.List;

public class PaymentRepo {
    private final JdbcTemplate jdbcTemplate;

    public PaymentRepo(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // Save a new payment
    public int save(String id, java.util.Date paymentDate, String paymentMethod, double amount, PaymentStatus status, String reservationId) {
        String sql = "INSERT INTO payment (Id, PaymentDate, PaymentMethod, Amount, Status, reservationId) VALUES (?, ?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql, id, paymentDate, paymentMethod, amount, status.toString(), reservationId);
    }

    // Find a payment by ID
    public Payment find(String id) {
        String sql = "SELECT * FROM payment WHERE Id = ?";
        return jdbcTemplate.queryForObject(sql,(rs, rowNum) -> new Payment(
                rs.getString("Id"),
                rs.getString("PaymentMethod"),
                rs.getDate("PaymentDate"),
                rs.getDouble("Amount"),
                PaymentStatus.valueOf(rs.getString("Status")) // Convert String to Enum
        ), id);
    }

    // Find all payments
    public List<Payment> findAll() {
        String sql = "SELECT * FROM payment";
        return jdbcTemplate.query(sql,(rs, rowNum) -> new Payment(
                rs.getString("Id"),
                rs.getString("PaymentMethod"),
                rs.getDate("PaymentDate"),
                rs.getDouble("Amount"),
                PaymentStatus.valueOf(rs.getString("Status")) // Convert String to Enum
        ));
    }

    public int update(String id, Date paymentDate, String paymentMethod, double amount, String status) {
        String sql = "UPDATE payment SET PaymentDate = ?, PaymentMethod = ?, Amount = ?, Status = ? WHERE Id = ?";
        return jdbcTemplate.update(sql, paymentDate, paymentMethod, amount, status, id);
    }

    // Delete a payment by ID
    public int delete(String id) {
        String sql = "DELETE FROM payment WHERE Id = ?";
        return jdbcTemplate.update(sql, id);
    }
}
