package org.example.roomly.service;

import org.example.roomly.model.Request;
import org.example.roomly.model.RequestStatus;
import org.example.roomly.repository.RequestRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class RequestService{

    private final RequestRepository requestRepository;

    @Autowired
    public RequestService(RequestRepository requestRepository) {
        this.requestRepository = requestRepository;
    }

    public Request createRequest(String type, String details){
        String id = UUID.randomUUID().toString();
        Date requestDate = new Date();
        RequestStatus status = RequestStatus.PENDING;
        Request request = new Request(id,type,requestDate,null,details,status,null);
        return  request;
    }

    public void saveRequest(Request request) {
        requestRepository.save(request);
    }

    public Request findRequestById(String requestId) {
        return requestRepository.findById(requestId);
    }

    public void updateRequest(Request request) {
        requestRepository.update(request);
    }

    public void deleteRequestById(String requestId) {
        requestRepository.deleteById(requestId);
    }

    public List<Request> findAllRequests() {
        return requestRepository.findAll();
    }

    public void saveUserRequesting(String userId, String requestId, String staffId) {
        requestRepository.saveUserRequesting(userId, requestId, staffId);
    }

    public void deleteUserRequesting(String requestId) {
        requestRepository.deleteUserRequesting(requestId);
    }
}