package org.example.roomly.repository.impl;

import org.example.roomly.model.Offer;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class OfferRepository implements org.example.roomly.repository.OfferRepository {
    private final JdbcTemplate jdbcTemplate;

    public OfferRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // Save Offer
//    @Override public int save(Offer offer) {
//        String sql = "INSERT INTO Offers (Id, OfferTitle, Description, DiscountPercentage, ValidFrom, ValidTo, Status) VALUES (?, ?, ?, ?, ?, ?, ?)";
//        return jdbcTemplate.update(sql, offer.getId(), offer.getOfferTitle(), offer.getDescription(), offer.getDiscountPercentage(), offer.getValidFrom(), offer.getValidTo(), offer.getStatus());
//    }

    @Override
    public int save(Offer offer, String staffId, String roomId) {
        // Save to Offers table
        String sql = "INSERT INTO Offers (Id, OfferTitle, Description, DiscountPercentage, ValidFrom, ValidTo, Status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        int result = jdbcTemplate.update(sql, offer.getId(), offer.getOfferTitle(), offer.getDescription(),
                offer.getDiscountPercentage(), offer.getValidFrom(), offer.getValidTo(), offer.getStatus());

        // Save to Apply table
        if (result > 0 && staffId != null && roomId != null) {
            sql = "INSERT INTO Apply (StaffId, RoomId, OfferId) VALUES (?, ?, ?)";
            jdbcTemplate.update(sql, staffId, roomId, offer.getId());
        }

        return result;
    }

    // Find Offer by ID
    @Override
    public Offer find(String id) {
        String sql = "SELECT * FROM Offers WHERE Id = ?";
        return jdbcTemplate.queryForObject(sql, new OfferRowMapper(), id);
    }

    // Find All Offers
    @Override
    public List<Offer> findAll() {
        String sql = "SELECT * FROM Offers";
        return jdbcTemplate.query(sql, new OfferRowMapper());
    }

    // Update Offer
    @Override
    public int update(Offer offer) {
        String sql = "UPDATE Offers SET OfferTitle = ?, Description = ?, DiscountPercentage = ?, ValidFrom = ?, ValidTo = ?, Status = ? WHERE Id = ?";
        return jdbcTemplate.update(sql, offer.getOfferTitle(), offer.getDescription(), offer.getDiscountPercentage(), offer.getValidFrom(), offer.getValidTo(), offer.getStatus(), offer.getId());
    }

    // Delete Offer
//    @Override
//    public int delete(String id) {
//        String sql = "DELETE FROM Offers WHERE Id = ?";
//        return jdbcTemplate.update(sql, id);
//    }

    @Override
    public int delete(String id) {
        // First delete from Apply
        deleteAppliedOffers(id);

        // Then delete from Offers
        String sql = "DELETE FROM Offers WHERE Id = ?";
        return jdbcTemplate.update(sql, id);
    }

    @Override
    public int deleteAppliedOffers(String offerId) {
        String sql = "DELETE FROM Apply WHERE OfferId = ?";
        return jdbcTemplate.update(sql, offerId);
    }

    @Override
    public List<Offer> findOffersByRoomId(String roomId) {
        String sql = "SELECT o.* FROM Offers o " +
                "JOIN Apply ao ON o.Id = ao.OfferId " +
                "WHERE ao.RoomId = ?";
        return jdbcTemplate.query(sql, new OfferRowMapper(), roomId);
    }

    @Override
    public List<Offer> findOffersByStaffId(String staffId) {
        String sql = "SELECT o.* FROM Offers o " +
                "JOIN Apply ao ON o.Id = ao.OfferId " +
                "WHERE ao.StaffId = ?";
        return jdbcTemplate.query(sql, new OfferRowMapper(), staffId);
    }

    private static class OfferRowMapper implements RowMapper<Offer> {
        @Override
        public Offer mapRow(ResultSet rs, int rowNum) throws SQLException {
            Offer offer = new Offer();
            offer.setId(rs.getString("Id"));
            offer.setOfferTitle(rs.getString("OfferTitle"));
            offer.setDescription(rs.getString("Description"));
            offer.setDiscountPercentage(rs.getDouble("DiscountPercentage"));
            offer.setValidFrom(rs.getDate("ValidFrom"));
            offer.setValidTo(rs.getDate("ValidTo"));
            offer.setStatus(rs.getString("Status"));
            return offer;
        }
    }
}
