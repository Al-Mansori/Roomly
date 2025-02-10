package org.example.roomly.repository;

import org.example.roomly.model.Preference;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public class PreferenceRepository {
    private final JdbcTemplate jdbcTemplate;

    public PreferenceRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // RowMapper using lambda function
    private final RowMapper<Preference> rowMapper = (rs, rowNum) -> new Preference(
            rs.getString("BudgetPreference"),
            rs.getString("WorkspaceTypePreference"),
            rs.getString("UserId")
    );

    // 1. Insert a new preference
    public void save(Preference preference) {
        String sql = "INSERT INTO Preference (BudgetPreference, WorkspaceTypePreference, UserId) VALUES (?, ?, ?)";
        jdbcTemplate.update(sql, preference.getBudgetPreference(), preference.getWorkspaceTypePreference(), preference.getUserId());
    }

    // 2. Retrieve a preference by UserId
    public Optional<Preference> findById(String userId) {
        String sql = "SELECT * FROM Preference WHERE UserId = ?";
        return jdbcTemplate.query(sql, rowMapper, userId).stream().findFirst();
    }

    // 3. Retrieve all preferences
    public List<Preference> findAll() {
        String sql = "SELECT * FROM Preference";
        return jdbcTemplate.query(sql, rowMapper);
    }

    // 4. Update a preference by UserId
    public void update(Preference preference) {
        String sql = "UPDATE Preference SET BudgetPreference = ?, WorkspaceTypePreference = ? WHERE UserId = ?";
        jdbcTemplate.update(sql, preference.getBudgetPreference(), preference.getWorkspaceTypePreference(), preference.getUserId());
    }

    // 5. Delete a preference by UserId
    public void deleteById(String userId) {
        String sql = "DELETE FROM Preference WHERE UserId = ?";
        jdbcTemplate.update(sql, userId);
    }
}
