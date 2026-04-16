package com.example.demo.admin.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.admin.model.Admin;
import com.example.demo.admin.model.User;

@Mapper
public interface AdminMapper {
	public List<Admin> selectSalesList(HashMap<String, Object> map);
	
	public List<Admin> selectClientsList(HashMap<String, Object> map);
}