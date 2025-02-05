package org.example.roomly.model;


import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.sql.Date;

@Entity
@Table(name = "Offer")
public class Offer {
    @Id
    @Column(name = "OfferId")
    private String offerId;

    @Column(name="OfferTitle")
    private String offerTitle;

    @Column(name="DiscountPercentage")
    private double discountPercentage;

    @Column(name="ValidFrom")
    private Date validFrom;

    @Column(name="ValidTo")
    private Date validTo;

    @Column(name="Status")
    private String status;

    @Column(name="Description")
    private String description;

    @Column(name="MaxRedemptions")
    private int maxRedemptions;

    @Column(name="RoomId")
    private String roomId;

    @Column(name="StaffId")
    private String staffId;

    //constructors


    public Offer(){

    }

    public Offer(String offerId, String offerTitle,
                 double discountPercentage,
                 Date validFrom,
                 Date validTo,
                 String status, String description,
                 int maxRedemptions, String roomId, String staffId) {
        this.offerId = offerId;
        this.offerTitle = offerTitle;
        this.discountPercentage = discountPercentage;
        this.validFrom = validFrom;
        this.validTo = validTo;
        this.status = status;
        this.description = description;
        this.maxRedemptions = maxRedemptions;
        this.roomId = roomId;
        this.staffId = staffId;
    }

    // setters


    public void setOfferId(String offerId) {
        this.offerId = offerId;
    }

    public void setOfferTitle(String offerTitle) {
        this.offerTitle = offerTitle;
    }

    public void setDiscountPercentage(double discountPercentage) {
        this.discountPercentage = discountPercentage;
    }

    public void setValidFrom(Date validFrom) {
        this.validFrom = validFrom;
    }

    public void setValidTo(Date validTo) {
        this.validTo = validTo;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setMaxRedemptions(int maxRedemptions) {
        this.maxRedemptions = maxRedemptions;
    }

    public void setRoomId(String roomId) {
        this.roomId = roomId;
    }

    public void setStaffId(String staffId) {
        this.staffId = staffId;
    }

    // getters

    public String getOfferId() {
        return offerId;
    }

    public String getOfferTitle() {
        return offerTitle;
    }

    public double getDiscountPercentage() {
        return discountPercentage;
    }

    public Date getValidFrom() {
        return validFrom;
    }

    public Date getValidTo() {
        return validTo;
    }

    public String getStatus() {
        return status;
    }

    public String getDescription() {
        return description;
    }

    public int getMaxRedemptions() {
        return maxRedemptions;
    }

    public String getRoomId() {
        return roomId;
    }

    public String getStaffId() {
        return staffId;
    }
}
