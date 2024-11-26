package com.example.demo.entity;

import java.time.LocalDate;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "customer")
public class PersonalUser {

	@Id
    @Column(name = "customer_id", length = 10)
    private String customerId;  // "id" 대신 "customer_id"로 변경하여 테이블 필드와 일치

    @Column(name = "name", length = 10)
    private String name;

    @Column(name = "sex")
    private Integer sex;  // 성별 필드 추가 (1: 남성, 2: 여성)

    @Column(name = "tel", length = 15)
    private String tel;

    @Column(name = "birth")
    private LocalDate birth;

    @Column(name = "email", length = 20)
    private String email;

    @Column(name = "address", length = 20)
    private String address;  // 주소 필드 추가
    
    public String getCustomerId() {
        return customerId;
    }

    public void setCustomerId(String customerId) {
        this.customerId = customerId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getSex() {
        return sex;
    }

    public void setSex(Integer sex) {
        this.sex = sex;
    }

    public String getTel() {
        return tel;
    }

    public void setTel(String tel) {
        this.tel = tel;
    }

    public LocalDate getBirth() {
        return birth;
    }

    public void setBirth(LocalDate birth) {
        this.birth = birth;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }
}
