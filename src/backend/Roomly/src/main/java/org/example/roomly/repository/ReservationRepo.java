package org.example.roomly.repository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import org.example.roomly.model.Reservation;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;

@Repository
public class ReservationRepo {
    private EntityManager entityManager;
    public ReservationRepo(EntityManager e){
        this.entityManager = e;
    }

    public String save(Reservation re){
        entityManager.persist(re);
        return "saved to data base";
    }

    public Reservation findByUserId(int id){
        return entityManager.find(Reservation.class,id);
    }

    public List<Reservation> findByRangeDate(Date start, Date end){
        TypedQuery<Reservation> query = entityManager.createQuery("FROM reservation WHERE startTime >=:theStart and startTime<=:theEnd",Reservation.class);
        query.setParameter("theStart",start);
        query.setParameter("theEnd",end);
        return query.getResultList();
    }
    public String cancelBooking(int bookId){
        Reservation reservation = entityManager.find(Reservation.class,bookId);
        entityManager.remove(reservation);
        return "Booking canceled successfully";
    }
}
