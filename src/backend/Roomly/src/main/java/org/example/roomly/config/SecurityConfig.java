package org.example.roomly.config;


import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable()) // Disable CSRF for simplicity (enable it in production)
                .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/users/auth/register", "/api/users/auth/verify").permitAll() // Allow registration without authentication
                .anyRequest().authenticated()); // Require authentication for all other endpoints

        return http.build();
    }
}