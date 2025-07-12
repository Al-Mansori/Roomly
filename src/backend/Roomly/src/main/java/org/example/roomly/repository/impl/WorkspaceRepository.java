package org.example.roomly.repository.impl;

import org.example.roomly.model.Location;
import org.example.roomly.model.PaymentType;
import org.example.roomly.model.Workspace;
import org.example.roomly.service.RoomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class WorkspaceRepository implements org.example.roomly.repository.WorkspaceRepository {

    private JdbcTemplate jdbcTemplate;

    @Autowired
    private RoomService roomService;
    @Autowired
    public WorkspaceRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }


    // Save Workspace
    @Override
    public void save(Workspace workspace, String locationId) {
        String sql = "INSERT INTO Workspace (Id, Name, Description, Address, LocationId, CreatedDate, AvgRating, Type, PaymentType) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql,
                workspace.getId(),
                workspace.getName(),
                workspace.getDescription(),
                workspace.getAddress(),
                locationId,
                workspace.getCreationDate(),
                workspace.getAvgRating(),
                workspace.getType(),
                workspace.getPaymentType().toString());
    }

    // Delete Workspace by ID
    @Override
    public void delete(String id) {
        // Delete images first
        jdbcTemplate.update("DELETE FROM Images WHERE WorkspaceId = ?", id);

        // Delete rooms and their dependencies
        List<String> roomIds = jdbcTemplate.queryForList(
                "SELECT Id FROM Room WHERE WorkspaceId = ?",
                String.class,
                id
        );
        roomIds.forEach(roomService::deleteRoom);

        // Delete other workspace dependencies
        jdbcTemplate.update("DELETE FROM WorkspaceSchedule WHERE WorkspaceId = ?", id);
        jdbcTemplate.update("DELETE FROM WorkspaceSupervise WHERE WorkspaceId = ?", id);
        jdbcTemplate.update("DELETE FROM FavouriteWorkspaceRooms WHERE WorkspaceId = ?", id);
        jdbcTemplate.update("DELETE FROM Review WHERE WorkspaceId = ?", id);
        jdbcTemplate.update("DELETE FROM WorkspacePlan WHERE WorkspaceId = ?", id);
        jdbcTemplate.update("DELETE FROM Booking WHERE WorkspaceId = ?", id);
        jdbcTemplate.update("DELETE FROM WorkspaceAnalytics WHERE WorkspaceId = ?", id);

        // Finally delete workspace
        jdbcTemplate.update("DELETE FROM Workspace WHERE Id = ?", id);
    }

    // Update Workspace
    @Override
    public void update(Workspace workspace) {
        String sql = "UPDATE Workspace SET Name = ?, Description = ?, Address = ?, " +
                "CreatedDate = ?, AvgRating = ?, Type = ?, PaymentType = ? WHERE Id = ?";
        jdbcTemplate.update(sql,
                workspace.getName(),
                workspace.getDescription(),
                workspace.getAddress(),
                workspace.getCreationDate(),
                workspace.getAvgRating(),
                workspace.getType(),
                workspace.getPaymentType().toString(),
                workspace.getId());
    }

//    public void update(Workspace workspace) {
//        StringBuilder sql = new StringBuilder("UPDATE Workspace SET ");
//        List<Object> params = new ArrayList<>();
//
//        if (workspace.getName() != null) {
//            sql.append("Name = ?, ");
//            params.add(workspace.getName());
//        }
//        if (workspace.getDescription() != null) {
//            sql.append("Description = ?, ");
//            params.add(workspace.getDescription());
//        }
//        if (workspace.getAddress() != null) {
//            sql.append("Address = ?, ");
//            params.add(workspace.getAddress());
//        }
//        if (workspace.getCreationDate() != null) {
//            sql.append("CreatedDate = ?, ");
//            params.add(workspace.getCreationDate());
//        }
//        if (workspace.getAvgRating() != 0.0) { // Assuming 0.0 is not a valid value
//            sql.append("AvgRating = ?, ");
//            params.add(workspace.getAvgRating());
//        }
//        if (workspace.getType() != null) {
//            sql.append("Type = ?, ");
//            params.add(workspace.getType());
//        }
//
//        // Remove the trailing comma and space
//        sql.delete(sql.length() - 2, sql.length());
//
//        // Add the WHERE clause
//        sql.append(" WHERE Id = ?");
//        params.add(workspace.getId());
//
//        // Execute the update
//        jdbcTemplate.update(sql.toString(), params.toArray());
//    }

    // Get Workspace by ID
