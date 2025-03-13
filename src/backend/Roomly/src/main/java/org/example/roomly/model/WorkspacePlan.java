package org.example.roomly.model;

public class WorkspacePlan {
    private double yearPrice;
    private double monthPrice;

    // Constructors
    public WorkspacePlan() {}

    public WorkspacePlan(double yearPrice, double monthPrice) {
        this.yearPrice = yearPrice;
        this.monthPrice = monthPrice;
    }

    // Getters and Setters
    public double getYearPrice() {
        return yearPrice;
    }

    public void setYearPrice(double yearPrice) {
        this.yearPrice = yearPrice;
    }

    public double getMonthPrice() {
        return monthPrice;
    }

    public void setMonthPrice(double monthPrice) {
        this.monthPrice = monthPrice;
    }
}
