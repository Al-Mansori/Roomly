package org.example.roomly.repository;
import org.example.roomly.model.Request;
import org.example.roomly.model.RequestStatus;
import org.example.roomly.model.WorkspaceStaffType;

import java.util.List;
import java.util.Optional;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.sql.Timestamp;

@Repository
public class RequestRepository {
    private final JdbcTemplate jdbcTemplate;

    public RequestRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // 1. Create a request
    public void save(Request request) {
        String sql = "INSERT INTO Request (Id, RequestType, RequestDate, ResponseDate, Details, Status, RequestResponse) VALUES (?, ?, ?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql,
                request.getRequestId(),
                request.getRequestType(),
                new Timestamp(request.getRequestDate().getTime()),
                request.getResponseDate() != null ? new Timestamp(request.getResponseDate().getTime()) : null,
                request.getDetails(),
                request.getStatus().toString(),
                request.getRequestResponse());
    }

    // 2. Read a request by ID
    public Optional<Request> findById(String requestId) {
        String sql = "SELECT * FROM Request WHERE Id = ?";
        return jdbcTemplate.query(sql, new Object[]{requestId}, (rs) -> {
            if (rs.next()) {
                return Optional.of(new Request(
                        rs.getString("Id"),
                        rs.getString("RequestType"),
                        rs.getTimestamp("RequestDate"),
                        rs.getTimestamp("ResponseDate"),
                        rs.getString("Details"),
                        RequestStatus.valueOf(rs.getString("Status")),
                        rs.getString("RequestResponse")
                ));
            }
            return Optional.empty();
        });
    }

    // 3. Update a request
    public void update(Request request) {
        String sql = "UPDATE Request SET RequestType = ?, RequestDate = ?, ResponseDate = ?, Details = ?, Status = ?, RequestResponse = ? WHERE Id = ?";
        jdbcTemplate.update(sql,
                request.getRequestType(),
                new Timestamp(request.getRequestDate().getTime()),
                request.getResponseDate() != null ? new Timestamp(request.getResponseDate().getTime()) : null,
                request.getDetails(),
                request.getStatus().toString(),
                request.getRequestResponse(),
                request.getRequestId());
    }

    // 4. Delete a request
    public void deleteById(String requestId) {
        String sql = "DELETE FROM Request WHERE Id = ?";
        jdbcTemplate.update(sql, requestId);
    }

    // 5. Get all requests
    public List<Request> findAll() {
        String sql = "SELECT * FROM Request";
        return jdbcTemplate.query(sql, (rs, rowNum) -> new Request(
                rs.getString("Id"),
                rs.getString("RequestType"),
                rs.getTimestamp("RequestDate"),
                rs.getTimestamp("ResponseDate"),
                rs.getString("Details"),
                RequestStatus.valueOf(rs.getString("Status")),
                rs.getString("RequestResponse")
        ));
    }
}
