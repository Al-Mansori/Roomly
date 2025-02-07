package org.example.roomly.repository;

import org.example.roomly.model.LoyaltyPoints;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LoyaltyPointsRepository extends JpaRepository<LoyaltyPoints, String> {
}
