package org.example.roomly.model;

import org.springframework.stereotype.Component;

import java.util.Date;

@Component
public class Request {
    private String id;
    private String type;
    private Date requestDate;
    private Date responseDate;
    private String details;
    private RequestStatus status;
    private String requestResponse;

    public Request() {
    }

    public Request(String id, String type, Date requestDate, Date responseDate, String details, RequestStatus status, String requestResponse) {
        this.id = id;
        this.type = type;
        this.requestDate = requestDate;
        this.responseDate = responseDate;
        this.details = details;
        this.status = status;
        this.requestResponse = requestResponse;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
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
                "requestId='" + id + '\'' +
                ", requestType='" + type + '\'' +
                ", requestDate=" + requestDate +
                ", responseDate=" + responseDate +
                ", details='" + details + '\'' +
                ", status='" + status + '\'' +
                ", requestResponse='" + requestResponse + '\'' +
                '}';
    }
}