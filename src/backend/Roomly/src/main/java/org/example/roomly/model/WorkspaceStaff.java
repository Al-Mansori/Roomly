package org.example.roomly.model;


public class WorkspaceStaff extends User {
    private WorkspaceStaffType type;

    public WorkspaceStaff() {
    }

    public WorkspaceStaff(String workspaceId, WorkspaceStaffType type) {
        // Call the super class constructor
        super();
        this.type = type;
    }

    public WorkspaceStaffType getType() {
        return type;
    }

    public void setType(WorkspaceStaffType type) {
        this.type = type;
    }



}
