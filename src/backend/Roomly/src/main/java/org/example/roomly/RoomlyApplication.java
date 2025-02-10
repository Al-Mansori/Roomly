package org.example.roomly;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

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
