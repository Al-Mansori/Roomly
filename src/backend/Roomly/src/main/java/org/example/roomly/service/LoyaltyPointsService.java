package org.example.roomly.service;

import org.example.roomly.model.LoyaltyPoints;
import org.example.roomly.repository.LoyaltyPointsRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;

@Service
public class LoyaltyPointsService {
    private final LoyaltyPointsRepository loyaltyPointsRepository;
    @Autowired
    LoyaltyPointsService(LoyaltyPointsRepository loyaltyPointsRepository){this.loyaltyPointsRepository=loyaltyPointsRepository;}
    //Create
    public boolean createLoyalty(String userId,int points){
        if(loyaltyPointsRepository.findById(userId) != null){
            return false;
        }
        loyaltyPointsRepository.save(new LoyaltyPoints(points,points,new Date(),userId));
        return true;
    }
    public LoyaltyPoints getLoyalty(String userId){
        return loyaltyPointsRepository.findById(userId);
    }
    //Delete
    public void deleteLoyalty(String userId){
        loyaltyPointsRepository.deleteById(userId);
    }

    public void updateLoyalty(LoyaltyPoints loyaltyPoints){
        loyaltyPointsRepository.update(loyaltyPoints);
    }

    public void addPoints(String userId,int points){
        LoyaltyPoints loyaltyPoints = loyaltyPointsRepository.findById(userId);
        loyaltyPoints.setTotalPoints(loyaltyPoints.getTotalPoints()+points);
        loyaltyPoints.setLastAddedPoint(points);
        loyaltyPoints.setLastUpdatedDate(new Date());
        loyaltyPointsRepository.update(loyaltyPoints);
    }

    public void deductPoints(String userId,int points){
        LoyaltyPoints loyaltyPoints = loyaltyPointsRepository.findById(userId);
        if(loyaltyPoints.getTotalPoints() >= points) {
            loyaltyPoints.setTotalPoints(loyaltyPoints.getTotalPoints() - points);
            loyaltyPoints.setLastAddedPoint(-points);
            loyaltyPoints.setLastUpdatedDate(new Date());
            loyaltyPointsRepository.update(loyaltyPoints);
        }
    }
}
