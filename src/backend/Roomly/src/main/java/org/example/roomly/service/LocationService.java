package org.example.roomly.service;

import org.example.roomly.model.Location;
import org.example.roomly.repository.LocationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class LocationService {

    private final LocationRepository locationRepository;

    @Autowired
    public LocationService(LocationRepository locationRepository) {
        this.locationRepository = locationRepository;
    }

    public Location saveLocation(Location location) {
        return locationRepository.save(location);
    }

    public Location updateLocation(Location location) {
        return locationRepository.update(location);
    }

    public Location getLocationById(String id) {
        return locationRepository.findById(id);
    }

    public List<Location> getAllLocations() {
        return locationRepository.findAll();
    }

    public void deleteLocation(String id) {
        locationRepository.deleteById(id);
    }
}