package org.example.roomly.model;

import java.util.List;


public class Amenity {
    private Long id;
    private String name;
    private String type;
    private String description;
    private List<Image> amenityImages;
    private int availableCount;
    private int totalCount;

    public Amenity(Long id, String name, String type, String description, List<Image> amenityImages, int availableCount, int totalCount) {
        this.id = id;
        this.name = name;
        this.type = type;
        this.description = description;
        this.amenityImages = amenityImages;
        this.availableCount = availableCount;
        this.totalCount = totalCount;
    }

    // Getters and Setters

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
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

    public List<Image> getAmenityImages() {
        return amenityImages;
    }

    public void setAmenityImages(List<Image> amenityImages) {
        this.amenityImages = amenityImages;
    }

    public int getAvailableCount() {
        return availableCount;
    }

    public void setAvailableCount(int availableCount) {
        this.availableCount = availableCount;
    }

    public int getTotalCount() {
        return totalCount;
    }

    public void setTotalCount(int totalCount) {
        this.totalCount = totalCount;
    }
}
