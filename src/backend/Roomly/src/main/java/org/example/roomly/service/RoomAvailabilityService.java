package org.example.roomly.service;

import org.example.roomly.model.RoomAvailability;
import org.example.roomly.repository.RoomAvailabilityRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class RoomAvailabilityService {

    private final RoomAvailabilityRepository repository;

    @Autowired
    public RoomAvailabilityService(RoomAvailabilityRepository repository) {
        this.repository = repository;
    }

    public void createAvailability(RoomAvailability availability) {
        repository.save(availability);
    }

    public void removeAvailability(String roomId, LocalDate date, int hour) {
        repository.delete(roomId, date, hour);
    }

    public void updateAvailability(RoomAvailability availability) {
        repository.update(availability);
    }

    public RoomAvailability getAvailability(String roomId, LocalDate date, int hour) {
        return repository.getByKey(roomId, date, hour);
    }

    public List<RoomAvailability> getRoomAvailabilities(String roomId) {
        return repository.findByRoomId(roomId);
    }

    public List<RoomAvailability> getAvailabilitySchedule(String roomId, LocalDate startDate, LocalDate endDate) {
        return repository.findByDateRange(roomId, startDate, endDate);
    }

    public List<RoomAvailability> getRoomAvailabilitiesByDate(String roomId, LocalDate date){
        return repository.findByDate(roomId, date);
    }
}