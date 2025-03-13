package org.example.roomly.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class GoogleLocationService {
    @Value("${google.api.key}")
    private String apiKey;

    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();

    public double[] getCoordinates(String address) {
        String url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + address + "&key=" + apiKey;
        String response = restTemplate.getForObject(url, String.class);

        try {
            JsonNode rootNode = objectMapper.readTree(response);
            JsonNode locationNode = rootNode.path("results").get(0).path("geometry").path("location");

            double latitude = locationNode.path("lat").asDouble();
            double longitude = locationNode.path("lng").asDouble();

            return new double[]{latitude, longitude};
        } catch (Exception e) {
            throw new RuntimeException("Error parsing JSON response", e);
        }
    }

    public String getDistance(String origin, String destination) {
        String url = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=" + origin + "&destinations=" + destination + "&key=" + apiKey;
        return restTemplate.getForObject(url, String.class);
    }
}
