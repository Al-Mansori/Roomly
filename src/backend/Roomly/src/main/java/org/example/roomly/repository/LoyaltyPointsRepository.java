package org.example.roomly.repository;

import org.example.roomly.model.LoyaltyPoints;
import java.util.List;
import java.util.Optional;

public interface LoyaltyPointsRepository {
    void save(LoyaltyPoints loyaltyPoints);
    LoyaltyPoints findById(String userId);
    void update(LoyaltyPoints loyaltyPoints);
    void deleteById(String userId);
    List<LoyaltyPoints> findAll();
}