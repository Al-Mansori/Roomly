package org.example.roomly.service;

import org.example.roomly.model.Workspace;
import org.example.roomly.repository.WorkspaceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class WorkspaceService {

    private final WorkspaceRepository workspaceRepository;

    @Autowired
    public WorkspaceService(WorkspaceRepository workspaceRepository) {
        this.workspaceRepository = workspaceRepository;
    }

    public void saveWorkspace(Workspace workspace, String locationId) {
        workspaceRepository.save(workspace, locationId);
    }

    public void deleteWorkspace(String id) {
        workspaceRepository.delete(id);
    }

    public void updateWorkspace(Workspace workspace) {
        workspaceRepository.update(workspace);
    }

    public Workspace getWorkspaceById(String id) {
        return workspaceRepository.getById(id);
    }

    public List<Workspace> getAllWorkspaces() {
        return workspaceRepository.findAll();
    }
}