package org.example.roomly.repository.impl;

import org.example.roomly.model.PaymentType;
import org.example.roomly.model.Room;
import org.example.roomly.model.RoomStatus;
import org.example.roomly.model.RoomType;
import org.example.roomly.service.AmenityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Repository
public class RoomRepository implements org.example.roomly.repository.RoomRepository {

    private JdbcTemplate jdbcTemplate;

    @Autowired
    private AmenityService amenityService;

    @Autowired
    public RoomRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // Save Room
    @Override
    public void save(Room room, String workspaceId) {
        String sql = "INSERT INTO Room (Id, Name, Type, Description, Capacity, PricePerHour, RoomStatus, AvailableCount, WorkspaceId) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql,
                room.getId(),
                room.getName(),
                // store enum name or null
                room.getType() != null ? room.getType().name() : null,
                room.getDescription(),
                room.getCapacity(),
                room.getPricePerHour(),
                room.getStatus() != null ? room.getStatus().name() : null,
                room.getAvailableCount(),
                workspaceId);
    }

    // Delete Room by ID
    @Override
    public void delete(String id) {
        // Delete room availability records first
        jdbcTemplate.update("DELETE FROM RoomAvailability WHERE RoomId = ?", id);

        // Delete images
        jdbcTemplate.update("DELETE FROM Images WHERE RoomId = ?", id);

        // Delete amenities and their dependencies
        List<String> amenityIds = jdbcTemplate.queryForList(
                "SELECT Id FROM Amenity WHERE RoomId = ?",
                String.class,
                id
        );
        amenityIds.forEach(amenityService::deleteAmenity);

        // Delete other room dependencies
        jdbcTemplate.update("DELETE FROM Apply WHERE RoomId = ?", id);
        jdbcTemplate.update("DELETE FROM FavouriteWorkspaceRooms WHERE RoomId = ?", id);
        jdbcTemplate.update("DELETE FROM Recovery WHERE RoomId = ? OR RecoveryRoomId = ?", id, id);
        jdbcTemplate.update("DELETE FROM Booking WHERE RoomId = ?", id);

        // Finally delete room
        jdbcTemplate.update("DELETE FROM Room WHERE Id = ?", id);
    }

    // Update Room
    @Override
    public void update(Room room) {
        String sql = "UPDATE Room SET Name = ?, Type = ?, Description = ?, Capacity = ?, PricePerHour = ?, RoomStatus = ?, AvailableCount = ? WHERE Id = ?";
        jdbcTemplate.update(sql,
                room.getName(),
                room.getType() != null ? room.getType().name() : null,
                room.getDescription(),
                room.getCapacity(),
                room.getPricePerHour(),
                room.getStatus() != null ? room.getStatus().name() : null,
                room.getAvailableCount(),
                room.getId());
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

    @Override
    public String findWorkspaceIdByRoomId(String roomId) {
        String sql = "SELECT WorkspaceId FROM Room WHERE Id = ?";
        try {
            return jdbcTemplate.queryForObject(sql, String.class, roomId);
        } catch (EmptyResultDataAccessException e) {
            return null; // Room not found
        }
    }

    @Override
    public List<Room> findByType(RoomType type) {
        String sql = "SELECT * FROM Room WHERE Type = ?";
        return jdbcTemplate.query(sql, new RoomRowMapper(), type.name());
    }
    
    @Override
    public List<Room> filterRooms(
            PaymentType paymentMethod,
            String plan,
            RoomType roomType,
            Integer numberOfSeats,
            Double minPrice,
            Double maxPrice,
            List<String> amenityNames) {

        StringBuilder sql = new StringBuilder("SELECT DISTINCT r.* FROM Room r");
        List<Object> params = new ArrayList<>();

        boolean joinWorkspace = paymentMethod != null;
        boolean joinPlan = plan != null;
        boolean joinAmenity = amenityNames != null && !amenityNames.isEmpty();

        // Conditionally add JOIN clauses
        if (joinWorkspace) {
            sql.append(" JOIN Workspace w ON r.WorkspaceId = w.Id");
        }
        if (joinPlan) {
            sql.append(" LEFT JOIN WorkspacePlan wp ON r.WorkspaceId = wp.WorkspaceId");
        }
        if (joinAmenity) {
            sql.append(" LEFT JOIN Amenity a ON r.Id = a.RoomId");
        }

        // Base WHERE clause
        sql.append(" WHERE r.RoomStatus = 'Available'");

        // Payment method filter
        if (paymentMethod != null) {
            sql.append(" AND w.PaymentType = ?");
            params.add(paymentMethod.name());
        }

        // Plan-based pricing
        if (plan != null) {
            switch (plan.toLowerCase()) {
                case "daily":
                    sql.append(" AND wp.DailyPrice IS NOT NULL");
                    if (minPrice != null) {
                        sql.append(" AND wp.DailyPrice >= ?");
                        params.add(minPrice);
                    }
                    if (maxPrice != null) {
                        sql.append(" AND wp.DailyPrice <= ?");
                        params.add(maxPrice);
                    }
                    break;
                case "monthly":
                    sql.append(" AND wp.MonthPrice IS NOT NULL");
                    if (minPrice != null) {
                        sql.append(" AND wp.MonthPrice >= ?");
                        params.add(minPrice);
                    }
                    if (maxPrice != null) {
                        sql.append(" AND wp.MonthPrice <= ?");
                        params.add(maxPrice);
                    }
                    break;
                case "yearly":
                    sql.append(" AND wp.YearPrice IS NOT NULL");
                    if (minPrice != null) {
                        sql.append(" AND wp.YearPrice >= ?");
                        params.add(minPrice);
                    }
                    if (maxPrice != null) {
                        sql.append(" AND wp.YearPrice <= ?");
                        params.add(maxPrice);
                    }
                    break;
            }
        } else {
            // Hourly pricing
            if (minPrice != null) {
                sql.append(" AND r.PricePerHour >= ?");
                params.add(minPrice);
            }
            if (maxPrice != null) {
                sql.append(" AND r.PricePerHour <= ?");
                params.add(maxPrice);
            }
        }

        // Room type filter - Updated to use roomType.name()
        if (roomType != null) {
            sql.append(" AND r.Type = ?");
            params.add(roomType.name());
        }

        // Seat availability filter
        if (numberOfSeats != null) {
            sql.append(" AND r.AvailableCount >= ?");
            params.add(numberOfSeats);
        }

        // Amenities filter
        if (joinAmenity) {
            sql.append(" AND a.Name IN (");
            sql.append(String.join(",", Collections.nCopies(amenityNames.size(), "?")));
            sql.append(")");
            params.addAll(amenityNames);
        }

        return jdbcTemplate.query(
                sql.toString(),
                new RoomRowMapper(),
                params.toArray());
    }

    @Override
    public List<Room> findByNameContaining(String query) {
        String sql = "SELECT * FROM Room WHERE LOWER(Name) LIKE ?";
        String pattern = "%" + query.toLowerCase() + "%";
        return jdbcTemplate.query(sql, new RoomRowMapper(), pattern);
    }


    @Override
    public List<Room> filterRoomsWithQuery(
            PaymentType paymentMethod,
            String plan,
            RoomType roomType,
            Integer numberOfSeats,
            Double minPrice,
            Double maxPrice,
            List<String> amenityNames,
            String query) {

        StringBuilder sql = new StringBuilder("SELECT DISTINCT r.* FROM Room r");
        List<Object> params = new ArrayList<>();

        boolean joinWorkspace = paymentMethod != null || (query != null && !query.isEmpty());
        boolean joinPlan = plan != null;
        boolean joinAmenity = amenityNames != null && !amenityNames.isEmpty();

        if (joinWorkspace) {
            sql.append(" JOIN Workspace w ON r.WorkspaceId = w.Id");
        }
        if (joinPlan) {
            sql.append(" LEFT JOIN WorkspacePlan wp ON r.WorkspaceId = wp.WorkspaceId");
        }
        if (joinAmenity) {
            sql.append(" LEFT JOIN Amenity a ON r.Id = a.RoomId");
        }

        sql.append(" WHERE r.RoomStatus = 'Available'");

        // Add text search condition
        if (query != null && !query.isEmpty()) {
            sql.append(" AND (LOWER(r.Name) LIKE ? OR LOWER(w.Name) LIKE ?)");
            String pattern = "%" + query.toLowerCase() + "%";
            params.add(pattern);
            params.add(pattern);
        }


        // Payment method filter
        if (paymentMethod != null) {
            sql.append(" AND w.PaymentType = ?");
            params.add(paymentMethod.name());
        }

        // Plan-based pricing
        if (plan != null) {
            switch (plan.toLowerCase()) {
                case "daily":
                    sql.append(" AND wp.DailyPrice IS NOT NULL");
                    if (minPrice != null) {
                        sql.append(" AND wp.DailyPrice >= ?");
                        params.add(minPrice);
                    }
                    if (maxPrice != null) {
                        sql.append(" AND wp.DailyPrice <= ?");
                        params.add(maxPrice);
                    }
                    break;
                case "monthly":
                    sql.append(" AND wp.MonthPrice IS NOT NULL");
                    if (minPrice != null) {
                        sql.append(" AND wp.MonthPrice >= ?");
                        params.add(minPrice);
                    }
                    if (maxPrice != null) {
                        sql.append(" AND wp.MonthPrice <= ?");
                        params.add(maxPrice);
                    }
                    break;
                case "yearly":
                    sql.append(" AND wp.YearPrice IS NOT NULL");
                    if (minPrice != null) {
                        sql.append(" AND wp.YearPrice >= ?");
                        params.add(minPrice);
                    }
                    if (maxPrice != null) {
                        sql.append(" AND wp.YearPrice <= ?");
                        params.add(maxPrice);
                    }
                    break;
            }
        } else {
            // Hourly pricing
            if (minPrice != null) {
                sql.append(" AND r.PricePerHour >= ?");
                params.add(minPrice);
            }
            if (maxPrice != null) {
                sql.append(" AND r.PricePerHour <= ?");
                params.add(maxPrice);
            }
        }

        // Room type filter
        if (roomType != null) {
            sql.append(" AND r.Type = ?");
            params.add(roomType.name());
        }

        // Seat availability filter
        if (numberOfSeats != null) {
            sql.append(" AND r.AvailableCount >= ?");
            params.add(numberOfSeats);
        }

        // Amenities filter
        if (joinAmenity) {
            sql.append(" AND a.Name IN (");  // Filter by name instead of ID
            sql.append(String.join(",", Collections.nCopies(amenityNames.size(), "?")));
            sql.append(")");
            params.addAll(amenityNames);
        }

        return jdbcTemplate.query(
                sql.toString(),
                new RoomRowMapper(),
                params.toArray()
        );
    }

    @Override
    public List<Room> findTop5Rooms() {
        String sql = "SELECT * FROM Room LIMIT 5";
        return jdbcTemplate.query(sql, new RoomRowMapper());
    }

    // RowMapper for Room
    private static class RoomRowMapper implements RowMapper<Room> {
        @Override
        public Room mapRow(ResultSet rs, int rowNum) throws SQLException {
            Room room = new Room();
            room.setId(rs.getString("Id"));
            room.setName(rs.getString("Name"));
            room.setType(RoomType.valueOf(rs.getString("Type").toUpperCase()));
            room.setDescription(rs.getString("Description"));
            room.setCapacity(rs.getInt("Capacity"));
            room.setPricePerHour(rs.getDouble("PricePerHour"));
            room.setStatus(RoomStatus.valueOf(rs.getString("RoomStatus").toUpperCase()));
            room.setAvailableCount(rs.getInt("AvailableCount"));
            return room;
        }
    }
}