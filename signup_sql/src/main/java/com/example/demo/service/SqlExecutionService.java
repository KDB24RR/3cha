package com.example.demo.service;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import org.springframework.stereotype.Service;

@Service
public class SqlExecutionService {
    private final String dbUrl = "jdbc:oracle:thin:@localhost:1521:XE"; // XE는 오라클의 인스턴스 이름입니다.
    private final String dbUser = "hr"; // Oracle 사용자명
    private final String dbPassword = "hr"; // Oracle 비밀번호

    public void executeSql(String sql) {
        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.execute();
            System.out.println("SQL 실행 성공: " + sql);
        } catch (SQLException e) {
            // 모든 오류를 무시하고 로그만 출력
            System.err.println("SQL 실행 중 오류 발생: " + e.getMessage());
        }
    }
}
