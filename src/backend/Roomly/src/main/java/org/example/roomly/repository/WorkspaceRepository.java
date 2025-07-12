package org.example.roomly.repository;

import org.example.roomly.model.Workspace;
import java.util.List;
import java.util.Map;

public interface WorkspaceRepository {
    void save(Workspace workspace, String locationId);
    void delete(String id);
    void update(Workspace workspace);
    Workspace getById(String id);
    List<Workspace> findAll();
    void addToFavourites(String workspaceId, String userId, String roomId);

    List<Workspace> getFavourites(String userId);
    List<Map<String, String>> getFavoriteWorkspaceRooms(String userId);
    // Add favorite room method
    boolean addFavoriteWorkspaceRoom(String userId, String roomId);
    boolean deleteFavoriteWorkspaceRoom(String userId, String roomId);
    // add favorite workspace
    boolean addFavoriteWorkspace(String userId, String workspaceId);
    boolean deleteFavoriteWorkspace(String userId, String workspaceId);
    List<Workspace> findByLocationId(String locationId);
    // get workspace by room id
    Workspace getByRoomId(String roomId);

    List<Workspace> findByNameContaining(String query);
    public List<Workspace> findByStaffId(String staffId);

    public void addSupervision(String staffId, String workspaceId);
    public void deleteSupervision(String staffId, String workspaceId);
    public List<String> findSupervisorIdsByWorkspace(String workspaceId);
    public List<String> findWorkspaceIdsBySupervisor(String staffId);

}
