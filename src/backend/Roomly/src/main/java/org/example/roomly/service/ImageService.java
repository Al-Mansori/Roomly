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
    private static final String BASE_DIRECTORY = "C:\\my computer\\collage work\\graduation project\\Roomly\\src\\backend\\Roomly\\src\\main\\resources\\images\\";

    private ImageRepository imageRepository;

    @Autowired
    public ImageService(ImageRepository imageRepository) {
        this.imageRepository = imageRepository;
    }

    // Save image to folder and database
    public void addImage(MultipartFile file, String staffId, String workspaceId, String roomId, String amenityId) throws IOException {
        // Generate folder path
        String folderPath = BASE_DIRECTORY ;

        // Create folders if they don't exist
        File folder = new File(folderPath);
        if (!folder.exists()) {
            folder.mkdirs();
        }

        // Generate unique file name
        String fileName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
        String imageUrl = folderPath + "/" + fileName;

        // Save file to folder
        Path path = Paths.get(imageUrl);
        Files.write(path, file.getBytes());

        // Save image to database
        imageRepository.addImage(imageUrl, staffId, workspaceId, roomId, amenityId);
    }

    // Delete an image by URL
    public void deleteImage(String imageUrl) throws IOException {
        // Delete file from folder
        Path path = Paths.get(imageUrl);
        Files.deleteIfExists(path);

        // Delete image from database
        imageRepository.deleteImage(imageUrl);
    }

//    public Image getImageWithFile(String imageUrl) throws IOException {
//        // Retrieve image URL from the database
//        Image image = imageRepository.getImageByUrl(imageUrl);
//        if (image == null) {
//            return null;
//        }
//
//        // Read the actual image file from disk
//        Path path = Paths.get(imageUrl);
//        byte[] imageData = Files.readAllBytes(path);
//
//        // Update the image model with file data
//        image.setImageData(imageData);
//        return image;
//    }

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