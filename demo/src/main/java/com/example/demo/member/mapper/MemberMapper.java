package com.example.demo.member.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.member.model.Member;

@Mapper
public interface MemberMapper {
	// *일반 회원*
	// 회원 검색
	public Member selectMember(HashMap<String, Object> map);
	// 일반 회원 가입(member 삽입) 
	public int insertMember(HashMap<String, Object> map);
	// 일반 회원 상세정보(user detail) 삽입
	public int insertUserDetail(HashMap<String, Object> map);
	// 아이디 중복 체크
	int selectUserId(HashMap<String, Object> map);
	// 이메일 중복 체크
	int selectUserEmail(HashMap<String, Object> map);
	// 유저 상세 정보 조회 (내 정보 수정)
	Member selectMemberInfo(String userId);
	// 유저 내 정보 수정(멤버 테이블)
	public int updateMember(HashMap<String, Object> map);
	// 유저 내 정보 수정(유저 디테일 테이블)
	public int updateUserDetail(HashMap<String, Object> map);
	// 유저 탈퇴 (status 상태를 WITHDRAWN로 변경)
	public int updateUserStatus(HashMap<String, Object> map);
	// 유저 쿠폰 조회
	List<HashMap<String, Object>> selectUserCouponList(String userId);
	// 쿠폰 유효성 조회
	Map<String, Object> checkValidCoupon(HashMap<String, Object> map);
	// 쿠폰 중복 발급 조회
	int checkDuplicateCoupon(HashMap<String, Object> map);
	// 쿠폰 등록
	int insertUserCoupon(HashMap<String, Object> map);
	
	// *업체*
	// 업체 검색
	public String selectCompany(HashMap<String, Object> map);
	// 업체 회원 가입(member 삽입) 
	public int insertCompanyMember(HashMap<String, Object> map);
	// 업체 상세정보(company ) 삽입
	public int insertCompany(HashMap<String, Object> map);
	// 업체명 검색
	int selectComName(HashMap<String, Object> map);
	
	// *아이디/비밀번호 찾기*
	// 이름+번호 인증을 통해 해당 id가 있는 지 조회
	String findUserId(HashMap<String, Object> map);
	// 아이디+번호 인증을 통해 해당 pwd가 있는 지 조회
	int checkUserForPw(HashMap<String, Object> map);
	// 비밀 번호 업데이트
	int updatePassword(HashMap<String, Object> map);
	
}
