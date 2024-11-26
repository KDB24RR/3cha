package com.example.demo.dto;

import java.util.List;

public class ApiResponseDTO {
    private String status_code;
    private int request_cnt;
    private int valid_cnt;
    private List<BusinessData> data;

    // Getter/Setter
    public String getStatus_code() {
        return status_code;
    }

    public void setStatus_code(String status_code) {
        this.status_code = status_code;
    }

    public int getRequest_cnt() {
        return request_cnt;
    }

    public void setRequest_cnt(int request_cnt) {
        this.request_cnt = request_cnt;
    }

    public int getValid_cnt() {
        return valid_cnt;
    }

    public void setValid_cnt(int valid_cnt) {
        this.valid_cnt = valid_cnt;
    }

    public List<BusinessData> getData() {
        return data;
    }

    public void setData(List<BusinessData> data) {
        this.data = data;
    }

    // 내부 클래스
    public static class BusinessData {
        private String b_no;
        private RequestParam request_param;

        // Getter/Setter
        public String getB_no() {
            return b_no;
        }

        public void setB_no(String b_no) {
            this.b_no = b_no;
        }

        public RequestParam getRequest_param() {
            return request_param;
        }

        public void setRequest_param(RequestParam request_param) {
            this.request_param = request_param;
        }

        // 또 다른 내부 클래스
        public static class RequestParam {
            private String b_nm;

            public String getB_nm() {
                return b_nm;
            }

            public void setB_nm(String b_nm) {
                this.b_nm = b_nm;
            }
        }
    }
}
