package org.example.roomly;

import org.example.roomly.model.Payment;
import org.example.roomly.model.PaymentStatus;
import org.example.roomly.repository.PaymentRepo;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.jdbc.core.JdbcTemplate;

import java.util.Date;

@SpringBootApplication
public class RoomlyApplication {

    public static void main(String[] args) {
        SpringApplication.run(RoomlyApplication.class, args);
    }

    @Bean
    public CommandLineRunner commandLineRunner(JdbcTemplate jdbcTemplate){
        return runner ->{
                saveReview(jdbcTemplate);
        };
    }
    public void saveReview(JdbcTemplate jdbcTemplate){
        System.out.println("hello");
        PaymentRepo paymentRepo = new PaymentRepo(jdbcTemplate);
//        Payment payment = new Payment();
        paymentRepo.save("1234",new Date(2000,2,2),"cash",575, PaymentStatus.COMPLETED,"39783");
        System.out.println("saved");
    }
}
