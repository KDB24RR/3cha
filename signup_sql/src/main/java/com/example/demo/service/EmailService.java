package com.example.demo.service;

public interface EmailService {
    boolean sendVerificationCode(String email); // 인증 코드 전송
    boolean verifyEmailCode(String email, String code); // 인증 코드 검증
    boolean sendEmail(String to, String subject, String text); // 이메일 전송
}
