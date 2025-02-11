package org.example.roomly.repository;

import org.example.roomly.model.WorkspaceStaff;
import org.example.roomly.model.WorkspaceStaffType;

import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class WorkspaceStaffRepository {
    private final JdbcTemplate jdbcTemplate;

    public WorkspaceStaffRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public void save(WorkspaceStaff staff) {
        String sql = "INSERT INTO WorkspaceStaff (Id, FName, LName, Name, Email, Password, Phone, Type) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql, staff.getUserId(), staff.getFirstName(), staff.getLastName(),
                staff.getFirstName() + " " + staff.getLastName(), // Assuming Name is full name
                staff.getEmail(), staff.getPassword(), staff.getPhone(), staff.getType().toString());
    }

    public WorkspaceStaff findById(String id) {
        String sql = "SELECT * FROM WorkspaceStaff WHERE Id = ?";
        return jdbcTemplate.queryForObject(sql, new Object[]{id},
                (rs, rowNum) -> new WorkspaceStaff(
                        rs.getString("Id"),
                        rs.getString("FName"),
                        rs.getString("LName"),
                        rs.getString("Email"),
                        rs.getString("Password"),
                        rs.getString("Phone"),
                        WorkspaceStaffType.valueOf(rs.getString("Type"))
                )
        );
    }

    public List<WorkspaceStaff> findAll() {
        String sql = "SELECT * FROM WorkspaceStaff";
        return jdbcTemplate.query(sql,
                (rs, rowNum) -> new WorkspaceStaff(
                        rs.getString("Id"),
                        rs.getString("FName"),
                        rs.getString("LName"),
                        rs.getString("Email"),
                        rs.getString("Password"),
                        rs.getString("Phone"),
                        WorkspaceStaffType.valueOf(rs.getString("Type"))
                )
        );
    }

    public void update(WorkspaceStaff staff) {
        String sql = "UPDATE WorkspaceStaff SET FName = ?, LName = ?, Email = ?, Password = ?, Phone = ?, Type = ? WHERE Id = ?";
        jdbcTemplate.update(sql, staff.getFirstName(), staff.getLastName(), staff.getEmail(),
                staff.getPassword(), staff.getPhone(), staff.getType().toString(), staff.getUserId());
    }

    public void deleteById(String id) {
        String sql = "DELETE FROM WorkspaceStaff WHERE Id = ?";
        jdbcTemplate.update(sql, id);
    }

    public boolean existsByEmail(String email) {
        String sql = "SELECT COUNT(*) FROM WorkspaceStaff WHERE Email = ?";
        return jdbcTemplate.queryForObject(sql, new Object[]{email}, Integer.class) > 0;
    }
}
