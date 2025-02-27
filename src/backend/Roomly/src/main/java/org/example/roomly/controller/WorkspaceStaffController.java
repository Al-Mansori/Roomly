package org.example.roomly.controller;

import org.example.roomly.model.Request;
import org.example.roomly.model.RequestStatus;
import org.example.roomly.service.ImageService;
import org.example.roomly.service.RequestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@RestController
@RequestMapping("api/staff")
public class WorkspaceStaffController {

    @Autowired
    private ImageService imageService;

    @Autowired
    private RequestService requestService;

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

    @PutMapping("/request/reject")
    public String approvedRequest(@RequestParam String requestId) {
        Request request = requestService.findRequestById(requestId);
        request.setStatus(RequestStatus.APPROVED);
        requestService.updateRequest(request);
        return "Approved Successfully";
    }

    @PutMapping("/request/approve")
    public String rejectedRequest(@RequestParam String requestId) {
        Request request = requestService.findRequestById(requestId);
        request.setStatus(RequestStatus.REJECTED);
        requestService.updateRequest(request);
        return "Rejected Successfully";
    }
}
