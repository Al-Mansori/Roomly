package org.example.roomly.model;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "Amenities") // Match the table name in SQL schema
public class Amenity {
    @Id
    @Column(name = "Id") // Match the column name in SQL schema
    private String id; // Change type to String to match SQL schema

    @Column(name = "AmenityName") // Match the column name in SQL schema
    private String name;

    @Column(name = "Type") // Match the column name in SQL schema
    private String type;

    @Column(name = "Description") // Match the column name in SQL schema
    private String description;

    @Column(name = "TotalCount") // Match the column name in SQL schema
    private int totalCount;

    @Column(name = "AvailableCount") // Match the column name in SQL schema
    private int availableCount;

    @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "AmenityId") // Match the foreign key in SQL schema
    private List<Image> amenityImages;

    // Constructors, Getters, and Setters
    public Amenity() {}

    public Amenity(String id, String name, String type, String description, int totalCount, int availableCount, List<Image> amenityImages) {
        this.id = id;
        this.name = name;
        this.type = type;
        this.description = description;
        this.totalCount = totalCount;
        this.availableCount = availableCount;
        this.amenityImages = amenityImages;
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

    public int getTotalCount() {
        return totalCount;
    }

    public void setTotalCount(int totalCount) {
        this.totalCount = totalCount;
    }

    public int getAvailableCount() {
        return availableCount;
    }

    public void setAvailableCount(int availableCount) {
        this.availableCount = availableCount;
    }

    public List<Image> getAmenityImages() {
        return amenityImages;
    }

    public void setAmenityImages(List<Image> amenityImages) {
        this.amenityImages = amenityImages;
    }
}
