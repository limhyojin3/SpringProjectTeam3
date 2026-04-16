package com.example.demo.member.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.member.model.Member;
import com.example.demo.member.model.User;

@Mapper
public interface MemberMapper {
	// 회원 검색
	public Member selectMember(HashMap<String, Object> map);
	// 업체 검색
	public String selectCompany(HashMap<String, Object> map);
	// 일반 회원 가입(삽입) 
	public int insertMember(HashMap<String, Object> map);
	// 일반 회원 상세정보(user detail) 삽입
	public int insertUserDetail(HashMap<String, Object> map);
	// 아이디 중복 체크
	int selectUserId(HashMap<String, Object> map);
	
}
