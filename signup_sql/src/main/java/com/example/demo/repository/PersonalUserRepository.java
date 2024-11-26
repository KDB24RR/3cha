package com.example.demo.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.demo.entity.PersonalUser;

public interface PersonalUserRepository extends JpaRepository<PersonalUser, String> {
    boolean existsByTel(String tel);
    boolean existsByEmail(String email);
}
