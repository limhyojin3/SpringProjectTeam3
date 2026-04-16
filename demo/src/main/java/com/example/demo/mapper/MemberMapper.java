package com.example.demo.mapper;

import java.util.HashMap;
import org.apache.ibatis.annotations.Mapper;
import com.example.demo.model.Member;

@Mapper
public interface MemberMapper {
	// 회원 검색
	public Member selectMember(HashMap<String, Object> map);
}
