package org.example.roomly.repository.impl;

import org.example.roomly.model.WorkspaceSchedule;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class WorkspaceScheduleRepository implements org.example.roomly.repository.WorkspaceScheduleRepository {

    private JdbcTemplate jdbcTemplate;

    @Autowired
    public WorkspaceScheduleRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public void save(WorkspaceSchedule schedule) {
        String sql = "INSERT INTO WorkspaceSchedule (Day, StartTime, EndTime, WorkspaceId) VALUES (?, ?, ?, ?)";
        jdbcTemplate.update(sql,
                schedule.getDay(),
                schedule.getStartTime(),  // Directly use String
                schedule.getEndTime(),    // Directly use String
                schedule.getWorkspaceId()
        );
    }

    @Override
    public void delete(String workspaceId, String day) {
        String sql = "DELETE FROM WorkspaceSchedule WHERE WorkspaceId = ? AND Day = ?";
        jdbcTemplate.update(sql, workspaceId, day);
    }

    @Override
    public void update(WorkspaceSchedule schedule) {
        String sql = "UPDATE WorkspaceSchedule SET StartTime = ?, EndTime = ? WHERE WorkspaceId = ? AND Day = ?";
        jdbcTemplate.update(sql,
                schedule.getStartTime(),
                schedule.getEndTime(),
                schedule.getWorkspaceId(),
                schedule.getDay()
        );
    }

    @Override
    public WorkspaceSchedule getByWorkspaceIdAndDay(String workspaceId, String day) {
        String sql = "SELECT * FROM WorkspaceSchedule WHERE WorkspaceId = ? AND Day = ?";
        return jdbcTemplate.queryForObject(sql, new WorkspaceScheduleRowMapper(), workspaceId, day);
    }

    @Override
    public List<WorkspaceSchedule> getByWorkspaceId(String workspaceId) {
        String sql = "SELECT * FROM WorkspaceSchedule WHERE WorkspaceId = ?";
        return jdbcTemplate.query(sql, new WorkspaceScheduleRowMapper(), workspaceId);
    }

    @Override
    public List<WorkspaceSchedule> getAll() {
        String sql = "SELECT * FROM WorkspaceSchedule";
        return jdbcTemplate.query(sql, new WorkspaceScheduleRowMapper());
    }

    private static class WorkspaceScheduleRowMapper implements RowMapper<WorkspaceSchedule> {
        @Override
        public WorkspaceSchedule mapRow(ResultSet rs, int rowNum) throws SQLException {
            WorkspaceSchedule schedule = new WorkspaceSchedule();
            schedule.setDay(rs.getString("Day"));
            schedule.setStartTime(rs.getString("StartTime"));  // Directly get as String
            schedule.setEndTime(rs.getString("EndTime"));      // Directly get as String
            schedule.setWorkspaceId(rs.getString("WorkspaceId"));
            return schedule;
        }
    }
}