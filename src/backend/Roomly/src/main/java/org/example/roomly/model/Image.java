package org.example.roomly.model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Images") // Match the table name in SQL schema
public class Image {
    @Id
    @Column(name = "ImageUrl") // Match the column name in SQL schema
    private String imageUrl; // Change type to String to match SQL schema

    // Constructors
    public Image() {}

    public Image(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    // Getters and Setters

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
}
