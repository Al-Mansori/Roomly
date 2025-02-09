package org.example.roomly.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.util.UUID;

@Entity
@Table(name = "Preference")
public class Preference {

    @Id
    @Column(name = "Id")
    private String preferenceId;

    @Column(name = "BudgetPreference")
    private String budgetPreference;

    @Column(name = "WorkspaceTypePreference")
    private String workspaceTypePreference;

    @Column(name = "UserId")
    private String userId;

    public Preference() {}

    public Preference(String preferenceId, String budgetPreference, String workspaceTypePreference, String userId) {
        this.preferenceId = preferenceId;
        this.budgetPreference = budgetPreference;
        this.workspaceTypePreference = workspaceTypePreference;
        this.userId = userId;
    }

    public String getPreferenceId() {
        return preferenceId;
    }

    public void setPreferenceId(String preferenceId) {
        this.preferenceId = preferenceId;
    }

    public String getBudgetPreference() {
        return budgetPreference;
    }

    public void setBudgetPreference(String budgetPreference) {
        this.budgetPreference = budgetPreference;
    }

    public String getWorkspaceTypePreference() {
        return workspaceTypePreference;
    }

    public void setWorkspaceTypePreference(String workspaceTypePreference) {
        this.workspaceTypePreference = workspaceTypePreference;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    @Override
    public String toString() {
        return "Preference{" +
                "preferenceId='" + preferenceId + '\'' +
                ", budgetPreference='" + budgetPreference + '\'' +
                ", workspaceTypePreference='" + workspaceTypePreference + '\'' +
                ", userId='" + userId + '\'' +
                '}';
    }
}