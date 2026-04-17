package com.example.demo.member.mapper;

import java.util.HashMap;

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
	
	// *업체*
	// 업체 검색
	public String selectCompany(HashMap<String, Object> map);
	// 업체 회원 가입(member 삽입) 
	public int insertCompanyMember(HashMap<String, Object> map);
	// 업체 상세정보(company ) 삽입
	public int insertCompany(HashMap<String, Object> map);
	// 업체명 검색
	int selectComName(HashMap<String, Object> map);

	
}
