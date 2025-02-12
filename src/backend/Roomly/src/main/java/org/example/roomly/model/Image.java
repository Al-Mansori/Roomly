package org.example.roomly.model;

import java.util.Date;

public class Image {
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

    @Override
    public String toString() {
        return "Image{" +
                "imageUrl='" + imageUrl + '\'' +
                '}';
    }
}
