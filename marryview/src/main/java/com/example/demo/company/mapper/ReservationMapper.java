package com.example.demo.company.mapper;

import java.util.List;
import java.util.Map;
import com.example.demo.company.model.Reservation;

//예약/결제 전용 매퍼 인터페이스
public interface ReservationMapper {
    // 업체별 예약 내역 전체 조회
    List<Reservation> selectReservation(Map<String, Object> map);
    
    // 신규 예약 건수 카운트
    String selectNewResCnt(Map<String, Object> map);
    
    // 특정 상품 및 날짜의 이미 예약된 시간 목록 추출
    List<String> selectBookedTimes(Map<String, Object> map);
    
    // 신규 예약 신청 데이터 삽입
    int insertReservation(Map<String, Object> map);
    
    // 일반 회원 본인의 예약 리스트 조회
    List<Reservation> selectMyReservationList(Map<String, Object> map);
    
    // 일반 회원 기준 예약 번호 목록 리스트 조회 (상태 동적 업데이트용)
    List<Integer> selectResNoList(Map<String, Object> map);
    
    // 업체 회원 기준 예약 번호 목록 리스트 조회 (상태 동적 업데이트용)
    List<Integer> selectResNoListForCompanyUser(Map<String, Object> map);
    
    // 일반 회원 예약 내역 확인 시 이용 시간 지난 건 상태 DONE/CANCEL 자동 업데이트
    int updateReservationStatus(Map<String, Object> map);
    
    // 업체 회원 예약 내역 확인 시 이용 시간 지난 건 상태 DONE/CANCEL 자동 업데이트
    int updateReservationStatusForCompany(Map<String, Object> map);
    
    // 30분 이내 미결제 대기(WAIT) 상태 예약 건 자동 CANCEL 처리
    int checkOver30minute(Map<String, Object> map);
    
    // 결제 성공 시 최종 승인 데이터 삽입 (selectKey 바인딩 포함)
    int insertPaymentFinal(Map<String, Object> map);
    
    // 결제 완료 후 예약 테이블의 예약 상태를 'CONFIRM' 및 결제번호 매핑 수정
    int updatePaymentFinal(Map<String, Object> map);
}