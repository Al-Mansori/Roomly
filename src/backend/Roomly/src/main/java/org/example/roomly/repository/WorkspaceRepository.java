package org.example.roomly.repository;

import org.example.roomly.model.Workspace;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@Repository
public class WorkspaceRepository {

    private JdbcTemplate jdbcTemplate;

    @Autowired
    public WorkspaceRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // Save Workspace
    public void save(Workspace workspace) {
        String sql = "INSERT INTO Workspace (Id, Name, Description, Address, CreatedDate, AvgRating, Type) VALUES (?, ?, ?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql, workspace.getId(), workspace.getName(), workspace.getDescription(), workspace.getAddress(), workspace.getCreationDate(), workspace.getAvgRating(), workspace.getType());
    }

    // Delete Workspace by ID
    public void delete(String id) {
        String sql = "DELETE FROM Workspace WHERE Id = ?";
        jdbcTemplate.update(sql, id);
    }

    // Update Workspace
    public void update(Workspace workspace) {
        String sql = "UPDATE Workspace SET Name = ?, Description = ?, Address = ?, CreatedDate = ?, AvgRating = ?, Type = ? WHERE Id = ?";
        jdbcTemplate.update(sql, workspace.getName(), workspace.getDescription(), workspace.getAddress(), workspace.getCreationDate(), workspace.getAvgRating(), workspace.getType(), workspace.getId());
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
    public Workspace getById(String id) {
        String sql = "SELECT * FROM Workspace WHERE Id = ?";
        return jdbcTemplate.queryForObject(sql, new WorkspaceRowMapper(), id);
    }

    // Find All Workspaces
    public List<Workspace> findAll() {
        String sql = "SELECT * FROM Workspace";
        return jdbcTemplate.query(sql, new WorkspaceRowMapper());
    }

    // RowMapper for Workspace
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
            return workspace;
        }
    }
}
