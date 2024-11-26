package com.example.demo.service;

import java.time.LocalDate;
import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.demo.dto.CorporateUserRequest;
import com.example.demo.dto.PersonalUserRequest;
import com.example.demo.entity.CorporateUser;
import com.example.demo.entity.PersonalUser;
import com.example.demo.entity.Users;
import com.example.demo.entity.VerificationCode;
import com.example.demo.repository.CorporateUserRepository;
import com.example.demo.repository.PersonalUserRepository;
import com.example.demo.repository.UsersRepository;
import com.example.demo.repository.VerificationCodeRepository;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private PersonalUserRepository personalUserRepository;

    @Autowired
    private CorporateUserRepository corporateUserRepository;

    @Autowired
    private UsersRepository usersRepository;
    
    @Autowired
    private VerificationCodeRepository verificationCodeRepository;

    @Override
    public boolean checkUsernameExists(String username) {
        return usersRepository.existsByUsername(username);
    }

    @Override
    public boolean checkCustomerTelExists(String tel) {
        return personalUserRepository.existsByTel(tel);
    }

    @Override
    public boolean checkCustomerEmailExists(String email) {
        return personalUserRepository.existsByEmail(email);
    }

    @Override
    public boolean checkCompanyBrnExists(String brn) {
        return corporateUserRepository.existsByBrn(brn);
    }

    @Override
    public boolean checkCompanyEmailExists(String email) {
        return corporateUserRepository.existsByEmail(email);
    }

    @Transactional
    public boolean verifyEmailCode(String email, String code) {
        // 1. 이메일과 코드로 DB 조회
        var optionalCode = verificationCodeRepository.findByEmailAndCode(email, code);
        	System.out.println(code);
        	System.out.println(email);
        if (optionalCode.isPresent()) {
            VerificationCode verificationCode = optionalCode.get();

            // 2. 만료 시간 확인
            if (verificationCode.getExpirationTime().isAfter(LocalDateTime.now())) {
                // 인증 성공 시, 사용된 인증 코드 삭제 (중복 방지)
                verificationCodeRepository.deleteByEmail(email);
                return true; // 인증 성공
            } else {
                System.out.println("인증 코드가 만료되었습니다.");
            }
        } else {
            System.out.println("유효하지 않은 인증 요청입니다.");
        }

        return false; // 인증 실패
    }
    
    @Transactional
    @Override
    public String registerPersonalUser(PersonalUserRequest request) {
        // 유효성 검사
        if (request.getUsername() == null || request.getUsername().isEmpty()) {
            throw new IllegalArgumentException("아이디는 필수 입력 사항입니다.");
        }
        if (request.getPassword() == null || request.getPassword().isEmpty()) {
            throw new IllegalArgumentException("비밀번호는 필수 입력 사항입니다.");
        }
        if (request.getTel() == null || request.getTel().isEmpty()) {
            throw new IllegalArgumentException("전화번호는 필수 입력 사항입니다.");
        }
        if (request.getEmail() == null || request.getEmail().isEmpty()) {
            throw new IllegalArgumentException("이메일은 필수 입력 사항입니다.");
        }
        
        // 이메일 인증 검증
        if (!verifyEmailCode(request.getEmail(), request.getVerificationCode())) {
            throw new IllegalArgumentException("이메일 인증이 완료되지 않았습니다.");
        }

        if (checkUsernameExists(request.getUsername())) {
            throw new IllegalArgumentException("이미 사용 중인 아이디입니다.");
        }
        if (checkCustomerTelExists(request.getTel())) {
            throw new IllegalArgumentException("이미 사용 중인 전화번호입니다.");
        }
        if (checkCustomerEmailExists(request.getEmail())) {
            throw new IllegalArgumentException("이미 사용 중인 이메일입니다.");
        }

        // Users 저장
        Users user = new Users();
        user.setUsername(request.getUsername());
        user.setPassword(request.getPassword());
        user.setRole("consumer");
        usersRepository.save(user);

        // PersonalUser 저장
        PersonalUser personalUser = new PersonalUser();
        personalUser.setName(request.getName());
        personalUser.setCustomerId(request.getUsername());
        personalUser.setTel(request.getTel());
        personalUser.setEmail(request.getEmail());
        personalUser.setAddress(request.getAddress());
        if (request.getBirthDate() != null && !request.getBirthDate().isEmpty()) {
            personalUser.setBirth(LocalDate.parse(request.getBirthDate()));
        }
        personalUser.setSex(request.getGender().equalsIgnoreCase("male") ? 1 : 2);
        personalUserRepository.save(personalUser);

        return "개인 회원 가입이 완료되었습니다.";
    }


    @Transactional
    @Override
    public String registerCorporateUser(CorporateUserRequest request) {
        if (checkUsernameExists(request.getUsername())) {
            throw new IllegalArgumentException("이미 사용 중인 아이디입니다.");
        }
        if (checkCompanyBrnExists(request.getBrn())) {
            throw new IllegalArgumentException("이미 사용 중인 사업자 번호입니다.");
        }
        if (checkCompanyEmailExists(request.getEmail())) {
            throw new IllegalArgumentException("이미 사용 중인 이메일입니다.");
        }
        
        // 이메일 인증 검증
        if (!verifyEmailCode(request.getEmail(), request.getVerificationCode())) {
            throw new IllegalArgumentException("이메일 인증이 완료되지 않았습니다.");
        }

        // Users 테이블에 저장
        Users user = new Users();
        user.setUsername(request.getUsername());
        user.setPassword(request.getPassword()); // DTO에서 받은 password 사용
        user.setRole("company");
        usersRepository.save(user);

        // CorporateUser 테이블에 저장
        CorporateUser corporateUser = new CorporateUser();
        corporateUser.setCompanyId(request.getUsername());
        corporateUser.setName(request.getName());
        corporateUser.setBrn(request.getBrn());
        corporateUser.setTel(request.getTel());
        corporateUser.setEmail(request.getEmail());
        corporateUser.setAddress(request.getAddress());
        corporateUserRepository.save(corporateUser);

        return "기업 회원 가입이 완료되었습니다.";
    }

	@Override
	public String registerPersonalUser(PersonalUser personalUser, String password, String code) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String registerCorporateUser(CorporateUser corporateUser, String password, String code) {
		// TODO Auto-generated method stub
		return null;
	}
}