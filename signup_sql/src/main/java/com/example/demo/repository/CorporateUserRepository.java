package com.example.demo.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.demo.entity.CorporateUser;

public interface CorporateUserRepository extends JpaRepository<CorporateUser, String> {
    boolean existsByBrn(String brn);
    boolean existsByEmail(String email);
}

