package org.example.roomly.repository.impl;

import org.example.roomly.model.Room;
import org.example.roomly.model.RoomStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class RoomRepository implements org.example.roomly.repository.RoomRepository {

    private JdbcTemplate jdbcTemplate;

    @Autowired
    public RoomRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // Save Room
    @Override
    public void save(Room room, String workspaceId) {
        String sql = "INSERT INTO Room (Id, Name, Type, Description, Capacity, PricePerHour, RoomStatus, AvailableCount, WorkspaceId) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql, room.getId(), room.getName(), room.getType(), room.getDescription(), room.getCapacity(), room.getPricePerHour(), room.getStatus().toString(), room.getAvailableCount(), workspaceId);
    }

    // Delete Room by ID
    @Override
    public void delete(String id) {
        String sql = "DELETE FROM Room WHERE Id = ?";
        jdbcTemplate.update(sql, id);
    }

    // Update Room
    @Override
    public void update(Room room) {
        String sql = "UPDATE Room SET Name = ?, Type = ?, Description = ?, Capacity = ?, PricePerHour = ?, RoomStatus = ?, AvailableCount = ? WHERE Id = ?";
        jdbcTemplate.update(sql, room.getName(), room.getType(), room.getDescription(), room.getCapacity(), room.getPricePerHour(), room.getStatus().toString(), room.getAvailableCount(), room.getId());
    }

//    public void update(Room room) {
//        StringBuilder sql = new StringBuilder("UPDATE Room SET ");
//        List<Object> params = new ArrayList<>();
//
//        if (room.getName() != null) {
//            sql.append("Name = ?, ");
//            params.add(room.getName());
//        }
//
//        if (room.getType() != null) {
//            sql.append("Type = ?, ");
//            params.add(room.getType());
//        }
//        if (room.getDescription() != null) {
//            sql.append("Description = ?, ");
//            params.add(room.getDescription());
//        }
//        if (room.getCapacity() != 0) { // Assuming 0 is not a valid value
//            sql.append("Capacity = ?, ");
//            params.add(room.getCapacity());
//        }
//        if (room.getPricePerHour() != 0.0) { // Assuming 0.0 is not a valid value
//            sql.append("PricePerHour = ?, ");
//            params.add(room.getPricePerHour());
//        }
//        if (room.getStatus() != null) {
//            sql.append("RoomStatus = ?, ");
//            params.add(room.getStatus());
//        }
//
//        // Remove the trailing comma and space
//        sql.delete(sql.length() - 2, sql.length());
//
//        // Add the WHERE clause
//        sql.append(" WHERE Id = ?");
//        params.add(room.getId());
//
//        // Execute the update
//        jdbcTemplate.update(sql.toString(), params.toArray());
//    }

    // Get Room by ID
    @Override
    public Room getById(String id) {
        String sql = "SELECT * FROM Room WHERE Id = ?";
        return jdbcTemplate.queryForObject(sql, new RoomRowMapper(), id);
    }

    // Find All Rooms
    @Override
    public List<Room> findAll() {
        String sql = "SELECT * FROM Room";
        return jdbcTemplate.query(sql, new RoomRowMapper());
    }

    @Override
    public List<Room> getWorkspaceRooms(String workspaceId){
        String sql = "SELECT * FROM Room WHERE WorkspaceId = ?";
        return jdbcTemplate.query(sql, new RoomRowMapper(), workspaceId);
    }

    // RowMapper for Room
    private static class RoomRowMapper implements RowMapper<Room> {
        @Override
        public Room mapRow(ResultSet rs, int rowNum) throws SQLException {
            Room room = new Room();
            room.setId(rs.getString("Id"));
            room.setName(rs.getString("Name"));
            room.setType(rs.getString("Type"));
            room.setDescription(rs.getString("Description"));
            room.setCapacity(rs.getInt("Capacity"));
            room.setPricePerHour(rs.getDouble("PricePerHour"));
            room.setStatus(RoomStatus.valueOf(rs.getString("RoomStatus")));
            room.setAvailableCount(rs.getInt("AvailableCount"));
            return room;
        }
    }
}