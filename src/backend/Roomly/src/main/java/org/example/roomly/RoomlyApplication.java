package org.example.roomly;

import org.example.roomly.model.Payment;
import org.example.roomly.model.PaymentStatus;
import org.example.roomly.model.Reservation;
import org.example.roomly.repository.PaymentRepo;
import org.example.roomly.repository.ReservationRepository;
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
        ReservationRepository reservationRepository = new ReservationRepository(jdbcTemplate);
//        reservationRepository.save("39783",new Date(2003,4,4),new Date(2003,4,5),new Date(2003,4,6),
//                "wait",500.0);
//        PaymentRepo paymentRepo = new PaymentRepo(jdbcTemplate);
////        Payment payment = new Payment();
//        paymentRepo.save("1234",new Date(2000,2,2),"cash",575, PaymentStatus.COMPLETED,"39783");
        Reservation reservation = reservationRepository.find("39783");
        System.out.println(reservation.getStatus());
        System.out.println("saved");
    }
}
