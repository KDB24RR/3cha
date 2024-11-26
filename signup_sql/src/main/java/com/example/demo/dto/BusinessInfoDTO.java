package com.example.demo.dto;

import java.util.List;

public class BusinessInfoDTO {
    private List<String> b_no;
    private String start_dt;
    private String p_nm;
    private String p_nm2 = "";
    private String b_nm = "";
    private String corp_no = "";
    private String b_sector = "";
    private String b_type = "";
    private String b_adr = "";
	public List<String> getB_no() {
		return b_no;
	}
	public void setB_no(List<String> b_no) {
		this.b_no = b_no;
	}
	public String getStart_dt() {
		return start_dt;
	}
	public void setStart_dt(String start_dt) {
		this.start_dt = start_dt;
	}
	public String getP_nm() {
		return p_nm;
	}
	public void setP_nm(String p_nm) {
		this.p_nm = p_nm;
	}
	public String getP_nm2() {
		return p_nm2;
	}
	public void setP_nm2(String p_nm2) {
		this.p_nm2 = p_nm2;
	}
	public String getB_nm() {
		return b_nm;
	}
	public void setB_nm(String b_nm) {
		this.b_nm = b_nm;
	}
	public String getCorp_no() {
		return corp_no;
	}
	public void setCorp_no(String corp_no) {
		this.corp_no = corp_no;
	}
	public String getB_sector() {
		return b_sector;
	}
	public void setB_sector(String b_sector) {
		this.b_sector = b_sector;
	}
	public String getB_type() {
		return b_type;
	}
	public void setB_type(String b_type) {
		this.b_type = b_type;
	}
	public String getB_adr() {
		return b_adr;
	}
	public void setB_adr(String b_adr) {
		this.b_adr = b_adr;
	}

    // Getters and Setters
}
