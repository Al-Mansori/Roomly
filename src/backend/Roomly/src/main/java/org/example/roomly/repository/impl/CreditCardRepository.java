package org.example.roomly.repository.impl;
import org.example.roomly.model.UserCard;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class CreditCardRepository {

    private final JdbcTemplate jdbcTemplate;

    @Autowired
    public CreditCardRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public void insert(UserCard card) {
        String sql = "INSERT INTO UserCards (CardNumber, UserId) VALUES (?, ?)";
        jdbcTemplate.update(sql, card.getCardNumber(), card.getUserId());
    }

    public UserCard findById(String cardNumber) {
        String sql = "SELECT * FROM UserCards WHERE CardNumber = ?";
        try{
        return jdbcTemplate.queryForObject(sql, new Object[]{cardNumber}, new UserCardRowMapper());
        }
        catch (EmptyResultDataAccessException e){
            return null;
        }
    }

    public List<UserCard> findByUserId(String userId) {
        String sql = "SELECT * FROM UserCards WHERE UserId = ?";
        return jdbcTemplate.query(sql, new Object[]{userId}, new UserCardRowMapper());
    }

    public void update(UserCard card) {
        String sql = "UPDATE UserCards SET UserId = ? WHERE CardNumber = ?";
        jdbcTemplate.update(sql, card.getUserId(), card.getCardNumber());
    }

    public void delete(String cardNumber) {
        String sql = "DELETE FROM UserCards WHERE CardNumber = ?";
        jdbcTemplate.update(sql, cardNumber);
    }

//    public boolean isCreditReliable(String cardNumber , String cvv, String endDate){
//        String sql = "SELECT COUNT(*) FROM CreditCard WHERE CardNumber = ? and CVV= ? and EndDate= ?";
//        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, cardNumber, cvv, endDate);
//        return count != null && count > 0;
//    }
    public boolean isCreditReliable(String cardNumber, String cvv, String endDate) {
        String sql;
        if (endDate == null) {
            sql = "SELECT COUNT(*) FROM CreditCard WHERE CardNumber = ? and CVV = ?";
            Integer count = jdbcTemplate.queryForObject(sql, Integer.class, cardNumber, cvv);
            return count != null && count > 0;
        } else {
            sql = "SELECT COUNT(*) FROM CreditCard WHERE CardNumber = ? and CVV= ? and EndDate= ?";
            Integer count = jdbcTemplate.queryForObject(sql, Integer.class, cardNumber, cvv, endDate);
            return count != null && count > 0;
        }
    }

    public boolean updateBalance(String cardNumber, double amount){
        String sql = "SELECT Balance FROM CreditCard WHERE CardNumber = ?";
        double Balance = jdbcTemplate.queryForObject(sql, Double.class, cardNumber);
        if(amount > Balance){
            return false;
        }

        sql = "UPDATE CreditCard SET Balance = ? WHERE CardNumber = ?";
        double newBalance = Balance - amount;
        jdbcTemplate.update(sql, newBalance, cardNumber);
        return true;
    }

    public boolean checkBalance(String cardNumber, double amount){
        String sql = "SELECT Balance FROM CreditCard WHERE CardNumber = ?";
        double balance = jdbcTemplate.queryForObject(sql, Double.class, cardNumber);
        return balance >= amount;
    }

    // RowMapper Inner Class
    private static class UserCardRowMapper implements RowMapper<UserCard> {
        @Override
        public UserCard mapRow(ResultSet rs, int rowNum) throws SQLException {
            return new UserCard(rs.getString("userId"), rs.getString("cardNumber"));
        }
    }

}

