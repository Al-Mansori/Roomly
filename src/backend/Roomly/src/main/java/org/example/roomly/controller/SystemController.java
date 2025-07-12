package org.example.roomly.controller;

import org.example.roomly.service.LocationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("api/system")
public class SystemController {
    @Autowired
    private LocationService locationService;

    @GetMapping("/location/cities")
    public ResponseEntity<List<String>> getAllUniqueCities() {
        return ResponseEntity.ok(locationService.getAllUniqueCities());
    }

    @GetMapping("/location/towns")
    public ResponseEntity<List<String>> getAllUniqueTowns() {
        return ResponseEntity.ok(locationService.getAllUniqueTowns());
    }

    @GetMapping("/location/countries")
    public ResponseEntity<List<String>> getAllUniqueCountries() {
        return ResponseEntity.ok(locationService.getAllUniqueCountries());
    }
}
