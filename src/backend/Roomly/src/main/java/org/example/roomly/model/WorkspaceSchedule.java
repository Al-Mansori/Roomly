package org.example.roomly.model;

import org.springframework.stereotype.Component;

@Component
public class WorkspaceSchedule {
    private String day;
    private String startTime;
    private String endTime;
    private String workspaceId;

    // Constructors
    public WorkspaceSchedule() {}

    public WorkspaceSchedule(String day, String startTime, String endTime, String workspaceId) {
        this.day = day;
        this.startTime = startTime;
        this.endTime = endTime;
        this.workspaceId = workspaceId;
    }

    // Getters and Setters
    public String getDay() {
        return day;
    }

    public void setDay(String day) {
        this.day = day;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public String getWorkspaceId() {
        return workspaceId;
    }

    public void setWorkspaceId(String workspaceId) {
        this.workspaceId = workspaceId;
    }

    @Override
    public String toString() {
        return "WorkspaceSchedule{" +
                "day='" + day + '\'' +
                ", startTime='" + startTime + '\'' +
                ", endTime='" + endTime + '\'' +
                ", workspaceId='" + workspaceId + '\'' +
                '}';
    }
}