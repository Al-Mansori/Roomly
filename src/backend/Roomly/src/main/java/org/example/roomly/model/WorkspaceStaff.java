package org.example.roomly.model;


public class WorkspaceStaff extends User {
    private WorkspaceStaffType type;

    public WorkspaceStaff() {
    }

    public WorkspaceStaff(String userId, String firstName, String lastName, String email, String password, String phone, WorkspaceStaffType type) {
        super(userId, firstName, lastName, email, password, phone);
        this.type = type;
    }

    public WorkspaceStaffType getType() {
        return type;
    }

    public void setType(WorkspaceStaffType type) {
        this.type = type;
    }

    @Override
    public String toString() {
        return "WorkspaceStaff{" +
                "type=" + type +
                '}';
    }
}
