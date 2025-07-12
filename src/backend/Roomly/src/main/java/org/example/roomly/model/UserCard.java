package org.example.roomly.model;

public class UserCard {
    private String userId;
    private String cardNumber;

    public UserCard(String userId, String cardNumber) {
        this.userId = userId;
        this.cardNumber = cardNumber;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    @Override
    public String toString() {
        return "UserCard{" +
                "userId='" + userId + '\'' +
                ", cardNumber='" + cardNumber + '\'' +
                '}';
    }

    public String getCardNumber() {
        return cardNumber;
    }

    public void setCardNumber(String cardNumber) {
        this.cardNumber = cardNumber;
    }
}
