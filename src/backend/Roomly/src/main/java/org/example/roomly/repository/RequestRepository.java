package org.example.roomly.repository;

import org.example.roomly.model.Request;
import java.util.List;

public interface RequestRepository {
    void save(Request request);
    Request findById(String id);
    List<Request> findAll();
    void update(Request request);
    void deleteById(String id);
    void saveUserRequesting(String userId, String requestId, String staffId);
    void deleteUserRequesting(String requestId);
    List<Request> findAllByUserId(String userId);
    List<Request> findAllByStaffId(String staffId);
}
