package org.example.roomly;

import org.example.roomly.repository.ReviewRepo;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.sql.Date;
import java.time.LocalDate;

@SpringBootApplication
public class RoomlyApplication {

    public static void main(String[] args) {
        SpringApplication.run(RoomlyApplication.class, args);
    }


    public CommandLineRunner commandLineRunner(){
        return runner ->{
                saveReview();
        };
    }
    public void saveReview(){
        System.out.println("hello");
    }
}
