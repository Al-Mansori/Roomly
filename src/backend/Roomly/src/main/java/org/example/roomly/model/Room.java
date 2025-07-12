package org.example.roomly.model;

import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class Room {
    private String id;
    private String name;
    private RoomType type;
    private String description;
    private int capacity;
    private int availableCount;
    private double pricePerHour;
    private RoomStatus status;
    private List<Amenity> amenities;
    private List<Image> roomImages;
    private List<Offer> offers;

    // Constructors
    public Room() {}

    public Room(String id, String name, RoomType type, String description, int capacity, int availableCount, double pricePerHour, RoomStatus status, List<Amenity> amenities, List<Image> roomImages, List<Offer> offers) {
        this.id = id;
        this.name = name;
        this.type = type;
        this.description = description;
        this.capacity = capacity;
        this.availableCount = availableCount;
        this.pricePerHour = pricePerHour;
        this.status = status;
        this.amenities = amenities;
        this.roomImages = roomImages;
        this.offers = offers;
    }

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

    public RoomType getType() {
        return type;
    }

    public void setType(RoomType type) {
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

    public int getAvailableCount() {
        return availableCount;
    }

    public void setAvailableCount(int availableCount) {
        this.availableCount = availableCount;
    }

    public double getPricePerHour() {
        return pricePerHour;
    }

    public void setPricePerHour(double pricePerHour) {
        this.pricePerHour = pricePerHour;
    }

    public RoomStatus getStatus() {
        return status;
    }

    public void setStatus(RoomStatus status) {
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

    @Override
    public String toString() {
        return "Room{" +
                "id='" + id + '\'' +
                ", name='" + name + '\'' +
                ", type=" + type +
                ", description='" + description + '\'' +
                ", capacity=" + capacity +
                ", availableCount=" + availableCount +
                ", pricePerHour=" + pricePerHour +
                ", status=" + status +
                ", amenities=" + amenities +
                ", roomImages=" + roomImages +
                ", offers=" + offers +
                '}';
    }
}