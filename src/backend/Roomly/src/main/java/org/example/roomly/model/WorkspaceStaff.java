package org.example.roomly.model;

import jakarta.persistence.*;

@Entity
@Table(name = "workspacestaff") // Maps to the "WorkspaceStaff" table
@AttributeOverride( // Override the "id" column name to "StaffId"
        name = "userId",
        column = @Column(name = "StaffId")
)
public class WorkspaceStaff extends User {

    @ManyToOne
    @JoinColumn(name = "WorkspaceId")
    private Workspace workspace;

    @Column(name = "Type")
    private WorkspaceStaffType type;

    public WorkspaceStaff() {
    }

    public WorkspaceStaff(String userId, String firstName, String lastName, String email, String password, String phone,Workspace workspace, WorkspaceStaffType type) {
        // Call the super class constructor
        super(userId, firstName, lastName, email, password, phone);
        this.workspace = workspace;
        this.type = type;
    }

    public Workspace getWorkspace() {
        return workspace;
    }

    public void setWorkspace(Workspace workspace) {
        this.workspace = workspace;
    }

    public WorkspaceStaffType getType() {
        return type;
    }

    public void setType(WorkspaceStaffType type) {
        this.type = type;
    }



}
