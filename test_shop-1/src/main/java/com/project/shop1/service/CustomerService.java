package com.project.shop1.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.shop1.mapper.CustomerMapper;
import com.project.shop1.model.Customer;

@Service
public class CustomerService {

	@Autowired
    private PasswordUtil passwordUtil;
	
	
    @Autowired
    private CustomerMapper customerMapper;

    public List<Customer> getAllCustomers() {
        return customerMapper.findAllCustomers();
    }

    public Customer getCustomerById(String customer_id) {
        return customerMapper.findCustomerById(customer_id);
    }

    
    
    public boolean updateCustomerInfo(String customerId, String newName, String newEmail, String newPhone) {
        try {
            int result =  customerMapper.updateCustomerInfo(customerId, newName, newEmail, newPhone); 
            if (result > 0) {
            	return true;
            }else {
            	System.out.println("업데이트 실패");
            	return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    
    // 비밀번호를 검증하는 메서드
    public boolean verifyPassword(String customer_id, String currentPassword) {
        String storedPassword = customerMapper.getPasswordByCustomerId(customer_id);
        System.out.println("비번띠:"+storedPassword);
        boolean isPasswordValid = storedPassword != null && passwordUtil.matches(currentPassword, storedPassword);
        return isPasswordValid;
    }
    

 // 비밀번호 검증 후 업데이트하는 메서드
    public boolean validateAndUpdatePassword(String customerId, String currentPassword, String newPassword) {
        // 데이터베이스에서 저장된 암호화된 비밀번호 조회
        String storedPassword = customerMapper.getCurrentPassword(customerId);
        System.out.println("Stored password: " + storedPassword);
        System.out.println("currentPassword: " + currentPassword);
        System.out.println("newPassword: " + newPassword);
        System.out.println("customerId: " + customerId);
        // 현재 비밀번호 검증
        boolean isPasswordValid = storedPassword != null && passwordUtil.matches(currentPassword, storedPassword);
        System.out.println("Is password valid: " + isPasswordValid);

        // 비밀번호가 일치하지 않으면 false 반환
        if (!isPasswordValid) {
            return false;
        }

        // 비밀번호가 유효하다면 새 비밀번호를 암호화하여 업데이트
        String encryptedPassword = passwordUtil.encodePassword(newPassword);
        int updatedRows = customerMapper.updatePassword(customerId, encryptedPassword);

        return updatedRows > 0; // 업데이트 성공 여부 반환
    }
    
    
}

