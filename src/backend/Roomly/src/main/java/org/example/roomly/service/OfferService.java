package org.example.roomly.service;

import org.example.roomly.model.Offer;
import org.example.roomly.repository.OfferRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.UUID;

@Service
public class OfferService {

    private final OfferRepository offerRepository;

    @Autowired
    public OfferService(OfferRepository offerRepository) {
        this.offerRepository = offerRepository;
    }

    public int saveOffer(String offerTitle, String description, double discountPercentage,
                         Date validFrom, Date validTo, String staffId, String roomId) {

        System.out.println("[OfferService] Saving offer with title: " + offerTitle);
        Offer offer = new Offer();
        String offerId = UUID.randomUUID().toString(); // Generate a unique ID for the offer
        System.out.println("[OfferService] Generated Offer ID: " + offerId);
        offer.setId(offerId);
        offer.setOfferTitle(offerTitle);
        offer.setDescription(description);
        offer.setDiscountPercentage(discountPercentage);
        offer.setValidFrom(validFrom);
        offer.setValidTo(validTo);
        offer.setStatus("Active"); // Set status to Active

        System.out.println("[OfferService] Offer details: " + offer);
        System.out.println("[OfferService] Saving offer with staffId: " + staffId + " and roomId: " + roomId);

        return offerRepository.save(offer, staffId, roomId);
    }

    public Offer getOfferById(String id) {
        return offerRepository.find(id);
    }

    public List<Offer> getAllOffers() {
        return offerRepository.findAll();
    }

    public int updateOffer(Offer offer) {
        return offerRepository.update(offer);
    }

    public int deleteOffer(String id) {
        return offerRepository.delete(id);
    }

    public List<Offer> getOffersByRoomId(String roomId) {
        return offerRepository.findOffersByRoomId(roomId);
    }

    public List<Offer> getOffersByStaffId(String staffId) {
        return offerRepository.findOffersByStaffId(staffId);
    }
}
