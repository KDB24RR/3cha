package com.example.demo.entity;

import javax.persistence.*;

@Entity
@Table(name = "company")
public class CorporateUser {

    @Id
    @Column(name = "company_id", length = 10)
    private String companyId;

    @Column(name = "name", length = 10)
    private String companyName;

    @Column(name = "brn", length = 20, unique = true)
    private String brn;

    @Column(name = "tel", length = 13)
    private String tel;

    @Column(name = "email", length = 20)
    private String email;

    @Column(name = "address", length = 20)
    private String address;

    // Getters and Setters
    public String getCompanyId() {
        return companyId;
    }

    public void setCompanyId(String companyId) {
        this.companyId = companyId;
    }

    public String getName() {
        return companyName;
    }

    public void setName(String companyName) {
        this.companyName = companyName;
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
