package org.example.roomly.repository.impl;

import org.example.roomly.model.Payment;
import org.example.roomly.model.PaymentStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.util.List;

@Repository
public class PaymentRepository implements org.example.roomly.repository.PaymentRepository {

    private final JdbcTemplate jdbcTemplate;

    @Autowired
    public PaymentRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // Save a new payment
    @Override
    public int save(Payment payment, String reservationId) {
        String sql = "INSERT INTO payment (Id, PaymentDate, PaymentMethod, Amount, Status, reservationId) VALUES (?, ?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql, payment.getId(), payment.getPaymentDate(), payment.getPaymentMethod(), payment.getAmount(), payment.getStatus().toString(), reservationId);
    }

    // Find a payment by ID
    @Override
    public Payment find(String id) {
        String sql = "SELECT * FROM payment WHERE Id = ?";
        return jdbcTemplate.queryForObject(sql, new PaymentRowMapper(), id);
    }

    // Find all payments
    @Override
    public List<Payment> findAll() {
        String sql = "SELECT * FROM payment";
        return jdbcTemplate.query(sql, new PaymentRowMapper());
    }

    @Override
    public int update(Payment payment) {
        String sql = "UPDATE payment SET PaymentDate = ?, PaymentMethod = ?, Amount = ?, Status = ? WHERE Id = ?";
        return jdbcTemplate.update(sql, payment.getPaymentDate(), payment.getPaymentMethod(), payment.getAmount(), payment.getStatus().toString(), payment.getId());
    }

    // Delete a payment by ID
    @Override
    public int delete(String id) {
        String sql = "DELETE FROM payment WHERE Id = ?";
        return jdbcTemplate.update(sql, id);
    }

    private static class PaymentRowMapper implements RowMapper<Payment> {
        @Override
        public Payment mapRow(ResultSet rs, int rowNum) throws SQLException {
            Payment payment = new Payment();
            payment.setId(rs.getString("Id"));
            payment.setPaymentMethod(rs.getString("PaymentMethod"));
            payment.setPaymentDate(rs.getDate("PaymentDate"));
            payment.setAmount(rs.getDouble("Amount"));
            payment.setStatus(PaymentStatus.valueOf(rs.getString("Status"))); // Convert String to Enum
            return payment;
        }
    }
}
