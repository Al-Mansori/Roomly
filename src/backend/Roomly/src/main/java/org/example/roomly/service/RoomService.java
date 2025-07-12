package org.example.roomly.service;

import org.example.roomly.model.PaymentType;
import org.example.roomly.model.Room;
import org.example.roomly.model.RoomType;
import org.example.roomly.repository.RoomRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class RoomService{

    private final RoomRepository roomRepository;

    @Autowired
    public RoomService(RoomRepository roomRepository) {
        this.roomRepository = roomRepository;
    }

    public Room saveRoom(Room room, String workspaceId) {
        room.setId(UUID.randomUUID().toString());
        roomRepository.save(room, workspaceId);
        return room;
    }

    public void deleteRoom(String id) {
        roomRepository.delete(id);
    }

    public void updateRoom(Room room) {
        roomRepository.update(room);
    }

    public Room getRoomById(String id) {
        return roomRepository.getById(id);
    }

    public List<Room> getAllRooms() {
        return roomRepository.findAll();
    }

    public List<Room> getRoomsByWorkspaceId(String workspaceId) {
        return roomRepository.getWorkspaceRooms(workspaceId);
    }

    public String getWorkspaceIdByRoomId(String roomId) {
        return roomRepository.findWorkspaceIdByRoomId(roomId);
    }

    public List<Room> getRoomsByType(RoomType type) {
        return roomRepository.findByType(type);
    }

    public List<Room> filterRooms(PaymentType paymentMethod, String plan,
                                  RoomType roomType, Integer numberOfSeats,
                                  Double minPrice, Double maxPrice,
                                  List<String> amenityNames) {
        return roomRepository.filterRooms(
                paymentMethod,
                plan,
                roomType,
                numberOfSeats,
                minPrice,
                maxPrice,
                amenityNames
        );
    }

    public List<Room> searchRooms(String query) {
        return roomRepository.findByNameContaining(query);
    }

    public List<Room> filterRoomsWithQuery(
            PaymentType paymentMethod,
            String plan,
            RoomType roomType,
            Integer numberOfSeats,
            Double minPrice,
            Double maxPrice,
            List<String> amenityNames,
            String query) {
        return roomRepository.filterRoomsWithQuery(
                paymentMethod,
                plan,
                roomType,
                numberOfSeats,
                minPrice,
                maxPrice,
                amenityNames,
                query
        );
    }

    public List<Room> getTop5Rooms() {
        return roomRepository.findTop5Rooms();
    }

}