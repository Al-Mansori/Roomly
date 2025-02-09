package org.example.roomly.repository;

import org.example.roomly.model.Offer;
import org.springframework.data.jpa.repository.JpaRepository;

public interface OfferRepo extends JpaRepository<Offer,Integer> {
}
