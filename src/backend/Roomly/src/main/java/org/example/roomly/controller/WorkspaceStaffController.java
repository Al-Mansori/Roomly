package org.example.roomly.controller;

import org.example.roomly.service.ImageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@RestController
@RequestMapping("api/staff")
public class WorkspaceStaffController {

    @Autowired
    private ImageService imageService;

    @PostMapping("/images/upload")
    public void uploadImage(@RequestParam("file") MultipartFile file,
                            @RequestParam String staffId,
                            @RequestParam String workspaceId,
                            @RequestParam(required = false) String roomId,
                            @RequestParam(required = false) String amenityId) throws IOException {
        imageService.addImage(file, staffId, workspaceId, roomId, amenityId);
    }

    @DeleteMapping("/images/delete")
    public void deleteImage(@RequestParam String imageUrl) throws IOException {
        imageService.deleteImage(imageUrl);
    }
}
