package org.example.roomly.repository;

import org.example.roomly.model.Offer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface OfferRepo extends JpaRepository<Offer,Integer> {
    @Query(value = "select * from Offer where status='Active' and offerId=:ID",nativeQuery = true)
    List<Offer> findActiveOffers(@Param("ID")int ID);
    @Query(value="UPDATE Offer SET status='Expier' where offerId=:ID",nativeQuery = true)
    Offer expierOffer(@Param("ID")int ID);

    //applyOfferToBooking postponed
}
