package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

	  @GetMapping("/signup")
	    public String signupPage() {
	        return "signup";  // signup.jsp 페이지를 반환
	  }
}
