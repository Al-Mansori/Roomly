package org.example.roomly.service;

import org.example.roomly.model.Preference;
import org.example.roomly.repository.PreferenceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class PreferenceService {
    @Autowired
    private PreferenceRepository preferenceRepository;

    public void savePreference(String budgetPreference, String workspaceTypePreference, String userId) {
        Preference preference = new Preference();
        preference.setBudgetPreference(budgetPreference);
        preference.setWorkspaceTypePreference(workspaceTypePreference);
        preference.setUserId(userId);
        preferenceRepository.save(preference);
    }

    public Preference getPreferenceByUserId(String userId) {
        return preferenceRepository.findById(userId);
    }

    public void updatePreference(String budgetPreference, String workspaceTypePreference, String userId) {
        Preference preference = new Preference();
        preference.setBudgetPreference(budgetPreference);
        preference.setWorkspaceTypePreference(workspaceTypePreference);
        preference.setUserId(userId);
        preferenceRepository.update(preference);
    }

    public void deletePreferenceByUserId(String userId) {
        preferenceRepository.deleteById(userId);
    }

}
