package com.sboot.kaja;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Timestamp;
import java.time.Instant;

@SpringBootTest
public class PessimisticLockTest {

    @Autowired
    private CreditService creditService;

    @Test
    public void testPessimisticLock() throws InterruptedException {
        Thread thread1 = new Thread(() -> {
            creditService.useCredits("admin", 100); // 우선순위 2
        });

        Thread thread2 = new Thread(() -> {
            creditService.cancelTransaction("admin", 100, Timestamp.from(Instant.now())); // 우선순위 1
        });

        // 두 스레드를 동시에 시작
        thread1.start();
        thread2.start();

        // 두 스레드가 완료될 때까지 대기
        thread1.join();
        thread2.join();

        // 테스트 출력 로그로 순서 확인
        System.out.println("Test completed");
    }
}
