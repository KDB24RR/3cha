package com.test.sqlimage.vo;

import java.util.List;

public class cartVo {
    private String customer_id;
    private List<String> thing_ids;
    private String thing_id;
    private int num;
    private int price;
    private int bid;
    private String name;
    private String image_path; 

    public cartVo() {
    }

    public cartVo(String customer_id, List<String> thing_ids, String thing_id, int num, int price, String name, String image_path) {
        this.customer_id = customer_id;
        this.thing_ids = thing_ids;
        this.thing_id = thing_id;
        this.num = num;
        this.price = price;
        this.name = name;
        this.image_path = image_path; // 누락된 필드 추가
    }

    public String getCustomer_id() {
        return customer_id;
    }

    public void setCustomer_id(String customer_id) {
        this.customer_id = customer_id;
    }

    public List<String> getThing_ids() {
        return thing_ids;
    }

    public void setThing_ids(List<String> thing_ids) {
        this.thing_ids = thing_ids;
    }

    public String getThing_id() {
        return thing_id;
    }

    public void setThing_id(String thing_id) {
        this.thing_id = thing_id;
    }

    public int getNum() {
        return num;
    }

    public void setNum(int num) {
        this.num = num;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public int getBid() {
        return bid;
    }

    public void setBid(int bid) {
        this.bid = bid;
    }

    public String getName() { // 수정
        return name;
    }

    public void setName(String name) { // 수정
        this.name = name;
    }

    public String getImage_path() {
        return image_path;
    }

    public void setImage_path(String image_path) {
        this.image_path = image_path;
    }
    
    @Override
    public String toString() {
        return "cartVo{" +
                "customer_id='" + customer_id + '\''+
                ", thing_id='" + thing_id + '\'' +
                ", num=" + num +
                ", price=" + price +
                ", bid=" + bid +
                ", name='" + name + '\'' +
                ", image_path='" + image_path + '\'' +
                '}';
    }
}
