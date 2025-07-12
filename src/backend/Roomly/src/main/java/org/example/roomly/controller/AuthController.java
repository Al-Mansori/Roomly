package org.example.roomly.controller;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import io.swagger.v3.oas.annotations.parameters.RequestBody;
import org.example.roomly.model.AuthResponse;
import org.example.roomly.model.Customer;
import org.example.roomly.model.GoogleAuthRequest;
import org.example.roomly.model.User;
import org.example.roomly.repository.impl.CustomerRepository;
import org.example.roomly.service.UserService;
import org.example.roomly.utils.SimpleJwtUtil;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.gson.GsonFactory;

import javax.imageio.spi.IIORegistry;
import java.util.Collections;


// AuthController.java
@RestController
@RequestMapping("/api/auth")
public class AuthController {
    private UserService userService;
    private CustomerRepository customerRepository;

    @Value("${google.client-id}")
    private String googleClientId;


    @PostMapping("/google")
    public ResponseEntity<?> googleAuth(@RequestBody GoogleAuthRequest request) {
        try {
            // Verify the Google ID token
            GoogleIdToken.Payload payload = verifyGoogleToken(request.getToken());

            // Extract user information
            String email = payload.getEmail();
            String name = (String) payload.get("name");

            // Check if user exists in your database
            User user = userService.getUserByEmail(email);

            if (user == null) {
                // Register new user
                user = new Customer();
                user.setEmail(email);
                user.setFirstName(name);
                customerRepository.save((Customer) user);
            }

            // Generate your JWT token or session
            SimpleJwtUtil jwtTokenProvider = new SimpleJwtUtil();
            String jwtToken = jwtTokenProvider.generateToken(user.getEmail(), user.getId());

            return ResponseEntity.ok(new AuthResponse(jwtToken, user));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
    }

    private GoogleIdToken.Payload verifyGoogleToken(String idToken) throws Exception {
        GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
                new NetHttpTransport(),
                GsonFactory.getDefaultInstance())
                .setAudience(Collections.singletonList(googleClientId))
                .build();

        GoogleIdToken idTokenObj = verifier.verify(idToken);
        if (idTokenObj == null) {
            throw new RuntimeException("Invalid Google ID token");
        }
        return idTokenObj.getPayload();
    }
}
