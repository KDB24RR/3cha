package com.sboot.kaja;

import com.sboot.kaja.dao.SawonDAO;
import com.sboot.kaja.vo.CreditSearchVO;
import com.sboot.kaja.vo.CreditTransactionVO;
import com.sboot.kaja.vo.SawonVO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.time.Instant;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.PriorityBlockingQueue;

import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionSynchronizationManager;

@Service
public class CreditService {

    @Autowired
    private SawonDAO dao; // DAO 주입

    // 모든 거래 내역을 조회하는 메서드
    public List<CreditTransactionVO> getAllTransactions() {
        return dao.getAllTransactions();
    }

	/*
	 * public List<CreditTransactionVO> getTransactionsWithFilters(Map<String,
	 * Object> filters) { // TODO Auto-generated method stub return
	 * dao.getTransactionsWithFilters(filters); }
	 */
	
    public List<CreditTransactionVO> getTransactionsWithFilters(Map<String, Object> filters) {
        // DAO 호출하여 거래 내역을 가져옴
        List<CreditTransactionVO> transactions = dao.getTransactionsWithFilters(filters);

        // 필터 값 로그 출력
        System.out.println("Filters: " + filters);

        // 반환된 데이터를 로그로 출력
        for (CreditTransactionVO transaction : transactions) {
            System.out.println(transaction); // toString() 메서드를 호출하여 객체의 정보를 출력
        }
        
        return transactions;
    }
    
    
    // FIFO
    // FIFO 큐를 사용해 트랜잭션 순서를 제어
    private final PriorityBlockingQueue<PriorityTask> transactionQueue = new PriorityBlockingQueue<>();

    // 별도의 스레드에서 큐를 처리
    public CreditService() {
        Thread transactionProcessor = new Thread(() -> {
            while (true) {
                try {
                	PriorityTask task = transactionQueue.take(); // 우선순위에 따라 작업 가져오기
                	task.getTask().run(); // 작업 실행
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    break; // 스레드 종료
                }
            }
        });
        transactionProcessor.setDaemon(true); // 데몬 스레드로 설정
        transactionProcessor.start();
    }

    // 작업을 큐에 추가
    private void enqueueTransaction(Runnable task, int priority) {
        transactionQueue.add(new PriorityTask(task, priority));
    }
    
    // 우선순위 작업 클래스
    private static class PriorityTask implements Comparable<PriorityTask> {
        private final Runnable task;
        private final int priority;

        public PriorityTask(Runnable task, int priority) {
            this.task = task;
            this.priority = priority;
        }

        public Runnable getTask() {
            return task;
        }

        @Override
        public int compareTo(PriorityTask other) {
            return Integer.compare(this.priority, other.priority); // 낮은 숫자가 높은 우선순위
        }
    }
    
    
    @Transactional(isolation = Isolation.SERIALIZABLE)  // 트랜잭션 관리
    public void cancelTransaction(String customerId, Integer usedCredits, Timestamp transactionDate) {
    	enqueueTransaction(() -> {	
    try {	
    	System.out.println("cancelTransaction 트랜잭션 시작 - 고객 ID: " + customerId + ", 취소 크레딧: " + usedCredits);
    	
    	 // 트랜잭션 활성화 여부 확인
        boolean isTransactionActive = TransactionSynchronizationManager.isActualTransactionActive();
        System.out.println("Cancel Transaction - 트랜잭션 활성 상태: " + isTransactionActive);
    	
        // 비관적 잠금을 통해 고객의 크레딧 정보를 가져옵니다.
        SawonVO sawon = dao.getCreditForUpdate(customerId);
        
        
        // 현재 크레딧 가져오기
        Integer currentCredit = sawon.getCredit(); 
        
        
        // 크레딧 업데이트 계산
        Integer updatedCredit = currentCredit + usedCredits; 
        
        
        // 크레딧 업데이트
        dao.updateCredit(customerId, updatedCredit); // 기존 메서드를 호출
        
        
        System.out.println(customerId);
        // 거래 취소 내역에 삽입
        dao.cancelinput(customerId, transactionDate, usedCredits);
        

        // 원래 구매 내역에서 삭제
        dao.deletecancel(customerId, transactionDate);
        
        
        System.out.println("cancelTransaction 트랜잭션 종료 - 고객 ID: " + customerId);
    }catch (Exception e) {
    	System.err.println("cancelTransaction 예외 발생: " + e.getMessage());
        e.printStackTrace();
    }
    	},2);
        
    }
    
    
    
    @Transactional(isolation = Isolation.SERIALIZABLE)  // 트랜잭션 관리
    public ResponseEntity<Map<String, Object>> useCredits(String customerId, Integer usedCredits) {
        Map<String, Object> response = new HashMap<>();
        enqueueTransaction(() -> {    
    try {   
        System.out.println("useCredits 트랜잭션 시작 - 고객 ID: " + customerId + ", 사용 크레딧: " + usedCredits);
        
        // 트랜잭션 활성화 여부 확인
        boolean isTransactionActive = TransactionSynchronizationManager.isActualTransactionActive();
        System.out.println("Use Credits - 트랜잭션 활성 상태: " + isTransactionActive);

        
        // 비관적 잠금을 통해 고객의 크레딧 정보를 가져옵니다.
        SawonVO sawon = dao.getCreditForUpdate(customerId);

        
        // 현재 크레딧 가져오기
        Integer currentCredit = sawon.getCredit();

        // 사용자의 크레딧이 충분한지 확인
        if (currentCredit < usedCredits) {
            response.put("success", false);
            response.put("message", "사용 가능한 크레딧을 초과했습니다.");
           
        }else {

        // 크레딧 업데이트 계산 (차감)
        Integer updatedCredit = currentCredit - usedCredits;

        // 크레딧 업데이트
        dao.updateCredit(customerId, updatedCredit);

        // VO 객체 생성 후 사용
        CreditSearchVO transaction = new CreditSearchVO(
            customerId,
            usedCredits,
            "결제",
            "상품 구매",
            Timestamp.from(Instant.now())
        );

        // VO를 통해 거래 내역 삽입
        dao.insertCreditTransaction(transaction);

        response.put("success", true);
        response.put("message", "결제가 완료되었습니다.");
    } 
        System.out.println("useCredits 트랜잭션 종료 - 고객 ID: " + customerId);
    } catch (Exception e) {
    	System.err.println("useCredits 예외 발생: " + e.getMessage());
    }
        },1);
        return ResponseEntity.ok(response); // 성공 시 응답 반환
        
    }



}
