package org.example.roomly.repository;

import org.example.roomly.model.Reservation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ReservationRepo extends JpaRepository<Reservation,Integer> {
    @Query(value = "SELECT * from reservation where UserId=:theId",nativeQuery = true)
    List<Reservation> findByUserId(@Param("thiId")int UserId);

    @Query(value = "SELECT * from reservation where StartTime >=:Start and StartTime<=:End",nativeQuery = true)
    List<Reservation> findByDateRange(@Param("startDate")String Start,@Param("endDate")String End);
}
