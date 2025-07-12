package org.example.roomly.service;

import org.example.roomly.model.WorkspaceSchedule;
import org.example.roomly.repository.WorkspaceScheduleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class WorkspaceScheduleService {

    private final WorkspaceScheduleRepository scheduleRepository;

    @Autowired
    public WorkspaceScheduleService(WorkspaceScheduleRepository scheduleRepository) {
        this.scheduleRepository = scheduleRepository;
    }

    public WorkspaceSchedule saveSchedule(WorkspaceSchedule schedule) {
        scheduleRepository.save(schedule);
        return schedule;
    }

    public void deleteSchedule(String workspaceId, String day) {
        scheduleRepository.delete(workspaceId, day);
    }

    public WorkspaceSchedule updateSchedule(WorkspaceSchedule schedule) {
        scheduleRepository.update(schedule);
        return schedule;
    }

    public WorkspaceSchedule getSchedule(String workspaceId, String day) {
        return scheduleRepository.getByWorkspaceIdAndDay(workspaceId, day);
    }

    public List<WorkspaceSchedule> getSchedulesForWorkspace(String workspaceId) {
        return scheduleRepository.getByWorkspaceId(workspaceId);
    }

    public List<WorkspaceSchedule> getAllSchedules() {
        return scheduleRepository.getAll();
    }
}