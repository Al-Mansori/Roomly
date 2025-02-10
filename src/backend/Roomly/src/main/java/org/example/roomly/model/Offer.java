package org.example.roomly.model;


import java.util.Date;

public class Offer {

    // Getters and Setters

    private String Id;

    private String offerTitle;

    private String description;

    private double discountPercentage; // Changed to BigDecimal for precision

    private Date validFrom; // Changed from Date to LocalDate

    private Date validTo; // Changed from Date to LocalDate

    private String status;

    public void setId(String id) { this.Id = id;}
    public String getId(){return this.Id;}

    public String getOfferTitle() {
        return offerTitle;
    }

    public void setOfferTitle(String offerTitle) {
        this.offerTitle = offerTitle;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getDiscountPercentage() {
        return discountPercentage;
    }

    public void setDiscountPercentage(double discountPercentage) {
        this.discountPercentage = discountPercentage;
    }

    public Date getValidFrom() {
        return validFrom;
    }

    public void setValidFrom(Date validFrom) {
        this.validFrom = validFrom;
    }

    public Date getValidTo() {
        return validTo;
    }

    public void setValidTo(Date validTo) {
        this.validTo = validTo;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}