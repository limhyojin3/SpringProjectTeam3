package com.example.demo.company.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.common.Message;
import com.example.demo.company.mapper.CompanyMapper;
import com.example.demo.company.model.Company;

@Service
public class CompanyService {
	@Autowired 
	CompanyMapper companyMapper;
	
	// 조회 -> get, 수정 -> edit, 삽입 -> add, 삭제 -> remove
	// ex) 학생목록 : getStudentList, 학생수정 -> editStudent
	
	// === Mapper 호출 시 === 
	// 여러개 리턴 -> selectXXXList
	//	List<User> list = defaultMapper.selectUserList();
	// 한개 리턴 -> selectXXX
	//	User info = defaultMapper.selectUser();
	// 수정, 삭제, 삽입 -> updateXXX, deleteXXX, insertXXX
	//	int result = defaultMapper.updateXXX();
	
	public HashMap<String, Object> getCompany(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
//			List<User> list = defaultMapper.selectUserList(map);
//			User info = defaultMapper.selectUser(map);
//			int result = defaultMapper.updateXXX(map);
			
//			resultMap.put("list", list);
			
			Company info = companyMapper.selectCompany(map);
			
			resultMap.put("info", info);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_ADD);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;    
	}
	
	
	
}