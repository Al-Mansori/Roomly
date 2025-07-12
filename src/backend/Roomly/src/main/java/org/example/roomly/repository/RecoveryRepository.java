package org.example.roomly.repository;

import java.util.List;

public interface RecoveryRepository {
    boolean isRoomInRecovery(String roomId);
    void addRoomToRecovery(String roomId, String reason);
    void removeRoomFromRecovery(String roomId);
    List<String> getAllRecoveryRoomIds();
}