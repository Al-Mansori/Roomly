package org.example.roomly.model;

import com.fasterxml.jackson.annotation.JsonProperty;

public class LogInRequest {
    private String email;
    private String password;
    @JsonProperty("isStaff")
    private boolean isStaff;

    public LogInRequest(String email, String password,boolean isStaff) {
        this.email = email;
        this.password = password;
        this.isStaff = isStaff;
    }

    public LogInRequest(){

    }

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public boolean isStaff() {
        return isStaff;
    }

    public void setStaff(boolean staff) {
        isStaff = staff;
    }
}
