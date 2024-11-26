package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.example.demo.service.EmailService;

import java.util.Map;

@RestController
@RequestMapping("/api")
public class EmailController {

    @Autowired
    private EmailService emailService;

    // 이메일 인증 코드 전송 요청 처리
    @PostMapping("/send-email-verification")
    public ResponseEntity<String> sendEmailVerification(@RequestBody Map<String, String> payload) {
        String email = payload.get("email");
        if (email == null || email.isEmpty()) {
            return ResponseEntity.badRequest().body("이메일을 입력해 주세요.");
        }
        boolean success = emailService.sendVerificationCode(email);
        return success ? ResponseEntity.ok("이메일 인증 코드가 전송되었습니다.")
                       : ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("이메일 전송 실패");
    }

    // 이메일 인증 코드 검증 요청 처리
    @PostMapping("/verify-email-code")
    public ResponseEntity<Map<String, Object>> verifyEmailCode(@RequestBody Map<String, String> payload) {
        String email = payload.get("email");
        String code = payload.get("code");

        if (email == null || email.isEmpty() || code == null || code.isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "이메일과 인증 코드를 입력해 주세요."));
        }

        boolean isVerified = emailService.verifyEmailCode(email, code);

        return isVerified ? ResponseEntity.ok(Map.of("success", true, "message", "이메일 인증 성공"))
                          : ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("success", false, "message", "인증 코드가 올바르지 않거나 만료되었습니다."));
    }
    

    
}
