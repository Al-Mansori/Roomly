package org.example.roomly.service;

import org.example.roomly.model.Amenity;
import org.example.roomly.repository.AmenityRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class AmenityService {

    private final AmenityRepository amenityRepository;

    @Autowired
    public AmenityService(AmenityRepository amenityRepository) {
        this.amenityRepository = amenityRepository;
    }

    public Amenity saveAmenity(Amenity amenity, String roomId) {
        amenity.setId(UUID.randomUUID().toString());
        amenityRepository.save(amenity, roomId);
        return amenity;
    }

    public void deleteAmenity(String id) {
        amenityRepository.delete(id);
    }

    public void updateAmenity(Amenity amenity) {
        amenityRepository.update(amenity);
    }

    public Amenity getAmenityById(String id) {
        return amenityRepository.getById(id);
    }

    public List<Amenity> getAllAmenities() {
        return amenityRepository.findAll();
    }

    public List<Amenity> getAmenitiesByRoomId(String roomId) {
        return amenityRepository.getRoomAmenities(roomId);
    }

    public String getRoomIdByAmenityId(String amenityId) {
        return amenityRepository.findRoomIdByAmenityId(amenityId);
    }

}