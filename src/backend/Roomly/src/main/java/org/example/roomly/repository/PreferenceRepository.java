package org.example.roomly.repository;

import org.example.roomly.model.Preference;
import java.util.List;
import java.util.Optional;

public interface PreferenceRepository {
    void save(Preference preference);
    Preference findById(String userId);
    List<Preference> findAll();
    void update(Preference preference);
    void deleteById(String userId);
}
