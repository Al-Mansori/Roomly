package org.example.roomly.model;

import jakarta.persistence.*;

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
    @OneToOne
    @JoinColumn(name = "userId")
    private Customer user;

    public Preference() {}

    public Preference(String preferenceId, String budgetPreference, String workspaceTypePreference, Customer user) {
        this.preferenceId = preferenceId;
        this.budgetPreference = budgetPreference;
        this.workspaceTypePreference = workspaceTypePreference;
        this.user = user;
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

    public Customer getUser() {
        return user;
    }

    public void setUserId(Customer userId) {
        this.user = userId;
    }

    @Override
    public String toString() {
        return "Preference{" +
                "preferenceId='" + preferenceId + '\'' +
                ", budgetPreference='" + budgetPreference + '\'' +
                ", workspaceTypePreference='" + workspaceTypePreference + '\'' +
                ", userId='" + user + '\'' +
                '}';
    }
}