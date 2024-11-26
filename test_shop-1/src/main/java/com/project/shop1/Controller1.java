package com.project.shop1;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.project.shop1.mapper.CustomerMapper;
import com.project.shop1.model.Customer;
import com.project.shop1.service.CustomerService;

@CrossOrigin(origins = "https://localhost:8080")
@RestController
@RequestMapping("/api")
public class Controller1 {
	
	private static final Logger logger = LoggerFactory.getLogger(Controller1.class);


    @Autowired
    private CustomerService customerService;
    
    @Autowired
    private CustomerMapper customerMapper; 

    
    // 고객 목록을 불러오는 메소드   
    @GetMapping("/customers/list")
    public ResponseEntity<Customer> getAllCustomers(@RequestParam("customer_id") String name) {
    	System.out.println("냠ㅇ");
    	System.out.println(name);
        Customer customers = customerMapper.findCustomerById(name);
    
        return ResponseEntity.ok(customers); 
    }
    
    
    @PostMapping("customers/verifyPassword")
    public ResponseEntity<Map<String,Object>> verifyPassword(@RequestBody Map<String, String> payload, HttpServletRequest request){
   
     try {	
    	String customer_id = request.getHeader("username");
    	String currentPassword = payload.get("modal_password");
    	
    	
    	// 비밀번호 검증
    	boolean isPasswordValid = customerService.verifyPassword(customer_id,currentPassword);
    	
        Map<String, Object> response = new HashMap<>();
        response.put("valid", isPasswordValid);
        
        if (isPasswordValid) {
            return ResponseEntity.ok(response);
        } else {
        	response.put("message", "비밀번호가 일치하지 않습니다.");
            return ResponseEntity.status(401).body(response); 
        }
      }catch (Exception e) {
    	e.printStackTrace();
    	
    	Map<String, Object> errorResponse = new HashMap<>();
        errorResponse.put("message", "서버 내부 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
        return ResponseEntity.status(500).body(errorResponse);
      }
    }
    
    
    @PutMapping("customers/updateInfo")
    public ResponseEntity<Map<String, Object>> updateCustomerInfo(@RequestBody Map<String, String> payload) {
        String customerId = (String) payload.get("customer_id");
        String newName = payload.get("name");
        String newEmail = payload.get("email");
        String newPhone = payload.get("tel");

        boolean isUpdated = customerService.updateCustomerInfo(customerId, newName, newEmail, newPhone);

        Map<String, Object> response = new HashMap<>();
        if (isUpdated) {
            response.put("message", "고객 정보가 성공적으로 변경되었습니다.");
            return ResponseEntity.ok(response);
        } else {
            response.put("message", "고객 정보 변경에 실패했습니다.");
            return ResponseEntity.status(500).body(response); 
        }
    }
    

    @PutMapping("customers/updatePassword")
    public ResponseEntity<?> updatePassword(@RequestBody Map<String, String> payload, HttpServletRequest request) {
    	String customerId = payload.get("customer_id");
        String newPassword = payload.get("new_password");
        String currentPassword = payload.get("current_password");
        
        // 비밀번호 검증 및 업데이트 수행
        boolean isUpdated = customerService.validateAndUpdatePassword(customerId, currentPassword, newPassword);

        if (isUpdated) {
            return ResponseEntity.ok("비밀번호가 성공적으로 변경되었습니다");
        } else {
            return ResponseEntity.status(401).body("현재 비밀번호가 일치하지 않습니다.");
        }
    }


}
