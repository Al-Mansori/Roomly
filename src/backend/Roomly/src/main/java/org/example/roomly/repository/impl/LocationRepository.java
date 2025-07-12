package org.example.roomly.repository.impl;

import org.example.roomly.model.Location;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class LocationRepository implements org.example.roomly.repository.LocationRepository {

    private final JdbcTemplate jdbcTemplate;

    @Autowired
    public LocationRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }


    @Override
    public Location save(Location location) {
        String sql = "INSERT INTO Location (Id, City, Town, Country, Longitude, Latitude) VALUES (?, ?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql, location.getId(), location.getCity(), location.getTown(), location.getCountry(), location.getLongitude(), location.getLatitude());
        return location;
    }

    @Override
    public Location update(Location location) {
        String sql = "UPDATE Location SET City = ?, Town = ?, Country = ?, Longitude = ?, Latitude = ? WHERE Id = ?";
        jdbcTemplate.update(sql, location.getCity(), location.getTown(), location.getCountry(), location.getLongitude(), location.getLatitude(), location.getId());
        return location;
    }

    @Override
    public Location findById(String id) {
        String sql = "SELECT * FROM Location WHERE Id = ?";
        return jdbcTemplate.queryForObject(sql, new LocationRowMapper(), id);
    }

    @Override
    public List<Location> findAll() {
        String sql = "SELECT * FROM Location";
        return jdbcTemplate.query(sql, new LocationRowMapper());
    }

    @Override
    public void deleteById(String id) {
        String sql = "DELETE FROM Location WHERE Id = ?";
        jdbcTemplate.update(sql, id);
    }

    @Override
    public List<Location> findByCity(String city) {
        String sql = "SELECT * FROM Location WHERE City = ? ORDER BY City, Town";
        return jdbcTemplate.query(sql, new LocationRowMapper(), city);
    }

    @Override
    public List<Location> findByTown(String town) {
        String sql = "SELECT * FROM Location WHERE Town = ? ORDER BY Town, City";
        return jdbcTemplate.query(sql, new LocationRowMapper(), town);
    }

    @Override
    public List<Location> findByCountry(String country) {
        String sql = "SELECT * FROM Location WHERE Country = ? ORDER BY Country, City, Town";
        return jdbcTemplate.query(sql, new LocationRowMapper(), country);
    }

    @Override
    public List<String> findAllCities() {
        String sql = "SELECT DISTINCT City FROM Location ORDER BY City";
        return jdbcTemplate.queryForList(sql, String.class);
    }

    @Override
    public List<String> findAllTowns() {
        String sql = "SELECT DISTINCT Town FROM Location ORDER BY Town";
        return jdbcTemplate.queryForList(sql, String.class);
    }

    @Override
    public List<String> findAllCountries() {
        String sql = "SELECT DISTINCT Country FROM Location ORDER BY Country";
        return jdbcTemplate.queryForList(sql, String.class);
    }

    private static class LocationRowMapper implements RowMapper<Location> {
        @Override
        public Location mapRow(ResultSet rs, int rowNum) throws SQLException {
            Location location = new Location();
            location.setId(rs.getString("Id"));
            location.setCity(rs.getString("City"));
            location.setTown(rs.getString("Town"));
            location.setCountry(rs.getString("Country"));
            location.setLongitude(rs.getDouble("Longitude"));
            location.setLatitude(rs.getDouble("Latitude"));
            return location;
        }
    }

}
