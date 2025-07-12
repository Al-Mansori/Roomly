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
    boolean existsById(String id);
    void blockUser(String staffId,String userId);
    void unblockUser(String staffId, String userId);
    // get all blocked users for a specific staff member
    List<String> getBlockedUsers(String staffId);

    List<String> findStaffIdsByWorkspaceId(String workspaceId);

    List<String> findWorkspaceIdsByStaffId(String staffId);
}
