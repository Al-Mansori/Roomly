package org.example.roomly.repository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import org.example.roomly.model.review;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public class ReviewRepo {
    private EntityManager entityManager;
    @Autowired
    public ReviewRepo(EntityManager e){
        this.entityManager = e;
    }
    @Transactional
    public String save(review r){
        entityManager.persist(r);
        return "Review published";
    }
    public List<review> findByWorkspaceId(int workspaceId){
        TypedQuery<review> query = entityManager.createQuery("FROM review WHERE workspaceId=:id",review.class);
        query.setParameter("id",workspaceId);
        return query.getResultList();
    }
    public double calculateAverageRating(int theworkspaceId){
        Object[] result = (Object[]) entityManager.createQuery(
                        "SELECT SUM(r.rating), COUNT(r) FROM review r")
                .getSingleResult();
        Double totalRating = result[0] != null ? (Double) result[0] : 0.0;
        Long Count = result[1] != null ? (Long) result[1] : 0L;
        return (double)(totalRating/Count);
    }
    public String delete(int reviewId){
        review r = entityManager.find(review.class,reviewId);
        entityManager.remove(r);
        return "review deleted";
    }
}
