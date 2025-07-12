package org.example.roomly.repository.impl;

import org.example.roomly.model.Customer;
import org.example.roomly.model.WorkspaceStaff;
import org.example.roomly.model.WorkspaceStaffType;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class WorkspaceStaffRepository implements org.example.roomly.repository.WorkspaceStaffRepository {
    private final JdbcTemplate jdbcTemplate;

    public WorkspaceStaffRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public void save(WorkspaceStaff staff) {
        String sql = "INSERT INTO WorkspaceStaff (Id, FName, LName, Name, Email, Password, Phone, Type) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql,staff.getId(), staff.getFirstName(), staff.getLastName(),
                staff.getFirstName() + " " + staff.getLastName(), // Assuming Name is full name
                staff.getEmail(), staff.getPassword(), staff.getPhone(), staff.getType().toString());
    }

    @Override
    public WorkspaceStaff findById(String id) {
        String sql = "SELECT * FROM WorkspaceStaff WHERE Id = ?";
        return jdbcTemplate.queryForObject(sql, new WorkspaceStaffRowMapper(), id);
    }

    @Override
    public WorkspaceStaff findByEmail(String email) {
        String sql = "SELECT * FROM WorkspaceStaff WHERE email = ?";
        return jdbcTemplate.queryForObject(sql, new WorkspaceStaffRowMapper(), email);
    }

    @Override
    public List<WorkspaceStaff> findAll() {
        String sql = "SELECT * FROM WorkspaceStaff";
        return jdbcTemplate.query(sql, new WorkspaceStaffRowMapper());
    }

//    @Override
//    public void update(WorkspaceStaff staff) {
//        String sql = "UPDATE WorkspaceStaff SET FName = ?, LName = ?, Email = ?, Password = ?, Phone = ? WHERE Id = ?";
//        jdbcTemplate.update(sql, staff.getFirstName(), staff.getLastName(), staff.getEmail(),
//                staff.getPassword(), staff.getPhone(), staff.getId());
//    }

    @Override
    public void update(WorkspaceStaff staff) {
        String sql = "UPDATE WorkspaceStaff SET FName = ?, LName = ?, Phone = ?, Type = ? WHERE Id = ?";
        jdbcTemplate.update(sql,
                staff.getFirstName(),
                staff.getLastName(),
                staff.getPhone(),
                staff.getType().toString(),
                staff.getId());
    }

    @Override
    public void deleteById(String id) {
        String sql = "DELETE FROM WorkspaceStaff WHERE Id = ?";
        jdbcTemplate.update(sql, id);
    }

    @Override
    public boolean existsByEmail(String email) {
        String sql = "SELECT COUNT(*) FROM WorkspaceStaff WHERE Email = ?";
        return jdbcTemplate.queryForObject(sql, new Object[]{email}, Integer.class) > 0;
    }

    @Override
    public boolean existsById(String id) {
        String sql = "SELECT COUNT(*) FROM WorkspaceStaff WHERE Id = ?";
        return jdbcTemplate.queryForObject(sql, new Object[]{id}, Integer.class) > 0;
    }


    private static class WorkspaceStaffRowMapper implements RowMapper<WorkspaceStaff> {
        @Override
        public WorkspaceStaff mapRow(ResultSet rs, int rowNum) throws SQLException {
            WorkspaceStaff staff = new WorkspaceStaff();
            staff.setId(rs.getString("Id"));
            staff.setFirstName(rs.getString("FName"));
            staff.setLastName(rs.getString("LName"));
            staff.setEmail(rs.getString("Email"));
            staff.setPassword(rs.getString("Password"));
            staff.setPhone(rs.getString("Phone"));
            staff.setType(WorkspaceStaffType.valueOf(rs.getString("Type")));
            return staff;
        }
    }

    @Override
    public void blockUser(String staffId, String userId) {
        String sql = "INSERT INTO suspendedusers VALUES( ?, ?)";
        jdbcTemplate.update(sql,userId,staffId);
    }

    @Override
    public void unblockUser(String staffId, String userId) {
        String sql = "DELETE FROM suspendedusers WHERE UserId = ? AND StaffId = ?";
        jdbcTemplate.update(sql, userId, staffId);
    }

    @Override
    public List<String> getBlockedUsers(String staffId) {
        String sql = "SELECT UserId FROM suspendedusers WHERE StaffId = ?";
        return jdbcTemplate.queryForList(sql, String.class, staffId);
    }

    @Override
    public List<String> findStaffIdsByWorkspaceId(String workspaceId) {
        String sql = "SELECT StaffId FROM WorkspaceSupervise WHERE WorkspaceId = ?";
        return jdbcTemplate.queryForList(sql, String.class, workspaceId);
    }

    @Override
    public List<String> findWorkspaceIdsByStaffId(String staffId) {
        String sql = "SELECT WorkspaceId FROM WorkspaceSupervise WHERE StaffId = ?";
        return jdbcTemplate.queryForList(sql, String.class, staffId);
    }
}
