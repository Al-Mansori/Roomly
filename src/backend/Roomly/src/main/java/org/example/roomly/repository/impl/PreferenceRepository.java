package org.example.roomly.repository.impl;

import org.example.roomly.model.Preference;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public class PreferenceRepository implements org.example.roomly.repository.PreferenceRepository {
    private final JdbcTemplate jdbcTemplate;

    public PreferenceRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // 1. Insert a new preference
    @Override
    public void save(Preference preference) {
        String sql = "INSERT INTO Preference (BudgetPreference, WorkspaceTypePreference, UserId) VALUES (?, ?, ?)";
        jdbcTemplate.update(sql, preference.getBudgetPreference(), preference.getWorkspaceTypePreference(), preference.getUserId());
    }

    // 2. Retrieve a preference by UserId
    @Override
    public Preference findById(String userId) {
        String sql = "SELECT * FROM Preference WHERE UserId = ?";
        return jdbcTemplate.queryForObject(sql, new PreferenceRowMapper(), userId);
    }

    // 3. Retrieve all preferences
    @Override
    public List<Preference> findAll() {
        String sql = "SELECT * FROM Preference";
        return jdbcTemplate.query(sql, new PreferenceRowMapper());
    }

    // 4. Update a preference by UserId
    @Override
    public void update(Preference preference) {
        String sql = "UPDATE Preference SET BudgetPreference = ?, WorkspaceTypePreference = ? WHERE UserId = ?";
        jdbcTemplate.update(sql, preference.getBudgetPreference(), preference.getWorkspaceTypePreference(), preference.getUserId());
    }

    // 5. Delete a preference by UserId
    @Override
    public void deleteById(String userId) {
        String sql = "DELETE FROM Preference WHERE UserId = ?";
        jdbcTemplate.update(sql, userId);
    }

    private static class PreferenceRowMapper implements RowMapper<Preference> {
        @Override
        public Preference mapRow(ResultSet rs, int rowNum) throws SQLException {
            Preference preference = new Preference();
            preference.setBudgetPreference(rs.getString("BudgetPreference"));
            preference.setWorkspaceTypePreference(rs.getString("WorkspaceTypePreference"));
            preference.setUserId(rs.getString("UserId"));
            return preference;
        }
    }
}
