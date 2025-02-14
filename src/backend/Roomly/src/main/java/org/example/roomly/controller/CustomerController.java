package org.example.roomly.controller;

import org.example.roomly.model.Amenity;
import org.example.roomly.model.Image;
import org.example.roomly.model.Room;
import org.example.roomly.model.Workspace;
import org.example.roomly.service.AmenityService;
import org.example.roomly.service.ImageService;
import org.example.roomly.service.RoomService;
import org.example.roomly.service.WorkspaceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("api/customer")
public class CustomerController {

    @Autowired
    private ImageService imageService;

    @Autowired
    private WorkspaceService workspaceService;

    @Autowired
    private RoomService roomService;

    @Autowired
    private AmenityService amenityService;

    @GetMapping("/images/workspace")
    public List<Image> getWorkspaceImages(@RequestParam String workspaceId) {
        return imageService.getWorkspaceImages(workspaceId);
    }

    @GetMapping("/images/room")
    public List<Image> getRoomImages(@RequestParam String roomId) {
        return imageService.getRoomImages(roomId);
    }

    @GetMapping("/images/amenity")
    public List<Image> getAmenityImages(@RequestParam String amenityId) {
        return imageService.getAmenityImages(amenityId);
    }

    @GetMapping("home")
    public List<Workspace> getHome(){
        List<Workspace> workspaces = workspaceService.getAllWorkspaces().subList(0,5);
        for (Workspace workspace: workspaces) {
            workspace.setWorkspaceImages(imageService.getWorkspaceImages(workspace.getId()));
        }
        return workspaces;
    }

    @GetMapping("workspace/details")
    public Workspace getWorkspaceDetails(@RequestParam String workspaceId){
        Workspace workspace = workspaceService.getWorkspaceById(workspaceId);
        workspace.setWorkspaceImages(imageService.getWorkspaceImages(workspaceId));
        List<Room> rooms = roomService.getRoomsByWorkspaceId(workspaceId);
        for (Room room: rooms) {
            room.setRoomImages(imageService.getRoomImages(room.getId()));
        }
        workspace.setRooms(rooms);
        return workspace;
    }

    @GetMapping("room/details")
    public Room getRoomDetails(@RequestParam String roomId){
        Room room = roomService.getRoomById(roomId);
        room.setRoomImages(imageService.getRoomImages(roomId));
        List<Amenity> amenities = amenityService.getAmenitiesByRoomId(roomId);
        for (Amenity amenity: amenities) {
            amenity.setAmenityImages(imageService.getAmenityImages(amenity.getId()));
        }
        room.setAmenities(amenities);
        return room;
    }
}
