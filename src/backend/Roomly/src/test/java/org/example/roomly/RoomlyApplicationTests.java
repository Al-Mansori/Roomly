package org.example.roomly;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Import;

@Import(TestcontainersConfiguration.class)
@SpringBootTest
class RoomlyApplicationTests {

    @Test
    void contextLoads() {
    }

}
