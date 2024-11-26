package com.example.demo.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

public class CorporateUserRequest {
    private String username;
    private String password;
    @JsonProperty("businessNumber")
    private String brn;
    @JsonProperty("phone")
    private String tel;
    @JsonProperty("companyName")
    private String name;
	private String email;
    private String address;
    private String verificationCode; // 추가
    
    public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getBrn() {
		return brn;
	}
	public void setBrn(String brn) {
		this.brn = brn;
	}
	public String getTel() {
		return tel;
	}
	public void setTel(String tel) {
		this.tel = tel;
	}
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
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
    public String getVerificationCode() {
		return verificationCode;
	}
	public void setVerificationCode(String verificationCode) {
		this.verificationCode = verificationCode;
	}

    // Getters and Setters
	

}
