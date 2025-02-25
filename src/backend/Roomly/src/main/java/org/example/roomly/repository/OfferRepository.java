package org.example.roomly.repository;

import org.example.roomly.model.Offer;
import java.util.List;

public interface OfferRepository {
    int save(Offer offer);
    Offer find(String id);
    List<Offer> findAll();
    int update(Offer offer);
    int delete(String id);
}