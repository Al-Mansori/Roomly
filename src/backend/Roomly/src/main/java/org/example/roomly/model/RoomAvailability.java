package org.example.roomly.model;

import org.springframework.stereotype.Component;

import java.time.LocalDate;

@Component
public class RoomAvailability {
    private String roomId;
    private LocalDate date;
    private int hour;
    private int availableSeats;
    private int capacity;
    private RoomStatus roomStatus;

    // Constructors
    public RoomAvailability() {}

    public RoomAvailability(String roomId, LocalDate date, int hour, int availableSeats, int capacity, RoomStatus roomStatus) {
        this.roomId = roomId;
        this.date = date;
        this.hour = hour;
        this.availableSeats = availableSeats;
        this.capacity = capacity;
        this.roomStatus = roomStatus;
    }

    // Getters and Setters
    public String getRoomId() {
        return roomId;
    }

    public void setRoomId(String roomId) {
        this.roomId = roomId;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public int getHour() {
        return hour;
    }

    public void setHour(int hour) {
        this.hour = hour;
    }

    public int getAvailableSeats() {
        return availableSeats;
    }

    public void setAvailableSeats(int availableSeats) {
        this.availableSeats = availableSeats;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public RoomStatus getRoomStatus() {
        return roomStatus;
    }

    public void setRoomStatus(RoomStatus roomStatus) {
        this.roomStatus = roomStatus;
    }

    @Override
    public String toString() {
        return "RoomAvailability{" +
                "roomId='" + roomId + '\'' +
                ", date=" + date +
                ", hour=" + hour +
                ", availableSeats=" + availableSeats +
                ", capacity=" + capacity +
                ", roomStatus=" + roomStatus +
                '}';
    }
}