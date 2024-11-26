package com.example.demo.service;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.demo.entity.VerificationCode;
import com.example.demo.repository.VerificationCodeRepository;

@Service
public class EmailServiceImpl implements EmailService {

    @Autowired
    private JavaMailSender mailSender;

    @Autowired
    private VerificationCodeRepository verificationCodeRepository;

    @Override
    @Transactional
    public boolean sendVerificationCode(String email) {
        try {
            // 1. 랜덤 인증 코드 생성
            String code = generateRandomCode();

            // 2. 기존 인증 코드 삭제
            verificationCodeRepository.deleteByEmail(email);

            // 3. 인증 코드 저장
            VerificationCode verificationCode = new VerificationCode();
            verificationCode.setEmail(email);
            verificationCode.setCode(code);
            verificationCode.setExpirationTime(LocalDateTime.now().plusMinutes(10)); // 10분 유효
            verificationCodeRepository.save(verificationCode);

            // 4. 이메일 발송
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom("kjcelf@nate.com"); // 올바른 이메일 주소로 설정
            message.setTo(email);
            message.setSubject("이메일 인증 코드");
            message.setText("인증 코드: " + code);
            mailSender.send(message);

            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    @Transactional
    public boolean verifyEmailCode(String email, String code) {
        // 1. 이메일과 코드로 DB 조회
        var optionalCode = verificationCodeRepository.findByEmailAndCode(email, code);

        if (optionalCode.isPresent()) {
            VerificationCode verificationCode = optionalCode.get();

            // 2. 만료 시간 확인
            if (verificationCode.getExpirationTime().isAfter(LocalDateTime.now())) {
                return true; // 인증 성공
            } else {
                // 3. 만료된 코드일 경우 처리
                System.out.println("인증 코드가 만료되었습니다");
            }
        } else {
            // 4. 인증 코드가 없을 경우 처리
            System.out.println("유효하지 않은 인증 요청입니다");
        }

        return false; // 인증 실패
    }

    @Override
    public boolean sendEmail(String to, String subject, String text) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom("kjcelf@nate.com"); // SMTP 인증 이메일
            message.setTo(to);
            message.setSubject(subject);
            message.setText(text);
            mailSender.send(message);

            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private String generateRandomCode() {
        return String.valueOf((int)(Math.random() * 900000) + 100000); // 6자리 랜덤 숫자
    }
}
