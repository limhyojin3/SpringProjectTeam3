package com.example.marryview.company.mapper;

import java.util.List;
import java.util.Map;

import com.example.marryview.company.model.ProductInquiry;

//상품 문의 전용 매퍼 인터페이스
public interface ProductInquiryMapper {
    // 소비자가 신규 상품 문의 등록
    int insertInquiryProduct(Map<String, Object> map);
    
    // 파트너 업체용 들어온 문의 전체 리스트 출력
    List<ProductInquiry> selectInquiryProductList(Map<String, Object> map);
    
    // 문의 내역에 대한 업체 전용 답변 등록
    int insertProductInquiryAnswer(Map<String, Object> map);
    
    // 답변 등록 완료에 따른 본문 테이블 상태값 업데이트(1:답변완료)
    int updateInquiryAnsStatus(Map<String, Object> map);
    
    // 특정 문의글의 답변 완료 여부 및 답변 본문 단건 매핑 조회
    ProductInquiry selectInquiryAnsYn(Map<String, Object> map);
    
    // 작성된 기존 답변 수정하기
    int updateProductInquiryAnswer(Map<String, Object> map);
    
    // 마이페이지 로그인 회원 본인이 등록한 문의 글 목록 조회
    List<ProductInquiry> selectMyInquiryList(Map<String, Object> map);
    
    // 1:1 매치 전용 문의 내역 확인 쿼리
    ProductInquiry selectInquiry1Answer(Map<String, Object> map);
}