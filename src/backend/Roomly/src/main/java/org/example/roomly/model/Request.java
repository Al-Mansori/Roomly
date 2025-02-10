package org.example.roomly.model;

import java.util.Date;

public class Request {
    private String Id;
    private String requestType;
    private Date requestDate;
    private Date responseDate;
    private String details;
    private String status;
    private String requestResponse;
    private User user;
    private WorkspaceStaff staff;

    public Request() {
    }

    public Request(String requestId, String requestType, Date requestDate, Date responseDate, String details, String status, String requestResponse, User user, WorkspaceStaff staff) {
        this.Id = requestId;
        this.requestType = requestType;
        this.requestDate = requestDate;
        this.responseDate = responseDate;
        this.details = details;
        this.status = status;
        this.requestResponse = requestResponse;
        this.user = user;
        this.staff = staff;
    }

    public String getRequestId() {
        return Id;
    }

    public void setRequestId(String requestId) {
        this.Id = requestId;
    }

    public String getRequestType() {
        return requestType;
    }

    public void setRequestType(String requestType) {
        this.requestType = requestType;
    }

    public Date getRequestDate() {
        return requestDate;
    }

    public void setRequestDate(Date requestDate) {
        this.requestDate = requestDate;
    }

    public Date getResponseDate() {
        return responseDate;
    }

    public void setResponseDate(Date responseDate) {
        this.responseDate = responseDate;
    }

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getRequestResponse() {
        return requestResponse;
    }

    public void setRequestResponse(String requestResponse) {
        this.requestResponse = requestResponse;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public WorkspaceStaff getStaff() {
        return staff;
    }

    public void setStaff(WorkspaceStaff staff) {
        this.staff = staff;
    }

    @Override
    public String toString() {
        return "Request{" +
                "requestId='" + Id + '\'' +
                ", requestType='" + requestType + '\'' +
                ", requestDate=" + requestDate +
                ", responseDate=" + responseDate +
                ", details='" + details + '\'' +
                ", status='" + status + '\'' +
                ", requestResponse='" + requestResponse + '\'' +
                ", user=" + user +
                ", staff=" + staff +
                '}';
    }
}