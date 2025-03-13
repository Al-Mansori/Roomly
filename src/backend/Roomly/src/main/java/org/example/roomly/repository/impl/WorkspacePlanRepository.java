package org.example.roomly.repository.impl;

import org.example.roomly.model.WorkspacePlan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class WorkspacePlanRepository implements org.example.roomly.repository.WorkspacePlanRepository {

    private final JdbcTemplate jdbcTemplate;

    @Autowired
    public WorkspacePlanRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public void save(WorkspacePlan workspacePlan, String workspaceId) {
        String sql = "INSERT INTO WorkspacePlan (WorkspaceId, YearPrice, MonthPrice) VALUES (?, ?, ?)";
        jdbcTemplate.update(sql, workspaceId, workspacePlan.getYearPrice(), workspacePlan.getMonthPrice());
    }

    @Override
    public void delete(String workspaceId) {
        String sql = "DELETE FROM WorkspacePlan WHERE WorkspaceId = ?";
        jdbcTemplate.update(sql, workspaceId);
    }

    @Override
    public List<WorkspacePlan> findAll() {
        String sql = "SELECT YearPrice, MonthPrice FROM WorkspacePlan";
        return jdbcTemplate.query(sql, new WorkspacePlanRowMapper());
    }

    @Override
    public WorkspacePlan findById(String workspaceId) {
        String sql = "SELECT YearPrice, MonthPrice FROM WorkspacePlan WHERE WorkspaceId = ?";
        return jdbcTemplate.queryForObject(sql, new WorkspacePlanRowMapper(), workspaceId);
    }

    @Override
    public void update(WorkspacePlan workspacePlan, String workspaceId) {
        String sql = "UPDATE WorkspacePlan SET YearPrice = ?, MonthPrice = ? WHERE WorkspaceId = ?";
        jdbcTemplate.update(sql, workspacePlan.getYearPrice(), workspacePlan.getMonthPrice(), workspaceId);
    }

    public static class WorkspacePlanRowMapper implements RowMapper<WorkspacePlan> {
        @Override
        public WorkspacePlan mapRow(ResultSet rs, int rowNum) throws SQLException {
            WorkspacePlan workspacePlan = new WorkspacePlan();
            workspacePlan.setYearPrice(rs.getDouble("YearPrice"));
            workspacePlan.setMonthPrice(rs.getDouble("MonthPrice"));
            return workspacePlan;
        }
    }
}

