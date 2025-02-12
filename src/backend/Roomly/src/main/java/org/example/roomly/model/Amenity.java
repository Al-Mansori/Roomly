package org.example.roomly.model;

import java.util.List;

public class Amenity {
    private String id;
    private String name;
    private String type;
    private String description;
    private int totalCount;
    private int availableCount;
    private List<Image> amenityImages;

    // Constructors
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

    @Override
    public String toString() {
        return "Amenity{" +
                "id='" + id + '\'' +
                ", name='" + name + '\'' +
                ", type='" + type + '\'' +
                ", description='" + description + '\'' +
                ", totalCount=" + totalCount +
                ", availableCount=" + availableCount +
                ", amenityImages=" + amenityImages +
                '}';
    }
}
