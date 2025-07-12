package org.example.roomly.repository;

import org.example.roomly.model.PaymentType;
import org.example.roomly.model.Room;
import org.example.roomly.model.RoomType;

import java.util.List;

public interface RoomRepository {
    void save(Room room, String workspaceId);
    void delete(String id);
    void update(Room room);
    Room getById(String id);
    List<Room> findAll();
    List<Room> getWorkspaceRooms(String workspaceId);

    List<Room> findByType(RoomType type);

    String findWorkspaceIdByRoomId(String roomId);

    // RoomRepository.java (add to interface)
    List<Room> filterRooms(PaymentType paymentMethod, String plan,
                           RoomType roomType, Integer numberOfSeats,
                           Double minPrice, Double maxPrice,
                           List<String> amenityNames);

    List<Room> findByNameContaining(String query);

    List<Room> filterRoomsWithQuery(
            PaymentType paymentMethod,
            String plan,
            RoomType roomType,
            Integer numberOfSeats,
            Double minPrice,
            Double maxPrice,
            List<String> amenityNames,
            String query);

    List<Room> findTop5Rooms();
}
