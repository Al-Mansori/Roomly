package org.example.roomly.repository;

import org.example.roomly.model.RoomAvailability;
import java.time.LocalDate;
import java.util.List;

public interface RoomAvailabilityRepository {
    void save(RoomAvailability availability);
    void delete(String roomId, LocalDate date, int hour);
    void update(RoomAvailability availability);
    RoomAvailability getByKey(String roomId, LocalDate date, int hour);
    List<RoomAvailability> findByRoomId(String roomId);
    List<RoomAvailability> findByDateRange(String roomId, LocalDate startDate, LocalDate endDate);
    public List<RoomAvailability> findByDate(String roomId, LocalDate date);
}