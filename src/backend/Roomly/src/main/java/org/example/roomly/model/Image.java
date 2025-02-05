package org.example.roomly.model;

import java.util.Date;


public class Image {
    private Long id;
    private String url;
    private Date uploadDate;
    private String description ;

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
