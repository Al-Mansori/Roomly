package org.example.roomly.service;

import org.example.roomly.model.WorkspacePlan;
import org.example.roomly.repository.WorkspacePlanRepository;
import org.example.roomly.repository.WorkspaceStaffRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class WorkspacePlanService {

    private final WorkspacePlanRepository workspacePlanRepository;
    private final WorkspaceStaffRepository workspaceStaffRepository;

    @Autowired
    public WorkspacePlanService(WorkspacePlanRepository repository,
                                WorkspaceStaffRepository workspaceStaffRepository) {
        this.workspacePlanRepository = repository;
        this.workspaceStaffRepository = workspaceStaffRepository;
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

    public WorkspacePlan findByWorkspaceId(String workspaceId) {
        return workspacePlanRepository.findById(workspaceId);
    }

    public void update(WorkspacePlan workspacePlan, String workspaceId) {
        workspacePlanRepository.update(workspacePlan, workspaceId);
    }

    public Map<String,WorkspacePlan> getPlansByStaffId(String staffId) {
        // Get workspace IDs supervised by this staff member
        List<String> workspaceIds = workspaceStaffRepository.findWorkspaceIdsByStaffId(staffId);

        Map<String,WorkspacePlan> plans = new HashMap<>();
        for (String workspaceId : workspaceIds) {
            WorkspacePlan plan = findByWorkspaceId(workspaceId);
            if (plan != null) {
                plans.put(workspaceId,plan);
            }
        }
        return plans;
    }
}