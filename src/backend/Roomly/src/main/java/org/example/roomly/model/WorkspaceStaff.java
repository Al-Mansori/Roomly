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

    private WorkspaceStaffType type;

    public Workspace getAssignedWorkspace() {
        return workspace;
    }
    public void setAssignedWorkspace(Workspace workspace) {
        this.workspace = workspace;
    }
}
