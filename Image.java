package org.example.roomly.model;
import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "image")
public class Image {
    @Id
    //@GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "url")
    private String url;

    @Column(name = "upload_date")
    private Date uploadDate;

    @Column(name = "description")
    private String description;

    // Constructors
    public Image() {}

    public Image(Long id, String url, Date uploadDate, String description) {
        this.id = id;
        this.url = url;
        this.uploadDate = uploadDate;
        this.description = description;
    }

    // Getters and Setters

    public Long getId() {
        return id;
    }

    public void setId(Long id) { this.id = id; }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public Date getUploadDate() {
        return uploadDate;
    }

    public void setUploadDate(Date uploadDate) {
        this.uploadDate = uploadDate;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
