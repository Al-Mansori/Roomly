package org.example.roomly.model;

import org.springframework.stereotype.Component;

@Component
public enum RequestStatus {
    OPEN,
    RESOLVED,
    PENDING
}