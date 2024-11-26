package com.example.demo.service;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import com.example.demo.dto.ApiResponseDTO;
import com.example.demo.dto.BusinessInfoDTO;
import com.example.demo.entity.CorporateUser;
import com.example.demo.repository.CorporateUserRepository;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class BusinessVerificationService {

    @Value("${external.api.url}")
    private String apiUrl;

    @Value("${external.api.key}")
    private String serviceKey;

    private final RestTemplate restTemplate;
    private final CorporateUserRepository corporateUserRepository;

    public BusinessVerificationService(RestTemplate restTemplate, CorporateUserRepository corporateUserRepository) {
        this.restTemplate = restTemplate;
        this.corporateUserRepository = corporateUserRepository;
    }

    @Transactional
    public String verifyAndSaveBusinessInfo(BusinessInfoDTO request) {
        try {
            HttpHeaders headers = new HttpHeaders();
            headers.set("Content-Type", "application/json");

            String urlWithKey = apiUrl + "?serviceKey=" + URLEncoder.encode(serviceKey, StandardCharsets.UTF_8);

            System.out.println("요청 URL: " + urlWithKey);
            System.out.println("요청 데이터: " + new ObjectMapper().writeValueAsString(request));

            HttpEntity<BusinessInfoDTO> entity = new HttpEntity<>(request, headers);

            ResponseEntity<ApiResponseDTO> response = restTemplate.postForEntity(urlWithKey, entity, ApiResponseDTO.class);

            if (response.getStatusCode().is2xxSuccessful()) {
                ApiResponseDTO responseData = response.getBody();

                if (responseData != null && !responseData.getData().isEmpty()) {
                    responseData.getData().forEach(data -> {
                        if (!corporateUserRepository.existsByBrn(data.getB_no())) {
                            CorporateUser corporateUser = new CorporateUser();
                            corporateUser.setCompanyId("COMP" + UUID.randomUUID().toString().substring(0, 5).toUpperCase());
                            corporateUser.setName(data.getRequest_param().getB_nm());
                            corporateUser.setBrn(data.getB_no());
                            corporateUser.setTel("010-0000-0000"); // 기본값
                            corporateUser.setEmail("example@example.com"); // 기본값
                            corporateUser.setAddress("서울특별시 강남구"); // 기본값

                            corporateUserRepository.save(corporateUser);
                        }
                    });
                    return "사업자 정보가 성공적으로 저장되었습니다.";
                }
                return "유효한 데이터가 없습니다.";
            } else {
                throw new RuntimeException("외부 API 호출 실패: 상태 코드 " + response.getStatusCode());
            }
        } catch (HttpClientErrorException e) {
            System.err.println("API 호출 중 오류: " + e.getResponseBodyAsString());
            throw new RuntimeException("외부 API 호출 중 오류 발생: " + e.getResponseBodyAsString(), e);
        } catch (Exception e) {
            System.err.println("예기치 않은 오류: " + e.getMessage());
            throw new RuntimeException("예기치 않은 오류 발생", e);
        }
    }
}
