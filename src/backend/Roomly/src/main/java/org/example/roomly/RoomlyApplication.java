package org.example.roomly;

import org.example.roomly.model.review;
import org.example.roomly.repository.ReviewRepo;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import java.sql.Date;
import java.time.LocalDate;

@SpringBootApplication
public class RoomlyApplication {

    public static void main(String[] args) {
        SpringApplication.run(RoomlyApplication.class, args);
    }


    public CommandLineRunner commandLineRunner(ReviewRepo reviewRepo){
        return runner ->{
                saveReview(reviewRepo);
        };
    }
    public void saveReview(ReviewRepo reviewRepo){
        review r = new review("oppad1234","oppad123","oppad12",5,"very nice", LocalDate.now());
        reviewRepo.save(r);
    }
}
