package org.example.roomly.model;


import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;

import java.util.Date;

@Entity
@Table(name = "offers") // Updated table name to match MySQL
public class Offer {

    // Getters and Setters
    @Getter
    @Id
    @Column(name = "Id") // Updated column name
    private String id;

    @Column(name = "OfferTitle")
    private String offerTitle;

    @Column(name = "Description")
    private String description;

    @Column(name = "DiscountPercentage")
    private double discountPercentage; // Changed to BigDecimal for precision

    @Column(name = "ValidFrom")
    private Date validFrom; // Changed from Date to LocalDate

    @Column(name = "ValidTo")
    private Date validTo; // Changed from Date to LocalDate

    @Column(name = "Status")
    private String status;

    public void setId(String id) { this.id = id;}

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