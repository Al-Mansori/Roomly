package org.example.roomly.repository;

import org.example.roomly.model.Offer;
import org.springframework.jdbc.core.JdbcTemplate;

import java.util.List;

public class OfferRepository
{
    private final JdbcTemplate jdbcTemplate;

    public OfferRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // Save Offer
    public int save(Offer offer) {
        String sql = "INSERT INTO Offers (Id, OfferTitle, Description, DiscountPercentage, ValidFrom, ValidTo, Status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql, offer.getId(), offer.getOfferTitle(), offer.getDescription(),
                offer.getDiscountPercentage(), offer.getValidFrom(),
                offer.getValidTo(), offer.getStatus());
    }

    // Find Offer by ID
    public Offer find(String id) {
        String sql = "SELECT * FROM Offers WHERE Id = ?";
        return jdbcTemplate.queryForObject(sql,(rs, rowNum) -> {
            Offer offer = new Offer();
            offer.setId(rs.getString("Id"));
            offer.setOfferTitle(rs.getString("OfferTitle"));
            offer.setDescription(rs.getString("Description"));
            offer.setDiscountPercentage(rs.getDouble("DiscountPercentage"));
            offer.setValidFrom(rs.getDate("ValidFrom"));
            offer.setValidTo(rs.getDate("ValidTo"));
            offer.setStatus(rs.getString("Status"));
            return offer;
        }, id);
    }

    // Find All Offers
    public List<Offer> findAll() {
        String sql = "SELECT * FROM Offers";
        return jdbcTemplate.query(sql,(rs, rowNum) -> {
            Offer offer = new Offer();
            offer.setId(rs.getString("Id"));
            offer.setOfferTitle(rs.getString("OfferTitle"));
            offer.setDescription(rs.getString("Description"));
            offer.setDiscountPercentage(rs.getDouble("DiscountPercentage"));
            offer.setValidFrom(rs.getDate("ValidFrom"));
            offer.setValidTo(rs.getDate("ValidTo"));
            offer.setStatus(rs.getString("Status"));
            return offer;
        });
    }

    // Update Offer
    public int update(Offer offer) {
        String sql = "UPDATE Offers SET OfferTitle = ?, Description = ?, DiscountPercentage = ?, ValidFrom = ?, ValidTo = ?, Status = ? WHERE Id = ?";
        return jdbcTemplate.update(sql, offer.getOfferTitle(), offer.getDescription(),
                offer.getDiscountPercentage(), offer.getValidFrom(),
                offer.getValidTo(), offer.getStatus(), offer.getId());
    }

    // Delete Offer
    public int delete(String id) {
        String sql = "DELETE FROM Offers WHERE Id = ?";
        return jdbcTemplate.update(sql, id);
    }
}