//    @Override
//    public Workspace getById(String id) {
//        try {
//            String sql = "SELECT * FROM Workspace WHERE Id = ?";
//            return jdbcTemplate.queryForObject(sql, new WorkspaceRowMapper(), id);
//        } catch (EmptyResultDataAccessException e) {
//            return null;
//        }
//    }

    @Override
    public Workspace getById(String id) {
        try {
            String sql = "SELECT w.*, l.City, l.Town, l.Country, l.Longitude, l.Latitude " +
                    "FROM Workspace w " +
                    "LEFT JOIN Location l ON w.LocationId = l.Id " +
                    "WHERE w.Id = ?";
            return jdbcTemplate.queryForObject(sql, new WorkspaceRowMapper(), id);
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    // Find All Workspaces
    @Override
    public List<Workspace> findAll() {
        String sql = "SELECT * FROM Workspace";
        return jdbcTemplate.query(sql, new WorkspaceRowMapper());
    }

    @Override
    public List<Workspace> findByLocationId(String locationId) {
        String sql = "SELECT * FROM Workspace WHERE LocationId = ?";
        return jdbcTemplate.query(sql, new WorkspaceRowMapper(), locationId);
    }
    @Override
    public List<Workspace> findByStaffId(String staffId) {
        String sql = "SELECT w.* FROM Workspace w " +
                "JOIN workspacesupervise ws ON w.Id = ws.WorkspaceId " +
                "WHERE ws.StaffId = ?";
        return jdbcTemplate.query(sql, new WorkspaceRowMapper(), staffId);
    }

    // RowMapper for Workspace
//    private static class WorkspaceRowMapper implements RowMapper<Workspace> {
//        @Override
//        public Workspace mapRow(ResultSet rs, int rowNum) throws SQLException {
//            Workspace workspace = new Workspace();
//            workspace.setId(rs.getString("Id"));
//            workspace.setName(rs.getString("Name"));
//            workspace.setDescription(rs.getString("Description"));
//            workspace.setAddress(rs.getString("Address"));
//            workspace.setCreationDate(rs.getDate("CreatedDate"));
//            workspace.setAvgRating(rs.getDouble("AvgRating"));
//            workspace.setType(rs.getString("Type"));
//            workspace.setPaymentType(PaymentType.valueOf(rs.getString("PaymentType")));
//            // Note: Location, rooms, images, reviews are loaded separately
//            return workspace;
//        }
//    }

    private static class WorkspaceRowMapper implements RowMapper<Workspace> {
        @Override
        public Workspace mapRow(ResultSet rs, int rowNum) throws SQLException {
            Workspace workspace = new Workspace();
            workspace.setId(rs.getString("Id"));
            workspace.setName(rs.getString("Name"));
            workspace.setDescription(rs.getString("Description"));
            workspace.setAddress(rs.getString("Address"));
            workspace.setCreationDate(rs.getDate("CreatedDate"));
            workspace.setAvgRating(rs.getDouble("AvgRating"));
            workspace.setType(rs.getString("Type"));
            workspace.setPaymentType(PaymentType.valueOf(rs.getString("PaymentType")));

            // Set location data if it exists
//            if (rs.getString("LocationId") != null) {
//                Location location = new Location();
//                location.setId(rs.getString("LocationId"));
//                location.setCity(rs.getString("City"));
//                location.setTown(rs.getString("Town"));
//                location.setCountry(rs.getString("Country"));
//                location.setLongitude(rs.getDouble("Longitude"));
//                location.setLatitude(rs.getDouble("Latitude"));
//                workspace.setLocation(location);
//            }

            // Add location data
            Location location = new Location();
            location.setId(rs.getString("LocationId"));
            // You'll need to fetch additional location details from the Location table
            workspace.setLocation(location);

            return workspace;
        }
    }

    @Override
    public void addToFavourites(String workspaceId, String userId, String roomId) {
        String sql = "INSERT INTO FavouriteWorkspaceRooms (UserId, WorkspaceId, RoomId) VALUES (?, ?, ?)";
        jdbcTemplate.update(sql, userId, workspaceId, roomId);
    }

    @Override
    public List<Workspace> getFavourites(String userId) {
        String sql = "SELECT w.* FROM Workspace AS w " +
                "JOIN FavouriteWorkspaceRooms AS fwr ON w.Id = fwr.WorkspaceId " +
                "WHERE fwr.UserId = ?";
        return jdbcTemplate.query(sql, new WorkspaceRowMapper(), userId);
    }

    // Add a new method to get both workspace and room favorites
    @Override
    public List<Map<String, String>> getFavoriteWorkspaceRooms(String userId) {
        String sql = "SELECT fwr.WorkspaceId, fwr.RoomId FROM FavouriteWorkspaceRooms fwr " +
                "WHERE fwr.UserId = ?";
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            Map<String, String> result = new HashMap<>();
            result.put("workspaceId", rs.getString("WorkspaceId"));
            result.put("roomId", rs.getString("RoomId"));
            return result;
        }, userId);
    }

    @Override
    public boolean addFavoriteWorkspaceRoom(String userId, String roomId) {
        String sql = "INSERT INTO FavouriteWorkspaceRooms (UserId, RoomId) VALUES (?, ?)";
        int rowsAffected = jdbcTemplate.update(sql, userId, roomId);
        return rowsAffected > 0; // Return true if a row was inserted
    }

    @Override
    public boolean deleteFavoriteWorkspaceRoom(String userId, String roomId) {
        String sql = "DELETE FROM FavouriteWorkspaceRooms WHERE UserId = ? AND RoomId = ?";
        int rowsAffected = jdbcTemplate.update(sql, userId, roomId);
        return rowsAffected > 0; // Return true if a row was deleted
    }

    @Override
    public boolean addFavoriteWorkspace(String userId, String workspaceId) {
        String sql = "INSERT INTO FavouriteWorkspaceRooms (UserId, WorkspaceId) VALUES (?, ?)";
        int rowsAffected = jdbcTemplate.update(sql, userId, workspaceId);
        return rowsAffected > 0; // Return true if a row was inserted
    }

    @Override
    public boolean deleteFavoriteWorkspace(String userId, String workspaceId) {
        String sql = "DELETE FROM FavouriteWorkspaceRooms WHERE UserId = ? AND WorkspaceId = ?";
        int rowsAffected = jdbcTemplate.update(sql, userId, workspaceId);
        return rowsAffected > 0; // Return true if a row was deleted
    }

    @Override
    public Workspace getByRoomId(String roomId) {
        try {
            String sql = "SELECT w.* FROM Workspace w " +
                    "JOIN Room r ON w.Id = r.WorkspaceId " +
                    "WHERE r.Id = ?";
            return jdbcTemplate.queryForObject(sql, new WorkspaceRowMapper(), roomId);
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    @Override
    public List<Workspace> findByNameContaining(String query) {
        String sql = "SELECT * FROM Workspace WHERE LOWER(Name) LIKE ?";
        String pattern = "%" + query.toLowerCase() + "%";
        return jdbcTemplate.query(sql, new WorkspaceRowMapper(), pattern);
    }

    @Override
    public void addSupervision(String staffId, String workspaceId) {
        final String sql =
                "INSERT INTO WorkspaceSupervise (StaffId, WorkspaceId) VALUES (?, ?)";
        jdbcTemplate.update(sql, staffId, workspaceId);
    }
    @Override
    public void deleteSupervision(String staffId, String workspaceId) {
        final String sql =
                "DELETE FROM WorkspaceSupervise WHERE StaffId = ? AND WorkspaceId = ?";
        jdbcTemplate.update(sql, staffId, workspaceId);
    }
    @Override
    public List<String> findWorkspaceIdsBySupervisor(String staffId) {
        String sql = "SELECT WorkspaceId FROM WorkspaceSupervise WHERE StaffId = ?";
        return jdbcTemplate.queryForList(sql, String.class, staffId);
    }

    @Override
    public List<String> findSupervisorIdsByWorkspace(String workspaceId) {
        String sql = "SELECT StaffId FROM WorkspaceSupervise WHERE WorkspaceId = ?";
        return jdbcTemplate.queryForList(sql, String.class, workspaceId);
    }

}
