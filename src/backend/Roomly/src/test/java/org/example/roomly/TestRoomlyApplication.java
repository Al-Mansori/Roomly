package org.example.roomly;

import org.springframework.boot.SpringApplication;

public class TestRoomlyApplication {

    public static void main(String[] args) {
        SpringApplication.from(RoomlyApplication::main).with(TestcontainersConfiguration.class).run(args);
    }

}
