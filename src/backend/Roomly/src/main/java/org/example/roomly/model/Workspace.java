package org.example.roomly.model;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import org.springframework.data.annotation.Id;

import java.util.Date;
import java.util.List;

@Entity
@Table(name = "workspace")
public class Workspace {

    @jakarta.persistence.Id
    @Id
    @Column(name = "WorkspaceId")
    private String workspaceId;

    @Column(name = "Name")
    private String name;

    @Column(name = "Description")
    private String description;

    @Column(name = "Location")
    private String location;

    @Column(name = "CreationDate")
    private Date creationDate;

    @Column(name = "AvgRating")
    private double avgRating;

    @Column(name = "Type")
    private String type;


    // !! Have An Issue Here !!
//    private List<Room> rooms;
//    private List<Image> workspaceImages;
    //private Analytics workspaceAnalytics;
    //private List<Review> reviews ;



    // Getters and Setters

    public void setWorkspaceId(String workspaceId) {
        this.workspaceId = workspaceId;
    }

    public String getWorkspaceId() {
        return workspaceId;
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

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
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

    // !! Have An Issue Here !!
//    public List<Room> getRooms() {
//        return rooms;
//    }
//
//    public void setRooms(List<Room> rooms) {
//        this.rooms = rooms;
//    }
//
//    public List<Image> getWorkspaceImages() {
//        return workspaceImages;
//    }
//
//    public void setWorkspaceImages(List<Image> workspaceImages) {
//        this.workspaceImages = workspaceImages;
//    }
}
