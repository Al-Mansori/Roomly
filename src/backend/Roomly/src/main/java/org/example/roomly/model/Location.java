package org.example.roomly.model;
import jakarta.persistence.*;

@Entity
@Table(name = "Location")
public class Location {
    @Id
    //@GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private Long id;

    @Column(name = "Address")
    private String address;

    @Column(name = "City")
    private String city;

    @Column(name = "Town")
    private String town;

    @Column(name = "Country")
    private String country;

    @Column(name = "Longitude")
    private double longitude;

    @Column(name = "Latitude")
    private double latitude;

    // Constructors
    public Location() {}

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