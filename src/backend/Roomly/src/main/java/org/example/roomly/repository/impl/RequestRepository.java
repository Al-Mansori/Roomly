package org.example.roomly.repository.impl;
import org.example.roomly.model.Request;
import org.example.roomly.model.RequestStatus;
import org.example.roomly.model.WorkspaceStaffType;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.Timestamp;

@Repository
public class RequestRepository implements org.example.roomly.repository.RequestRepository {
    private final JdbcTemplate jdbcTemplate;

    public RequestRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // 1. Create a request
    @Override
    public void save(Request request) {
        String sql = "INSERT INTO Request (Id, RequestType, RequestDate, ResponseDate, Details, Status, RequestResponse) VALUES (?, ?, ?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql, request.getId(), request.getType(),
                new Timestamp(request.getRequestDate().getTime()),
                request.getResponseDate() != null ? new Timestamp(request.getResponseDate().getTime()) : null,
                request.getDetails(), request.getStatus().toString(), request.getRequestResponse());
    }

    // 2. Read a request by ID

    @Override
    public Request findById(String requestId) {
        String sql = "SELECT * FROM Request WHERE Id = ?";
        return jdbcTemplate.queryForObject(sql, new RequestRowMapper(), requestId);
    }

    // 3. Update a request
    @Override
    public void update(Request request) {
        String sql = "UPDATE Request SET RequestType = ?, RequestDate = ?, ResponseDate = ?, Details = ?, Status = ?, RequestResponse = ? WHERE Id = ?";
        jdbcTemplate.update(sql, request.getType(),
                new Timestamp(request.getRequestDate().getTime()),
                request.getResponseDate() != null ? new Timestamp(request.getResponseDate().getTime()) : null,
                request.getDetails(), request.getStatus().toString(), request.getRequestResponse(), request.getId());
    }

    // 4. Delete a request
    @Override
    public void deleteById(String requestId) {
        String sql = "DELETE FROM Request WHERE Id = ?";
        jdbcTemplate.update(sql, requestId);
    }

    // 5. Get all requests
    @Override
    public List<Request> findAll() {
        String sql = "SELECT * FROM Request";
        return jdbcTemplate.query(sql, new RequestRowMapper());
    }

    @Override
    public void saveUserRequesting(String userId, String requestId, String staffId) {
        String sql = "INSERT INTO UserRequesting (UserId, RequestId, StaffId) VALUES (?, ?, ?)";
        jdbcTemplate.update(sql, userId, requestId, staffId);
    }

    @Override
    public void deleteUserRequesting(String requestId) {
        String sql = "DELETE FROM UserRequesting WHERE RequestId = ?";
        jdbcTemplate.update(sql, requestId);
    }

    private static class RequestRowMapper implements RowMapper<Request> {
        @Override
        public Request mapRow(ResultSet rs, int rowNum) throws SQLException {
            Request request = new Request();
            request.setId(rs.getString("RequestId"));
            request.setType(rs.getString("RequestType"));
            request.setRequestDate(rs.getDate("RequestDate"));
            request.setResponseDate(rs.getDate("ResponseDate"));
            request.setDetails(rs.getString("Details"));
            request.setStatus(RequestStatus.valueOf(rs.getString("Status")));
            request.setRequestResponse(rs.getString("RequestResponse"));
            return request;
        }
    }
}
