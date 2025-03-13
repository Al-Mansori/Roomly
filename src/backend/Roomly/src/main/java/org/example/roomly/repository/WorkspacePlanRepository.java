package org.example.roomly.repository;

import org.example.roomly.model.WorkspacePlan;
import java.util.List;

public interface WorkspacePlanRepository {
    void save(WorkspacePlan workspacePlan, String workspaceId);
    void delete(String workspaceId);
    List<WorkspacePlan> findAll();
    WorkspacePlan findById(String workspaceId);
    void update(WorkspacePlan workspacePlan, String workspaceId);
}
