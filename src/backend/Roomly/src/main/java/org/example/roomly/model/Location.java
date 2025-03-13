package org.example.roomly.model;

import org.springframework.stereotype.Component;

@Component
public class Location {
    private String id;
    private String city;
    private String town;
    private String country;
    private double longitude;
    private double latitude;

    // Constructors
    public Location() {}

    public Location(String id, String city, String town, String country, double longitude, double latitude) {
        this.id = id;
        this.city = city;
        this.town = town;
        this.country = country;
        this.longitude = longitude;
        this.latitude = latitude;
    }

    // Getters and Setters

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getTown() {
        return town;
    }

    public void setTown(String town) {
        this.town = town;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public double getLongitude() {
        return longitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    @Override
    public String toString() {
        return "Location{" +
                "id=" + id +
                ", city='" + city + '\'' +
                ", town='" + town + '\'' +
                ", country='" + country + '\'' +
                ", longitude=" + longitude +
                ", latitude=" + latitude +
                '}';
    }
}