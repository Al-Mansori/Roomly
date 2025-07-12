package org.example.roomly.model;

public class CreditCard {
    private String cardNumber;
    private String cvv;
    private String endDate;
    private String userId;

    public CreditCard(String cardNumber, String cvv, String endDate, String userId) {
        this.cardNumber = cardNumber;
        this.cvv = cvv;
        this.endDate = endDate;
        this.userId = userId;
    }

    public String getCardNumber() {
        return cardNumber;
    }

    public void setCardNumber(String cardNumber) {
        this.cardNumber = cardNumber;
    }

    public String getCvv() {
        return cvv;
    }

    public void setCvv(String cvv) {
        this.cvv = cvv;
    }

    public String getEndDate() {
        return endDate;
    }

    @Override
    public String toString() {
        return "CreditCard{" +
                "cardNumber='" + cardNumber + '\'' +
                ", cvv='" + cvv + '\'' +
                ", endDate='" + endDate + '\'' +
                ", userId='" + userId + '\'' +
                '}';
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }
}
