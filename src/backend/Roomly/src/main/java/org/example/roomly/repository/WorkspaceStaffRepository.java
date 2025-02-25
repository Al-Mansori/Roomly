package org.example.roomly.repository;

import org.example.roomly.model.WorkspaceStaff;
import java.util.List;

public interface WorkspaceStaffRepository {
    void save(WorkspaceStaff staff);
    WorkspaceStaff findById(String id);
    WorkspaceStaff findByEmail(String email);
    List<WorkspaceStaff> findAll();
    void update(WorkspaceStaff staff);
    void deleteById(String id);
    boolean existsByEmail(String email);
}
