package org.example.roomly.repository;

import org.example.roomly.model.Image;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class ImageRepository {

    private JdbcTemplate jdbcTemplate;

    @Autowired
    public ImageRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // Add an image with all fields
    public void addImage(String imageUrl, String staffId, String workspaceId, String roomId, String amenityId) {
        String sql = "INSERT INTO Images (ImageUrl, StaffId, WorkspaceId, RoomId, AmenityId) VALUES (?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql, imageUrl, staffId, workspaceId, roomId, amenityId);
    }

    // Delete an image by URL
    public void deleteImage(String imageUrl) {
        String sql = "DELETE FROM Images WHERE ImageUrl = ?";
        jdbcTemplate.update(sql, imageUrl);
    }

    // Get workspace images
    public List<Image> getWorkspaceImages(String workspaceId) {
        String sql = "SELECT ImageUrl FROM Images WHERE WorkspaceId = ? AND RoomId IS NULL AND AmenityId IS NULL";
        return jdbcTemplate.query(sql, new ImageRowMapper(), workspaceId);
    }

    // Get room images
    public List<Image> getRoomImages(String roomId) {
        String sql = "SELECT ImageUrl FROM Images WHERE RoomId = ? AND AmenityId IS NULL";
        return jdbcTemplate.query(sql, new ImageRowMapper(), roomId);
    }

    // Get amenity images
    public List<Image> getAmenityImages(String amenityId) {
        String sql = "SELECT ImageUrl FROM Images WHERE AmenityId = ?";
        return jdbcTemplate.query(sql, new ImageRowMapper(), amenityId);
    }

    // RowMapper to map the result set to the Image object
    private static final class ImageRowMapper implements RowMapper<Image> {
        @Override
        public Image mapRow(ResultSet rs, int rowNum) throws SQLException {
            Image image = new Image();
            image.setImageUrl(rs.getString("ImageUrl"));
            return image;
        }
    }

}