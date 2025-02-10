package org.example.roomly.model;

import jakarta.persistence.*;

import java.util.Date;
import java.util.UUID;

@Entity
@Table(name = "Request") // Map to the "Request" table
public class Request {

    @Id
    @Column(name = "Id") // Map to the "Id" column in the SQL schema
    private String requestId;

    @Column(name = "RequestType") // Map to the "RequestType" column
    private String requestType;

    @Column(name = "RequestDate") // Map to the "RequestDate" column
    private Date requestDate;

    @Column(name = "ResponseDate") // Map to the "ResponseDate" column
    private Date responseDate;

    @Column(name = "Details") // Map to the "Details" column
    private String details;

    @Column(name = "Status") // Map to the "Status" column
    private String status;

    @Column(name = "RequestResponse") // Map to the "RequestResponse" column
    private String requestResponse;

    @ManyToOne
    @JoinColumn(name = "userId") // Foreign key to the "User" table
    private WorkspaceStaff user;

    @ManyToOne
    @JoinColumn(name = "StaffId") // Foreign key to the "WorkspaceStaff" table
    private WorkspaceStaff staff;

    public Request() {
    }

    public Request(String requestId, String requestType, Date requestDate, Date responseDate, String details, String status, String requestResponse, WorkspaceStaff user, WorkspaceStaff staff) {
        this.requestId = requestId;
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
        return requestId;
    }

    public void setRequestId(String requestId) {
        this.requestId = requestId;
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

    public void setUser(WorkspaceStaff user) {
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
                "requestId='" + requestId + '\'' +
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