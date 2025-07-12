package org.example.roomly.repository;

import org.example.roomly.model.WorkspaceSchedule;
import java.util.List;

public interface WorkspaceScheduleRepository {
    void save(WorkspaceSchedule schedule);
    void delete(String workspaceId, String day);
    void update(WorkspaceSchedule schedule);
    WorkspaceSchedule getByWorkspaceIdAndDay(String workspaceId, String day);
    List<WorkspaceSchedule> getByWorkspaceId(String workspaceId);
    List<WorkspaceSchedule> getAll();
}