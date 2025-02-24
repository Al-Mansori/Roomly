package org.example.roomly.model;

import org.springframework.stereotype.Component;

@Component
public enum PaymentStatus {
    PENDING, CONFIRMED, CANCELLED, COMPLETED
}
