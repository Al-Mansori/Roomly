package org.example.roomly.repository;

import org.example.roomly.model.Room;
import java.util.List;

public interface RoomRepository {
    void save(Room room, String workspaceId);
    void delete(String id);
    void update(Room room);
    Room getById(String id);
    List<Room> findAll();
    List<Room> getWorkspaceRooms(String workspaceId);
}
