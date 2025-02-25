package org.example.roomly.repository.impl;

import org.example.roomly.model.Customer;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class CustomerRepository implements org.example.roomly.repository.CustomerRepository {
    private final JdbcTemplate jdbcTemplate;

    public CustomerRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public void save(Customer customer) {
        String sql = "INSERT INTO User (Id, FName, LName, Email, Password, Phone, Address) VALUES (?, ?, ?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql, customer.getId(), customer.getFirstName(), customer.getLastName(),
                customer.getEmail(), customer.getPassword(), customer.getPhone(), customer.getAddress());
    }

    @Override
    public Customer findById(String id) {
        String sql = "SELECT * FROM User WHERE Id = ?";
        return jdbcTemplate.queryForObject(sql, new CustomerRowMapper(), id);
    }

    @Override
    public Customer findByEmail(String email) {
        String sql = "SELECT * FROM User WHERE email = ?";
        return jdbcTemplate.queryForObject(sql, new CustomerRowMapper(), email);
    }

    @Override
    public List<Customer> findAll() {
        String sql = "SELECT * FROM User";
        return jdbcTemplate.query(sql, new CustomerRowMapper());
    }

    @Override
    public void update(Customer customer) {
        String sql = "UPDATE User SET FName = ?, LName = ?, Email = ?, Password = ?, Phone = ?, Address = ? WHERE Id = ?";
        jdbcTemplate.update(sql, customer.getFirstName(), customer.getLastName(), customer.getEmail(),
                customer.getPassword(), customer.getPhone(), customer.getAddress(), customer.getId());
    }

    @Override
    public void deleteById(String id) {
        String sql = "DELETE FROM User WHERE Id = ?";
        jdbcTemplate.update(sql, id);
    }

    @Override
    public boolean existsByEmail(String email) {
        String sql = "SELECT COUNT(*) FROM User WHERE Email = ?";
        return jdbcTemplate.queryForObject(sql, new Object[]{email}, Integer.class) > 0;
    }

    private static class CustomerRowMapper implements RowMapper<Customer> {
        @Override
        public Customer mapRow(ResultSet rs, int rowNum) throws SQLException {
            Customer customer = new Customer();
            customer.setId(rs.getString("Id"));
            customer.setFirstName(rs.getString("FName"));
            customer.setLastName(rs.getString("LName"));
            customer.setEmail(rs.getString("Email"));
            customer.setPhone(rs.getString("Phone"));
            customer.setPassword(rs.getString("Password"));
            customer.setAddress(rs.getString("Address"));
            return customer;
        }
    }
}
