package org.example.roomly.repository;

import org.example.roomly.model.Offer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface OfferRepo extends JpaRepository<Offer,String> {

    //applyOfferToBooking postponed
}
