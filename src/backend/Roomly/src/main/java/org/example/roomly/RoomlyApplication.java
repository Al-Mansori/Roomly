package org.example.roomly;

import org.example.roomly.model.WorkspaceStaff;
import org.example.roomly.model.WorkspaceStaffType;
import org.example.roomly.model.review;
import org.example.roomly.repository.ReviewRepo;
import org.example.roomly.repository.UserRepository;
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

    @Bean
    public CommandLineRunner commandLineRunner(UserRepository userRepository){
        return runner ->{
                save(userRepository);
        };
    }
    public void save(UserRepository userRepository){
        System.out.println("saving review................");
//        WorkspaceStaff workspaceStaff = new WorkspaceStaff("1234","oppad","nasser","oppad@gmail.com","1234","01030452252",null,WorkspaceStaffType.ADMIN);
//        userRepository.save(workspaceStaff);
//        userRepository.flush();
    }
}
