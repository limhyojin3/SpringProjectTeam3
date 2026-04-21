package com.example.demo.admin.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.admin.model.Admin;

@Mapper
public interface AdminMapper {
	public List<Admin> selectSalesList(HashMap<String, Object> map);

	public List<Admin> selectClientsList(HashMap<String, Object> map);

	public List<Admin> selectReviewList(HashMap<String, Object> map);

	public List<Admin> selectReportList(HashMap<String, Object> map);
	
	public List<Admin> selectPassList(HashMap<String, Object> map);
	
	public Admin selectPassInfo(HashMap<String, Object> map);

}