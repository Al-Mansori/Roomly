package org.example.roomly.repository;

import org.example.roomly.model.Image;
import java.util.List;

public interface ImageRepository {
    void addImage(String imageUrl, String staffId, String workspaceId, String roomId, String amenityId);
    void deleteImage(String imageUrl);
    List<Image> getWorkspaceImages(String workspaceId);
    List<Image> getRoomImages(String roomId);
    List<Image> getAmenityImages(String amenityId);
}