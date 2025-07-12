package org.example.roomly.service;

import org.example.roomly.model.WorkspaceStaff;
import org.example.roomly.repository.WorkspaceStaffRepository;
import org.hibernate.jdbc.Work;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class WorkspaceStaffService {
    private final WorkspaceStaffRepository workspaceStaffRepository;

    @Autowired
    public WorkspaceStaffService(WorkspaceStaffRepository workspaceStaffRepository) {
        this.workspaceStaffRepository = workspaceStaffRepository;
    }

    public List<String> getStaffIdsByWorkspaceId(String workspaceId) {
        return workspaceStaffRepository.findStaffIdsByWorkspaceId(workspaceId);
    }

    public List<String> getWorkspaceIdsByStaffId(String staffId) {
        return workspaceStaffRepository.findWorkspaceIdsByStaffId(staffId);
    }

    public WorkspaceStaff getWrokspaceStaff(String staffId){
        return workspaceStaffRepository.findById(staffId);
    }
    public WorkspaceStaff updateWorkspaceStaff(WorkspaceStaff staff){
        workspaceStaffRepository.update(staff);
        return workspaceStaffRepository.findById(staff.getId());
    }
}
