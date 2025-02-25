package org.example.roomly.repository;

import org.example.roomly.model.Workspace;
import java.util.List;

public interface WorkspaceRepository {
    void save(Workspace workspace, String locationId);
    void delete(String id);
    void update(Workspace workspace);
    Workspace getById(String id);
    List<Workspace> findAll();
}
