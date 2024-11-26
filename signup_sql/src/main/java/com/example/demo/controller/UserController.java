package com.example.demo.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.dto.CorporateUserRequest;
import com.example.demo.dto.PersonalUserRequest;
import com.example.demo.service.UserService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

@RestController
@RequestMapping("/api")
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping("/check-username")
    public ResponseEntity<?> checkUsername(@RequestParam String username) {
    	System.out.println(username);
        boolean exists = userService.checkUsernameExists(username);
        return exists ? ResponseEntity.status(409).body("이미 사용 중인 아이디입니다.") : ResponseEntity.ok("사용 가능한 아이디입니다.");
    }

    @GetMapping("/check-customer-tel")
    public ResponseEntity<?> checkCustomerTel(@RequestParam String tel) {
    	System.out.print(tel);
        boolean exists = userService.checkCustomerTelExists(tel);
        return exists ? ResponseEntity.status(409).body("이미 사용 중인 전화번호입니다.") : ResponseEntity.ok("사용 가능한 전화번호입니다.");
    }

    @GetMapping("/check-customer-email")
    public ResponseEntity<?> checkCustomerEmail(@RequestParam String email) {
        boolean exists = userService.checkCustomerEmailExists(email);
        return exists ? ResponseEntity.status(409).body("이미 사용 중인 이메일입니다.") : ResponseEntity.ok("사용 가능한 이메일입니다.");
    }

    @GetMapping("/check-company-brn")
    public ResponseEntity<?> checkCompanyBrn(@RequestParam String brn) {
        boolean exists = userService.checkCompanyBrnExists(brn);
        return exists ? ResponseEntity.status(409).body("이미 사용 중인 사업자 번호입니다.") : ResponseEntity.ok("사용 가능한 사업자 번호입니다.");
    }

    @GetMapping("/check-company-email")
    public ResponseEntity<?> checkCompanyEmail(@RequestParam String email) {
        boolean exists = userService.checkCompanyEmailExists(email);
        return exists ? ResponseEntity.status(409).body("이미 사용 중인 이메일입니다.") : ResponseEntity.ok("사용 가능한 이메일입니다.");
    }
    
    
    
    
    @PostMapping("/register/personal")
    public ResponseEntity<?> registerPersonalUser(@RequestBody PersonalUserRequest personalUserRequest) throws JsonProcessingException {
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            String jsonRequest = objectMapper.writeValueAsString(personalUserRequest);
            System.out.println("Received PersonalUserRequest: " + jsonRequest);

            // 비밀번호 암호화
            String encryptedPassword = new BCryptPasswordEncoder(10).encode(personalUserRequest.getPassword());
            personalUserRequest.setPassword(encryptedPassword);

            String result = userService.registerPersonalUser(personalUserRequest);
            return ResponseEntity.ok(Map.of(
                "message", result,
                "encryptedPassword", encryptedPassword // 암호화된 비밀번호 추가
            ));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage())); // 예외도 JSON 형식으로 반환
        }
    }

    @PostMapping("/register/corporate")
    public ResponseEntity<?> registerCorporateUser(@RequestBody CorporateUserRequest corporateUserRequest) {
        try {
            // 비밀번호 암호화
            String encryptedPassword = new BCryptPasswordEncoder(10).encode(corporateUserRequest.getPassword());
            corporateUserRequest.setPassword(encryptedPassword);

            String result = userService.registerCorporateUser(corporateUserRequest);
            System.out.println("Received CorporateUserRequest: " + result);

            return ResponseEntity.ok(Map.of(
                "message", result,
                "encryptedPassword", encryptedPassword // 암호화된 비밀번호 추가
            ));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }
    
    
    
   

//    @PostMapping("/register/personal")
//    public ResponseEntity<?> registerPersonalUser(@RequestBody PersonalUserRequest personalUserRequest) throws JsonProcessingException {
//        try {
//        	
//        	  ObjectMapper objectMapper = new ObjectMapper();
//              String jsonRequest = objectMapper.writeValueAsString(personalUserRequest);
//              System.out.println("Received PersonalUserRequest: " + jsonRequest);
//        	
//            String result = userService.registerPersonalUser(personalUserRequest);
//            return ResponseEntity.ok(Map.of("message", result)); // JSON 형식으로 반환
//        } catch (IllegalArgumentException e) {
//            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage())); // 예외도 JSON 형식으로 반환
//        }
//    }
//
//    @PostMapping("/register/corporate")
//    public ResponseEntity<?> registerCorporateUser(@RequestBody CorporateUserRequest corporateUserRequest) {
//        try {
//
//            String result = userService.registerCorporateUser(corporateUserRequest);
//            System.out.println("Received CorporateUserRequest: " + result);
//            return ResponseEntity.ok(result);
//        } catch (IllegalArgumentException e) {
//            return ResponseEntity.badRequest().body(e.getMessage());
//        }
//    }
    
    
    
    
    
    
}
