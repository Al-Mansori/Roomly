package org.example.roomly.controller;

import org.example.roomly.model.Request;
import org.example.roomly.model.RequestStatus;
import org.example.roomly.model.WorkspacePlan;
import org.example.roomly.service.ImageService;
import org.example.roomly.service.RequestService;
import org.example.roomly.service.WorkspacePlanService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("api/staff")
public class WorkspaceStaffController {

    @Autowired
    private ImageService imageService;

    @Autowired
    private RequestService requestService;

    @Autowired
    private WorkspacePlanService workspacePlanService;

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

    @PostMapping("/workspacePlan")
    public String saveWorkspacePlan(@RequestParam String workspaceId, @RequestBody WorkspacePlan workspacePlan) {
        workspacePlanService.save(workspacePlan, workspaceId);
        return "Workspace plan saved successfully.";
    }

    @DeleteMapping("/workspacePlan")
    public String deleteWorkspacePlan(@RequestParam String workspaceId) {
        workspacePlanService.delete(workspaceId);
        return "Workspace plan deleted successfully.";
    }

    @GetMapping("/workspacePlan")
    public WorkspacePlan findWorkspacePlanById(@RequestParam String workspaceId) {
        return workspacePlanService.findById(workspaceId);
    }

    @PutMapping("/workspacePlan")
    public String updateWorkspacePlan(@RequestBody WorkspacePlan workspacePlan, String workspaceId) {
        workspacePlanService.update(workspacePlan, workspaceId);
        return "Workspace plan updated successfully.";
    }

}
