package org.example.roomly.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.util.UUID;

@Entity
@Table(name = "preference")
public class Preference {
    @Id
    @Column(name = "PreferenceId")
    private String preferenceId;

    @Column(name = "BudgetPreference")
    private Double budgetPreference;

    @Column(name = "LanguagePreference")
    private String languagePreference;

    @Column(name = "WorkspaceTypePreference")
    private String workspaceTypePreference;

    public Preference() {}

    public Preference(String preferenceId, Double budgetPreference, String languagePreference, String workspaceTypePreference) {
        this.preferenceId = UUID.randomUUID().toString();
        this.budgetPreference = budgetPreference;
        this.languagePreference = languagePreference;
        this.workspaceTypePreference = workspaceTypePreference;
    }

    public String getPreferenceId() {
        return preferenceId;
    }

    public void setPreferenceId(String preferenceId) {
        this.preferenceId = preferenceId;
    }

    public Double getBudgetPreference() {
        return budgetPreference;
    }

    public void setBudgetPreference(Double budgetPreference) {
        this.budgetPreference = budgetPreference;
    }

    public String getLanguagePreference() {
        return languagePreference;
    }

    public void setLanguagePreference(String languagePreference) {
        this.languagePreference = languagePreference;
    }

    public String getWorkspaceTypePreference() {
        return workspaceTypePreference;
    }

    public void setWorkspaceTypePreference(String workspaceTypePreference) {
        this.workspaceTypePreference = workspaceTypePreference;
    }

    @Override
    public String toString() {
        return "Preference{" +
                "preferenceId='" + preferenceId + '\'' +
                ", budgetPreference=" + budgetPreference +
                ", languagePreference='" + languagePreference + '\'' +
                ", workspaceTypePreference='" + workspaceTypePreference + '\'' +
                '}';
    }
}
