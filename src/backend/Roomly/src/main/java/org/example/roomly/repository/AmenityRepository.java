package org.example.roomly.repository;

import org.example.roomly.model.Amenity;
import java.util.List;

public interface AmenityRepository {
    void save(Amenity amenity, String roomId);
    void delete(String id);
    void update(Amenity amenity);
    Amenity getById(String id);
    List<Amenity> findAll();
    List<Amenity> getRoomAmenities(String roomId);
}