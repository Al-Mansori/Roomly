package org.example.roomly.repository;

import org.example.roomly.model.Customer;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class CustomerRepository {
    private final JdbcTemplate jdbcTemplate;

    public CustomerRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public void save(Customer customer) {
        String sql = "INSERT INTO User (Id, FName, LName, Email, Password, Phone, Address) VALUES (?, ?, ?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql, customer.getUserId(), customer.getFirstName(), customer.getLastName(),
                customer.getEmail(), customer.getPassword(), customer.getPhone(), customer.getAddress());
    }

    public Customer findById(String id) {
        String sql = "SELECT * FROM User WHERE Id = ?";
        return jdbcTemplate.queryForObject(sql, new Object[]{id},
                (rs, rowNum) -> new Customer(
                        rs.getString("Id"),
                        rs.getString("FName"),
                        rs.getString("LName"),
                        rs.getString("Email"),
                        rs.getString("Password"),
                        rs.getString("Phone"),
                        rs.getString("Address")
                )
        );
    }

    public List<Customer> findAll() {
        String sql = "SELECT * FROM User";
        return jdbcTemplate.query(sql,
                (rs, rowNum) -> new Customer(
                        rs.getString("Id"),
                        rs.getString("FName"),
                        rs.getString("LName"),
                        rs.getString("Email"),
                        rs.getString("Password"),
                        rs.getString("Phone"),
                        rs.getString("Address")
                )
        );
    }

    public void update(Customer customer) {
        String sql = "UPDATE User SET FName = ?, LName = ?, Email = ?, Password = ?, Phone = ?, Address = ? WHERE Id = ?";
        jdbcTemplate.update(sql, customer.getFirstName(), customer.getLastName(), customer.getEmail(),
                customer.getPassword(), customer.getPhone(), customer.getAddress(), customer.getUserId());
    }

    public void deleteById(String id) {
        String sql = "DELETE FROM User WHERE Id = ?";
        jdbcTemplate.update(sql, id);
    }
}
