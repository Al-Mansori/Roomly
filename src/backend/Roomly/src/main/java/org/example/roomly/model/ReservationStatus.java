package org.example.roomly.model;

import org.springframework.stereotype.Component;

@Component
public enum ReservationStatus {
    PENDING, CONFIRMED, CANCELLED, COMPLETED
}
