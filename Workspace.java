package org.example.roomly.model;
import java.util.Date;
import java.util.List;
import jakarta.persistence.*;

@Entity
@Table(name = "workspace")
public class Workspace {
    @Id
    //@GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private String id;

    @Column(name = "name")
    private String name;

    @Column(name = "description")
    private String description;

    @ManyToOne(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "location_id")
    private Location location;

    @Column(name = "creation_date")
    private Date creationDate;

    @Column(name = "avg_rating")
    private double avgRating;

    @Column(name = "type")
    private String type;

    @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "workspace_id")
    private List<Room> rooms;

    @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "workspace_id")
    private List<Image> workspaceImages;
    //private Analytics workspaceAnalytics;
    //private List<Review> reviews ;

    // Constructors
    public Workspace() {}

    public Workspace(String id, String name, String description, Location location, Date creationDate, double avgRating, String type, List<Room> rooms, List<Image> workspaceImages) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.location = location;
        this.creationDate = creationDate;
        this.avgRating = avgRating;
        this.type = type;
        this.rooms = rooms;
        this.workspaceImages = workspaceImages;
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
}
