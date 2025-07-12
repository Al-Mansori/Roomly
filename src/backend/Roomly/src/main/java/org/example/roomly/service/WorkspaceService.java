package org.example.roomly.service;

import org.example.roomly.model.Location;
import org.example.roomly.model.Review;
import org.example.roomly.model.Workspace;
import org.example.roomly.repository.WorkspaceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.DecimalFormat;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
public class WorkspaceService {

    private final WorkspaceRepository workspaceRepository;
    private final ReviewService reviewService;
    private final LocationService locationService;

    @Autowired
    public WorkspaceService(WorkspaceRepository workspaceRepository, ReviewService reviewService, LocationService locationService) {
        this.workspaceRepository = workspaceRepository;
        this.reviewService = reviewService;
        this.locationService = locationService;
    }

    public Workspace saveWorkspace(Workspace workspace, String locationId) {
        workspace.setId(UUID.randomUUID().toString());
        workspaceRepository.save(workspace, locationId);
        return workspace;
    }

    public void deleteWorkspace(String id) {
        workspaceRepository.delete(id);
    }

    public void updateWorkspace(Workspace workspace) {
        workspaceRepository.update(workspace);
    }

//    public Workspace getWorkspaceById(String id) {
//        return workspaceRepository.getById(id);
//    }

    public Workspace getWorkspaceById(String id) {
        Workspace workspace = workspaceRepository.getById(id);
        if (workspace != null && workspace.getLocation() != null && workspace.getLocation().getId() != null) {
            Location location = locationService.getLocationById(workspace.getLocation().getId());
            workspace.setLocation(location);
        }
        return workspace;
    }

    public List<Workspace> getAllWorkspaces() {
        return workspaceRepository.findAll();
    }

    public void addToFavourites(String workspaceId, String userId, String roomId) {
        workspaceRepository.addToFavourites(workspaceId, userId, roomId);
    }

    public List<Workspace> getWorkspacesByLocationId(String locationId) {
        return workspaceRepository.findByLocationId(locationId);
    }

    public List<Workspace> getFavourites(String userId) {
        return workspaceRepository.getFavourites(userId);
    }

    // Add a new method to get favorite workspace-room combinations
    public List<Map<String, String>> getFavoriteWorkspaceRooms(String userId) {
        return workspaceRepository.getFavoriteWorkspaceRooms(userId);
    }

    // Add method to add a favorite room
    public boolean addFavoriteWorkspaceRoom(String userId, String roomId) {
        return workspaceRepository.addFavoriteWorkspaceRoom(userId, roomId);
    }

    // Add a method to delete a favorite workspace-room combination
    public boolean deleteFavoriteWorkspaceRoom(String userId, String roomId) {
        return workspaceRepository.deleteFavoriteWorkspaceRoom(userId, roomId);
    }

    // Add method to add a favorite workspace
    public boolean addFavoriteWorkspace(String userId, String workspaceId) {
        return workspaceRepository.addFavoriteWorkspace(userId, workspaceId);
    }

    // Add a method to delete a favorite workspace
    public boolean deleteFavoriteWorkspace(String userId, String workspaceId) {
        return workspaceRepository.deleteFavoriteWorkspace(userId, workspaceId);
    }

    public void updateWorkspaceAverageRating(String workspaceId) {
        // Get all reviews for this workspace
        List<Review> reviews = reviewService.getWorkspaceReviews(workspaceId);

        if (reviews.isEmpty()) {
            return; // No reviews to calculate
        }

        // Calculate average rating and format to one decimal place
        double sum = reviews.stream()
                .mapToDouble(Review::getRating)
                .sum();
        double averageRating = sum / reviews.size();

        // Format to one decimal place
        averageRating = Math.round(averageRating * 10) / 10.0;

        // Update the workspace
        Workspace workspace = getWorkspaceById(workspaceId);
        workspace.setAvgRating(averageRating);
        updateWorkspace(workspace);
    }

    // get workspaces by room id
    public Workspace getWorkspacesByRoomId(String roomId) {
        return workspaceRepository.getByRoomId(roomId);
    }

    public List<Workspace> searchWorkspaces(String query) {
        return workspaceRepository.findByNameContaining(query);
    }
    public List<Workspace> getOwnerWorkspaces(String staffId) {
        return workspaceRepository.findByStaffId(staffId);
    }

    public void removeSupervisorFromWorkspace(String staffId, String workspaceId) {
        workspaceRepository.deleteSupervision(staffId, workspaceId);
    }

    public void addSupervisorToWorkspace(String staffId, String workspaceId) {
        workspaceRepository.addSupervision(staffId, workspaceId);
    }

    public List<String> getSupervisorsForWorkspace(String workspaceId) {
        return workspaceRepository.findSupervisorIdsByWorkspace(workspaceId);
    }

    public List<String> getWorkspacesForSupervisor(String staffId) {
        return workspaceRepository.findWorkspaceIdsBySupervisor(staffId);
    }

}