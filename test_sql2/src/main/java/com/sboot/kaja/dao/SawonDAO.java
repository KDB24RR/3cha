package com.sboot.kaja.dao;

import java.sql.Timestamp;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.sboot.kaja.vo.CreditSearchVO;
import com.sboot.kaja.vo.CreditTransactionVO;
import com.sboot.kaja.vo.SawonVO;


@Mapper
public interface SawonDAO {
    // 특정 ID로 정보를 조회하는 메서드
    public SawonVO getInfo(@Param("id") String customerId);

    // 특정 ID로 ID와 크레딧만 조회하는 메서드
    public SawonVO getInfoById(@Param("customerId")String customerId);

    // 특정 ID로 크레딧만 조회하는 메서드 (getCreditById)
    public Integer getCreditById(@Param("id") String id);  // int 대신 Integer 사용
    
    // 비관적 잠금을 설정해서 고객 크레딧 정보 가져옴.
    SawonVO getCreditForUpdate(@Param("id") String id);
    
    public void updateCredit(@Param("id") String id, @Param("credit") Integer updatedCredit);
    
    public String getId(String id);
    
    public void insertCreditTransaction(
            @Param("customerId") String customerId,
            @Param("usedCredits") Integer usedCredits,
            @Param("transactionType") String transactionType,
            @Param("description") String description,
            @Param("transactionDate") Timestamp transactionDate
        );

	public void insertCreditTransaction(CreditSearchVO transaction);

	public List<CreditTransactionVO> getAllTransactions();

	public List<CreditTransactionVO> getTransactionsWithFilters(@Param("filters") Map<String, Object> filters);
	
	public void cancelinput(@Param("customerId") String customerId, 
            @Param("transactionDate") Timestamp transactionDate, 
            @Param("usedCredits") Integer usedCredits);

	public int deletecancel(@Param("customerId") String customerId, 
            @Param("transactionDate") Timestamp transactionDate);

	public List<CreditTransactionVO> getAllcancelTransactions();

	public void insertCredit(@Param("customerId") String customerId, 
            @Param("transactionDate") Timestamp transactionDate, 
            @Param("usedCredits") Integer usedCredits);

	public int deletecredit(@Param("customerId") String customerId, 
            @Param("transactionDate") Timestamp transactionDate);

	public List<CreditTransactionVO> getTransactionscancel(@Param("filters1") Map<String, Object> filters1);
	
	
}
