package org.example.roomly.repository;

import org.example.roomly.model.review;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ReviewRepo extends JpaRepository<review,Integer> {
    @Query("FROM review where workspaceId=:workspace")
    List<review> findByWorkspaceId(@Param("workspace")int workspaceId);
    @Query(value = "SELECT AVG(r.rating) FROM review AS r where r.workspaceId=:workspace",nativeQuery = true)
    double calculateAverageRating(@Param("workspace")int workspaceId);
}
