package org.example.roomly.repository.impl;

import org.example.roomly.model.WorkspacePlan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
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
        String sql = "INSERT INTO WorkspacePlan (WorkspaceId, YearPrice, MonthPrice, DailyPrice) VALUES (?, ?, ?, ?)";
        jdbcTemplate.update(sql, workspaceId, workspacePlan.getYearPrice(),
                workspacePlan.getMonthPrice(), workspacePlan.getDailyPrice());
    }

    @Override
    public void delete(String workspaceId) {
        String sql = "DELETE FROM WorkspacePlan WHERE WorkspaceId = ?";
        jdbcTemplate.update(sql, workspaceId);
    }

    @Override
    public List<WorkspacePlan> findAll() {
        String sql = "SELECT WorkspaceId, YearPrice, MonthPrice, DailyPrice FROM WorkspacePlan";
        return jdbcTemplate.query(sql, new WorkspacePlanRowMapper());
    }

    @Override
    public WorkspacePlan findById(String workspaceId) {
        try {
            String sql = "SELECT WorkspaceId, YearPrice, MonthPrice, DailyPrice FROM WorkspacePlan WHERE WorkspaceId = ?";
            return jdbcTemplate.queryForObject(sql, new WorkspacePlanRowMapper(), workspaceId);
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    @Override
    public void update(WorkspacePlan workspacePlan, String workspaceId) {
        String sql = "UPDATE WorkspacePlan SET YearPrice = ?, MonthPrice = ?, DailyPrice = ? WHERE WorkspaceId = ?";
        jdbcTemplate.update(sql, workspacePlan.getYearPrice(),
                workspacePlan.getMonthPrice(), workspacePlan.getDailyPrice(), workspaceId);
    }

    public static class WorkspacePlanRowMapper implements RowMapper<WorkspacePlan> {
        @Override
        public WorkspacePlan mapRow(ResultSet rs, int rowNum) throws SQLException {
            WorkspacePlan plan = new WorkspacePlan();
            plan.setYearPrice(rs.getDouble("YearPrice"));
            plan.setMonthPrice(rs.getDouble("MonthPrice"));
            plan.setDailyPrice(rs.getDouble("DailyPrice"));
            return plan;
        }
    }
}