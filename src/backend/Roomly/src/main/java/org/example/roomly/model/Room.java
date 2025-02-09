package org.example.roomly.model;

import java.util.List;
import jakarta.persistence.*;

@Entity
@Table(name = "Room") // Match the table name in SQL schema
public class Room {
    @Id
    @Column(name = "Id") // Match the column name in SQL schema
    private String id;

    @Column(name = "Name")
    private String name;

    @Column(name = "Type") // Match the column name in SQL schema
    private String type;

    @Column(name = "Description") // Match the column name in SQL schema
    private String description;

    @Column(name = "Capacity") // Match the column name in SQL schema
    private int capacity;

    @Column(name = "PricePerHour") // Match the column name in SQL schema
    private double pricePerHour;

    @Column(name = "RoomStatus") // Match the column name in SQL schema
    private String status;

    @Column(name = "workspaceId") // Match the column name in SQL schema
    private String workspaceId; // Add workspaceId to match SQL schema

    @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "roomId") // Match the foreign key in SQL schema
    private List<Amenity> amenities;

    @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "roomId") // Match the foreign key in SQL schema
    private List<Image> roomImages;
    //private List<Offer> offers;

    // Constructors, Getters, and Setters
    public Room() {}

    public Room(String id, String name, String type, int capacity, double pricePerHour, String status, String description, List<Amenity> amenities, List<Image> roomImages) {
        this.id = id;
        this.name = name;
        this.type = type;
        this.capacity = capacity;
        this.pricePerHour = pricePerHour;
        this.status = status;
        this.description = description;
        this.amenities = amenities;
        this.roomImages = roomImages;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public List<Amenity> getAmenities() {
        return amenities;
    }

    public void setAmenities(List<Amenity> amenities) {
        amenities = amenities;
    }

    public List<Image> getRoomImages() {
        return roomImages;
    }

    public void setRoomImages(List<Image> roomImages) {
        this.roomImages = roomImages;
    }
}