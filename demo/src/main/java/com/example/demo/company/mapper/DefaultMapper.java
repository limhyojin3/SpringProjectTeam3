package com.example.demo.company.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.company.model.User;

@Mapper
public interface DefaultMapper {
	// 여러개 리턴 -> selectXXXList
	public List<User> selectUserList(HashMap<String, Object> map);
	// 한개 리턴 -> selectXXX
	public User selectUser(HashMap<String, Object> map);
	// 삭제 
	public int deleteUser(HashMap<String, Object> map);
	// 수정
	public int updateUser(HashMap<String, Object> map);
	// 삽입 
	public int insertUser(HashMap<String, Object> map);
}