package org.example.roomly.repository;

import org.example.roomly.model.Location;
import java.util.List;

public interface LocationRepository {
    Location save(Location location);
    Location update(Location location);
    Location findById(String id);
    List<Location> findAll();
    void deleteById(String id);
}