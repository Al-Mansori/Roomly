package org.example.roomly.model;

import org.springframework.stereotype.Component;

@Component
public class Preference {
    private String budgetPreference;
    private String workspaceTypePreference;
    private String userId;

    public Preference() {}

    public Preference(String budgetPreference, String workspaceTypePreference, String userId) {
        this.budgetPreference = budgetPreference;
        this.workspaceTypePreference = workspaceTypePreference;
        this.userId = userId;
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
                ", budgetPreference='" + budgetPreference + '\'' +
                ", workspaceTypePreference='" + workspaceTypePreference + '\'' +
                ", userId='" + userId + '\'' +
                '}';
    }
}