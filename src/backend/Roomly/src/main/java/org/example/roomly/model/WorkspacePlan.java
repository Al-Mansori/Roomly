package org.example.roomly.model;

public class WorkspacePlan {
    private double yearPrice;
    private double monthPrice;
    private double dailyPrice;

    // Constructors
    public WorkspacePlan() {
    }

    public WorkspacePlan(double yearPrice, double monthPrice, double dailyPrice) {
        this.yearPrice = yearPrice;
        this.monthPrice = monthPrice;
        this.dailyPrice = dailyPrice;
    }

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

    public double getDailyPrice() {
        return dailyPrice;
    }

    public void setDailyPrice(double dailyPrice) {
        this.dailyPrice = dailyPrice;
    }

    @Override
    public String toString() {
        return "WorkspacePlan{" +
                "yearPrice=" + yearPrice +
                ", monthPrice=" + monthPrice +
                ", dailyPrice=" + dailyPrice +
                '}';
    }
}
