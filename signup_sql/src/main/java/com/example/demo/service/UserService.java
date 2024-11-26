package com.example.demo.service;

import com.example.demo.dto.CorporateUserRequest;
import com.example.demo.dto.PersonalUserRequest;
import com.example.demo.entity.CorporateUser;
import com.example.demo.entity.PersonalUser;

public interface UserService {
    boolean checkUsernameExists(String username);
    boolean checkCustomerTelExists(String tel);
    boolean checkCustomerEmailExists(String email);
    boolean checkCompanyBrnExists(String brn);
    boolean checkCompanyEmailExists(String email);

    String registerPersonalUser(PersonalUser personalUser, String password, String code);
    String registerCorporateUser(CorporateUser corporateUser, String password, String code);
	String registerPersonalUser(PersonalUserRequest personalUserRequest);
	String registerCorporateUser(CorporateUserRequest request);
}
