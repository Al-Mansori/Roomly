package org.example.roomly.repository;

import org.example.roomly.model.review;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ReviewRepo extends JpaRepository<review,Integer> {
}
