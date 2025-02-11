package org.example.roomly.model;

import java.util.List;

public class Room {
    private String id;
    private String name;
    private String type;
    private String description;
    private int capacity;
    private double pricePerHour;
    private String status;
    private List<Amenity> amenities;
    private List<Image> roomImages;
    private List<Offer> offers;

    // Constructors
    public Room() {}

    public Room(String id, String name, String type, String description, int capacity, double pricePerHour, String status, List<Amenity> amenities, List<Image> roomImages, List<Offer> offers) {
        this.id = id;
        this.name = name;
        this.type = type;
        this.description = description;
        this.capacity = capacity;
        this.pricePerHour = pricePerHour;
        this.status = status;
        this.amenities = amenities;
        this.roomImages = roomImages;
        this.offers = offers;
    }

    // Getters and Setters

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public double getPricePerHour() {
        return pricePerHour;
    }

    public void setPricePerHour(double pricePerHour) {
        this.pricePerHour = pricePerHour;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public List<Amenity> getAmenities() {
        return amenities;
    }

    public void setAmenities(List<Amenity> amenities) {
        this.amenities = amenities;
    }

    public List<Image> getRoomImages() {
        return roomImages;
    }

    public void setRoomImages(List<Image> roomImages) {
        this.roomImages = roomImages;
    }

    public List<Offer> getOffers() {
        return offers;
    }

    public void setOffers(List<Offer> offers) {
        this.offers = offers;
    }
}