package org.example.roomly.service;

import org.example.roomly.model.Location;
import org.example.roomly.repository.LocationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class LocationService {

    private final LocationRepository locationRepository;

    @Autowired
    public LocationService(LocationRepository locationRepository) {
        this.locationRepository = locationRepository;
    }

    public Location saveLocation(Location location) {
        location.setId(UUID.randomUUID().toString());
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

    public List<Location> getLocationsByCity(String city) {
        return locationRepository.findByCity(city);
    }

    public List<Location> getLocationsByTown(String town) {
        return locationRepository.findByTown(town);
    }

    public List<Location> getLocationsByCountry(String country) {
        return locationRepository.findByCountry(country);
    }

    // Add distinct listing service methods
    public List<String> getAllUniqueCities() {
        return locationRepository.findAllCities();
    }

    public List<String> getAllUniqueTowns() {
        return locationRepository.findAllTowns();
    }

    public List<String> getAllUniqueCountries() {
        return locationRepository.findAllCountries();
    }
}