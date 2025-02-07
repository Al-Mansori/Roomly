package org.example.roomly.model;
import jakarta.persistence.*;
import java.util.List;


@Entity
@Table(name = "amenity")
public class Amenity {
    @Id
    //@GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "name")
    private String name;

    @Column(name = "type")
    private String type;

    @Column(name = "description")
    private String description;

    @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "amenity_id")
    private List<Image> amenityImages;

    @Column(name = "available_count")
    private int availableCount;

    @Column(name = "total_count")
    private int totalCount;

    // Constructors
    public Amenity() {}

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
