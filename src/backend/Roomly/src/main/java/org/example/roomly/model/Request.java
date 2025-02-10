package org.example.roomly.model;

import java.util.Date;

public class Request {
    private String requestId;
    private String requestType;
    private Date requestDate;
    private Date responseDate;
    private String details;
    private RequestStatus status;
    private String requestResponse;

    public Request() {
    }

    public Request(String requestId, String requestType, Date requestDate, Date responseDate, String details, RequestStatus status, String requestResponse) {
        this.requestId = requestId;
        this.requestType = requestType;
        this.requestDate = requestDate;
        this.responseDate = responseDate;
        this.details = details;
        this.status = status;
        this.requestResponse = requestResponse;
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

    public RequestStatus getStatus() {
        return status;
    }

    public void setStatus(RequestStatus status) {
        this.status = status;
    }

    public String getRequestResponse() {
        return requestResponse;
    }

    public void setRequestResponse(String requestResponse) {
        this.requestResponse = requestResponse;
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
                '}';
    }
}