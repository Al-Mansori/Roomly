package org.example.roomly.service;

import org.example.roomly.model.Image;
import org.example.roomly.repository.ImageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

@Service
public class ImageService {

    private ImageRepository imageRepository;

    @Autowired
    public ImageService(ImageRepository imageRepository) {
        this.imageRepository = imageRepository;
    }


    public void addImage(String imageUrl, String staffId, String workspaceId, String roomId, String amenityId) throws IOException {
        imageRepository.addImage(imageUrl, staffId, workspaceId, roomId, amenityId);
    }

    // Delete an image by URL
    public void deleteImage(String imageUrl) throws IOException {
        // Delete image from database
        imageRepository.deleteImage(imageUrl);
    }


    // Get all workspace images
    public List<Image> getWorkspaceImages(String workspaceId) {
        return imageRepository.getWorkspaceImages(workspaceId);
    }

    // Get all room images
    public List<Image> getRoomImages(String roomId) {
        return imageRepository.getRoomImages(roomId);
    }

    // Get all amenity images
    public List<Image> getAmenityImages(String amenityId) {
        return imageRepository.getAmenityImages(amenityId);
    }
}
