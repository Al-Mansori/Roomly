package org.example.roomly.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.util.Date;
import java.util.UUID;

@Entity
@Table(name = "request")
public class Request {

    @Id
    @Column(name = "RequestId")
    private String requestID;

    @Column(name = "UserId")
    private String userID;

    @Column(name = "StaffId")
    private String staffId;

    @Column(name = "Details")
    private String details;

    @Column(name = "Status")
    private RequestStatus status;

    @Column(name = "RequestType")
    private String requestType;

    @Column(name = "RequestDate")
    private Date requestDate;

    @Column(name = "ResponseDate")
    private Date responseDate;

    public Request() {}

    public Request(String requestID, String userID, String staffId, String details, RequestStatus status,
                   String requestType, Date requestDate, Date responseDate) {
        this.requestID = UUID.randomUUID().toString();
        this.userID = userID;
        this.staffId = staffId;
        this.details = details;
        this.status = status;
        this.requestType = requestType;
        this.requestDate = requestDate;
        this.responseDate = responseDate;
    }

    public String getRequestID() {
        return requestID;
    }

    public void setRequestID(String requestID) {
        this.requestID = requestID;
    }

    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public String getStaffId() {
        return staffId;
    }

    public void setStaffId(String staffId) {
        this.staffId = staffId;
    }

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }

    public RequestStatus getStatus() {
        return status;
    }

    public void setStatus(RequestStatus status) {
        this.status = status;
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

    @Override
    public String toString() {
        return "Request{" +
                "requestID='" + requestID + '\'' +
                ", userID='" + userID + '\'' +
                ", workspaceStaffId='" + staffId + '\'' +
                ", details='" + details + '\'' +
                ", status='" + status + '\'' +
                ", requestType='" + requestType + '\'' +
                ", requestDate=" + requestDate +
                ", responseDate=" + responseDate +
                '}';
    }
}
