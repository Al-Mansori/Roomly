package org.example.roomly.model;

public class Location {
    private Long id;
    private String address;
    private String city;
    private String town;
    private String country;
    private double longitude;
    private double latitude;

    public Location(Long id, String address, String city, String town, String country, double longitude, double latitude) {
        this.id = id;
        this.address = address;
        this.city = city;
        this.town = town;
        this.country = country;
        this.longitude = longitude;
        this.latitude = latitude;
    }

    // Getters and Setters

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
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
}

