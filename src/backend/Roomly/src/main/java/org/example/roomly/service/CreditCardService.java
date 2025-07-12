package org.example.roomly.service;
import org.example.roomly.model.UserCard;
import org.example.roomly.repository.impl.CreditCardRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CreditCardService {

    private final CreditCardRepository repository;

    @Autowired
    public CreditCardService(CreditCardRepository repository) {
        this.repository = repository;
    }

    public void createCard(UserCard card) {
        repository.insert(card);
    }

    public UserCard getByCardId(String cardNumber) {
        return repository.findById(cardNumber);
    }

    public List<UserCard> getByUserId(String userId) {
        return repository.findByUserId(userId);
    }

    public boolean hasCreditCard(String userId) {
        return !repository.findByUserId(userId).isEmpty();
    }


    public void updateCard(UserCard card) {
        repository.update(card);
    }

    public void deleteCard(String cardNumber) {
        repository.delete(cardNumber);
    }

    public boolean pay(String cardNumber, double amount){return repository.updateBalance(cardNumber,amount);}

//    public boolean isCreditReliable(String cardNumber, String cvv, String endDate){
//        return repository.isCreditReliable(cardNumber, cvv, endDate);
//    }

    public boolean isCreditReliable(String cardNumber, String cvv, String endDate) {
        return repository.isCreditReliable(cardNumber, cvv, endDate);
    }

    public boolean checkBalance(String cardNumber,double amount){
        return repository.checkBalance(cardNumber,amount);
    }
}

