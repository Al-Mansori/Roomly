package org.example.roomly.model;


import java.util.List;

public class SearchCriteria {
    private String location;
    private double minPrice;
    private double maxPrice;
    private List<String> requiredAmenities;
    private String name;

    // Constructors

    public SearchCriteria(){

    }

    public SearchCriteria(String location, double minPrice, double maxPrice, List<String> requiredAmenities, String name) {
        this.location = location;
        this.minPrice = minPrice;
        this.maxPrice = maxPrice;
        this.requiredAmenities = requiredAmenities;
        this.name = name;
    }


    //setters

    public void setLocation(String location) {
        this.location = location;
    }

    public void setMinPrice(double minPrice) {
        this.minPrice = minPrice;
    }

    public void setMaxPrice(double maxPrice) {
        this.maxPrice = maxPrice;
    }

    public void setRequiredAmenities(List<String> requiredAmenities) {
        this.requiredAmenities = requiredAmenities;
    }

    public void setName(String name) {
        this.name = name;
    }

    // getters

    public String getLocation() {
        return location;
    }

    public double getMinPrice() {
        return minPrice;
    }

    public double getMaxPrice() {
        return maxPrice;
    }

    public List<String> getRequiredAmenities() {
        return requiredAmenities;
    }

    public String getName() {
        return name;
    }

    @Override
    public String toString() {
        return "SearchCriteria{" +
                "location='" + location + '\'' +
                ", minPrice=" + minPrice +
                ", maxPrice=" + maxPrice +
                ", requiredAmenities=" + requiredAmenities +
                ", name='" + name + '\'' +
                '}';
    }
}
