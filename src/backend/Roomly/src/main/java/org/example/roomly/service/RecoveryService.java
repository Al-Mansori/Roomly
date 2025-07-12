// RecoveryService.java
package org.example.roomly.service;

import org.example.roomly.model.Room;
import org.example.roomly.model.RoomStatus;
import org.example.roomly.repository.RecoveryRepository;
import org.example.roomly.repository.RoomRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RecoveryService {

    private final RecoveryRepository recoveryRepository;
    private final RoomRepository roomRepository;

    @Autowired
    public RecoveryService(RecoveryRepository recoveryRepository, RoomRepository roomRepository) {
        this.recoveryRepository = recoveryRepository;
        this.roomRepository = roomRepository;
    }

    public boolean isRoomInRecovery(String roomId) {
        return recoveryRepository.isRoomInRecovery(roomId);
    }

    public void putRoomInRecovery(String roomId, String reason) {
        System.out.println("[RecoveryService] Start putRoomInRecovery");
        System.out.println("[RecoveryService] Adding room to recovery: " + roomId);

        recoveryRepository.addRoomToRecovery(roomId, reason);
        System.out.println("[RecoveryService] Room added to recovery: " + roomId);

        // Update room status to Unavailable
        Room room = roomRepository.getById(roomId);
        System.out.println("[RecoveryService] Updating room status to Unavailable: " + roomId);
        System.out.println("[RecoveryService] Current room status: " + room.getStatus());
        room.setStatus(RoomStatus.UNAVAILABLE);
        System.out.println("[RecoveryService] New room status: " + room.getStatus());
        roomRepository.update(room);
        System.out.println("[RecoveryService] Room status updated to Unavailable: " + roomId);
        System.out.println("[RecoveryService] End putRoomInRecovery");
    }

    public void removeRoomFromRecovery(String roomId) {
        System.out.println("[RecoveryService] Start removeRoomFromRecovery");
        System.out.println("[RecoveryService] Removing room from recovery: " + roomId);
        recoveryRepository.removeRoomFromRecovery(roomId);
        System.out.println("[RecoveryService] Room removed from recovery: " + roomId);

        // Update room status to Available
        Room room = roomRepository.getById(roomId);
        System.out.println("[RecoveryService] Updating room status to Available: " + roomId);
        System.out.println("[RecoveryService] Current room status: " + room.getStatus());
        room.setStatus(RoomStatus.AVAILABLE);
        System.out.println("[RecoveryService] New room status: " + room.getStatus());
        roomRepository.update(room);
        System.out.println("[RecoveryService] Room status updated to Available: " + roomId);
        System.out.println("[RecoveryService] End removeRoomFromRecovery");
    }

    public List<String> getAllRecoveryRoomIds() {
        return recoveryRepository.getAllRecoveryRoomIds();
    }
}