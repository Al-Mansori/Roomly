package org.example.roomly.model;

import jakarta.persistence.*;

@Entity
@Table(name = "WorkspaceStaff") // Maps to the "WorkspaceStaff" table
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

    public WorkspaceStaff(Workspace workspace, WorkspaceStaffType type) {
        // Call the super class constructor
        super();
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
