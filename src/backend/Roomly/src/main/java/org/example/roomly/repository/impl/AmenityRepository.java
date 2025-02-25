package org.example.roomly.repository.impl;

import org.example.roomly.model.Amenity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class AmenityRepository implements org.example.roomly.repository.AmenityRepository {

    private JdbcTemplate jdbcTemplate;

    public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // Save Amenity
    @Override
    public void save(Amenity amenity, String roomId) {
        String sql = "INSERT INTO Amenity (Id, Name, Type, Description, TotalCount, RoomId) VALUES (?, ?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql, amenity.getId(), amenity.getName(), amenity.getType(), amenity.getDescription(), amenity.getTotalCount(), roomId);
    }

    // Delete Amenity by ID
    @Override
    public void delete(String id) {
        String sql = "DELETE FROM Amenity WHERE Id = ?";
        jdbcTemplate.update(sql, id);
    }

    // Update Amenity
    @Override
    public void update(Amenity amenity) {
        String sql = "UPDATE Amenity SET Name = ?, Type = ?, Description = ?, TotalCount = ? WHERE Id = ?";
        jdbcTemplate.update(sql, amenity.getName(), amenity.getType(), amenity.getDescription(), amenity.getTotalCount(), amenity.getId());
    }

//    public void update(Amenity amenity) {
//        StringBuilder sql = new StringBuilder("UPDATE Amenity SET ");
//        List<Object> params = new ArrayList<>();
//
//        if (amenity.getName() != null) {
//            sql.append("Name = ?, ");
//            params.add(amenity.getName());
//        }
//        if (amenity.getType() != null) {
//            sql.append("Type = ?, ");
//            params.add(amenity.getType());
//        }
//        if (amenity.getDescription() != null) {
//            sql.append("Description = ?, ");
//            params.add(amenity.getDescription());
//        }
//        if (amenity.getTotalCount() != 0) { // Assuming 0 is not a valid value
//            sql.append("TotalCount = ?, ");
//            params.add(amenity.getTotalCount());
//        }
//        if (amenity.getAvailableCount() != 0) { // Assuming 0 is not a valid value
//            sql.append("AvailableCount = ?, ");
//            params.add(amenity.getAvailableCount());
//        }
//
//        // Remove the trailing comma and space
//        sql.delete(sql.length() - 2, sql.length());
//
//        // Add the WHERE clause
//        sql.append(" WHERE Id = ?");
//        params.add(amenity.getId());
//
//        // Execute the update
//        jdbcTemplate.update(sql.toString(), params.toArray());
//    }

    // Get Amenity by ID
    @Override
    public Amenity getById(String id) {
        String sql = "SELECT * FROM Amenity WHERE Id = ?";
        return jdbcTemplate.queryForObject(sql,new AmenityRowMapper(),id);
    }

    // Find All Amenities
    @Override
    public List<Amenity> findAll() {
        String sql = "SELECT * FROM Amenity";
        return jdbcTemplate.query(sql, new AmenityRowMapper());
    }

    @Override
    public List<Amenity> getRoomAmenities(String roomId){
        String sql = "SELECT * FROM Amenity WHERE RoomId = ?";
        return jdbcTemplate.query(sql, new AmenityRowMapper(), roomId);
    }

    // RowMapper for Amenities
    private static class AmenityRowMapper implements RowMapper<Amenity> {
        @Override
        public Amenity mapRow(ResultSet rs, int rowNum) throws SQLException {
            Amenity amenity = new Amenity();
            amenity.setId(rs.getString("Id"));
            amenity.setName(rs.getString("Name"));
            amenity.setType(rs.getString("Type"));
            amenity.setDescription(rs.getString("Description"));
            amenity.setTotalCount(rs.getInt("TotalCount"));
            return amenity;
        }
    }
}