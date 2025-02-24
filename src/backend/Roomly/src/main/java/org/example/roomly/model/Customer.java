package org.example.roomly.model;

import org.springframework.stereotype.Component;

@Component
public class Customer extends User {
    private String address;

    public Customer() {
    }

    public Customer(String userId, String firstName, String lastName, String email, String password, String phone, String address) {
        super(userId, firstName, lastName, email, password, phone);
        this.address = address;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }


    @Override
    public String toString() {
        return super.toString() + ", Customer{" +
                "address=" + address +
                '}';
    }
}