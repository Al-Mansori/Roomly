package org.example.roomly.repository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import org.example.roomly.model.Offer;
import org.example.roomly.model.Reservation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public class OfferRepo {
    private EntityManager entityManager;
    @Autowired
    public OfferRepo(EntityManager e){
        entityManager = e;
    }
    @Transactional
    public String save(Offer offer){
        entityManager.persist(offer);
        return "Offer saved successfully";
    }
    public List<Offer> findActiveOffers(){
        TypedQuery<Offer> query = entityManager.createQuery("FROM Offer WHERE status='Active'",Offer.class);
        return query.getResultList();
    }
    public double applayOfferToBooking(int offerId, Reservation reservation){
        Offer offer = entityManager.find(Offer.class,offerId);
        double costAfterOffer = offer.getDiscountPercentage()*(reservation.getTotalCost()/100);
        reservation.setTotalCost(costAfterOffer);
        return costAfterOffer;
    }
    @Transactional
    public String expireOffer(int offerid){
        Offer offer = entityManager.find(Offer.class,offerid);
        offer.setStatus("Expired");
        entityManager.merge(offer);
        return "the offer had been expired";
    }
}
