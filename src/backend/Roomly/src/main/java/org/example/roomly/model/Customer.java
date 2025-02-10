package org.example.roomly.model;

import jakarta.persistence.*;
import java.util.List;


@Entity
@Table(name = "User")
public class Customer extends User {

    @OneToOne(mappedBy = "user")
    private Preference preference;

    public Customer() {
    }

    public Customer(String userId, String firstName, String lastName, String email, String password, String phone, Preference preference) {
        super(userId, firstName, lastName, email, password, phone);
        this.preference = preference;
    }

    public Preference getPreference() {
        return preference;
    }

    public void setPreference(Preference preference) {
        this.preference = preference;
    }


    @Override
    public String toString() {
        return super.toString() + ", Customer{" +
                "preference=" + preference +
                '}';
    }
}