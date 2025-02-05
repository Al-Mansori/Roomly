package org.example.roomly.model;

import jakarta.persistence.*;

import java.util.List;

@Entity
@Table(name = "user")
public class Customer extends User{

    @OneToOne(mappedBy = "user", cascade = CascadeType.ALL)
    private Preference preference;

    @Column(name = "RewardsPoints")
    private int rewardPoints;

    // !! Need To Fix !!
//    @OneToMany(mappedBy = "customer")
//    private List<Reservation> reservationHistory;

    public Customer() {
    }

    public Customer(String userId, String name, String email, String password, String phone, String address, Preference preference, int rewardPoints) {
        super(userId, name, email, password, phone, address);
        this.preference = preference;
        this.rewardPoints = rewardPoints;
    }

    public Preference getPreference() {
        return preference;
    }

    public void setPreference(Preference preference) {
        this.preference = preference;
    }

    public int getRewardPoints() {
        return rewardPoints;
    }

    public void setRewardPoints(int rewardPoints) {
        this.rewardPoints = rewardPoints;
    }

    @Override
    public String toString() {
        return super.toString() + ", Customer{" +
                "preference=" + preference +
                ", rewardPoints=" + rewardPoints +
                '}';
    }
}
