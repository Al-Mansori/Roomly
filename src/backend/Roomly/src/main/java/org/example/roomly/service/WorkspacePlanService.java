package org.example.roomly.service;

import org.example.roomly.model.WorkspacePlan;
import org.example.roomly.repository.WorkspacePlanRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class WorkspacePlanService {

    private final WorkspacePlanRepository workspacePlanRepository;

    @Autowired
    public WorkspacePlanService(WorkspacePlanRepository repository) {
        this.workspacePlanRepository = repository;
    }

    public void save(WorkspacePlan workspacePlan, String workspaceId) {
        workspacePlanRepository.save(workspacePlan, workspaceId);
    }

    public void delete(String workspaceId) {
        workspacePlanRepository.delete(workspaceId);
    }

    public List<WorkspacePlan> findAll() {
        return workspacePlanRepository.findAll();
    }

    public WorkspacePlan findById(String workspaceId) {
        return workspacePlanRepository.findById(workspaceId);
    }

    public void update(WorkspacePlan workspacePlan, String workspaceId) {
        workspacePlanRepository.update(workspacePlan, workspaceId);
    }
}

