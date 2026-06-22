package com.example.demo.company.model;

/**
 * ==========================================================================
 * [PartnerMember] member 테이블 계정 정보 및 권한(ROLE) 수급 전용 비즈니스 DTO 객체
 * ==========================================================================
 */
public class PartnerMember {
    
    private String userId;
    private String password;
    private String role; // NPARTNER, PARTNER 권한 제어 코어
    private String status;
    private String tel;
    private String regDate;
    private String lastLogin;
    private String previousPayment;
    private String outDate;
    
    // 💡 화면 렌더링 최적화를 위해 company 테이블 조인 데이터용 업체명 필드 추가 확장
    private String comName;

    // 런타임 빈 인스턴스 생성을 위한 기본 생성자 명시
    public PartnerMember() {}

    // ==========================================================================
    // 가상 구현 없는 정규 Getter / Setter 레일 세트
    // ==========================================================================
    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getTel() {
        return tel;
    }

    public void setTel(String tel) {
        this.tel = tel;
    }

    public String getRegDate() {
        return regDate;
    }

    public void setRegDate(String regDate) {
        this.regDate = regDate;
    }

    public String getLastLogin() {
        return lastLogin;
    }

    public void setLastLogin(String lastLogin) {
        this.lastLogin = lastLogin;
    }

    public String getPreviousPayment() {
        return previousPayment;
    }

    public void setPreviousPayment(String previousPayment) {
        this.previousPayment = previousPayment;
    }

    public String getOutDate() {
        return outDate;
    }

    public void setOutDate(String outDate) {
        this.outDate = outDate;
    }

    public String getComName() {
        return comName;
    }

    public void setComName(String comName) {
        this.comName = comName;
    }
}