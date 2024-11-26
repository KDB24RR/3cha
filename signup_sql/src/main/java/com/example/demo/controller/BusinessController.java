package com.example.demo.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.dto.BusinessInfoDTO;
import com.example.demo.service.BusinessVerificationService;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "https://localhost:8080")
public class BusinessController {

    private final BusinessVerificationService businessVerificationService;

    public BusinessController(BusinessVerificationService businessVerificationService) {
        this.businessVerificationService = businessVerificationService;
    }

    @PostMapping("/business-info")
    public ResponseEntity<?> verifyAndSaveBusinessInfo(@RequestBody BusinessInfoDTO request) {
        try {
            if (request.getB_no() == null || request.getB_no().isEmpty()) {
                return ResponseEntity.badRequest().body("사업자 번호는 필수입니다.");
            }

            String response = businessVerificationService.verifyAndSaveBusinessInfo(request);
            return ResponseEntity.ok(response);

        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body("요청 데이터 오류: " + e.getMessage());
        } catch (RuntimeException e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("외부 서비스 오류: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("서버 내부 오류: " + e.getMessage());
        }
    }
}
