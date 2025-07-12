package org.example.roomly.model;

// AuthResponse.java
public class AuthResponse {
    private String token;
    private User user;

    public AuthResponse(String token, User user) {
        this.token = token;
        this.user = user;
    }

    public AuthResponse(String token) {
        this.token = token;
    }
// constructor, getters and setters
}
