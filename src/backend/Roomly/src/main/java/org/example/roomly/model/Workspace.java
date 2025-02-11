package org.example.roomly.model;
import java.util.Date;
import java.util.List;

public class Workspace {
    private String id;
    private String name;
    private String description;
    private String address;
    private Location location;
    private Date creationDate;
    private double avgRating;
    private String type;
    private List<Room> rooms;
    private List<Image> workspaceImages;
    //private Analytics workspaceAnalytics;
    private List<Review> reviews ;

    // Constructors
    public Workspace() {}

    public Workspace(String id, String name, String description, String address, Location location, Date creationDate, double avgRating, String type, List<Room> rooms, List<Image> workspaceImages, List<Review> reviews) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.address = address;
        this.location = location;
        this.creationDate = creationDate;
        this.avgRating = avgRating;
        this.type = type;
        this.rooms = rooms;
        this.workspaceImages = workspaceImages;
        this.reviews = reviews;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Location getLocation() {
        return location;
    }

    public void setLocation(Location location) {
        this.location = location;
    }

    public Date getCreationDate() {
        return creationDate;
    }

    public void setCreationDate(Date creationDate) {
        this.creationDate = creationDate;
    }

    public double getAvgRating() {
        return avgRating;
    }

    public void setAvgRating(double avgRating) {
        this.avgRating = avgRating;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public List<Room> getRooms() {
        return rooms;
    }

    public void setRooms(List<Room> rooms) {
        this.rooms = rooms;
    }

    public List<Image> getWorkspaceImages() {
        return workspaceImages;
    }

    public void setWorkspaceImages(List<Image> workspaceImages) {
        this.workspaceImages = workspaceImages;
    }

    public List<Review> getReviews() {
        return reviews;
    }

    public void setReviews(List<Review> reviews) {
        this.reviews = reviews;
    }
}
