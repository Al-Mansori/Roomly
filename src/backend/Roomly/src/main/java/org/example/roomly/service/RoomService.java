package org.example.roomly.service;

import org.example.roomly.model.Room;
import org.example.roomly.repository.RoomRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RoomService{

    private final RoomRepository roomRepository;

    @Autowired
    public RoomService(RoomRepository roomRepository) {
        this.roomRepository = roomRepository;
    }

    public void saveRoom(Room room, String workspaceId) {
        roomRepository.save(room, workspaceId);
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
}