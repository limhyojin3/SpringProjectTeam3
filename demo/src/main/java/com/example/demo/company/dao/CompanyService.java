package com.example.demo.company.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.common.Message;
import com.example.demo.company.mapper.CompanyMapper;
import com.example.demo.company.model.Company;
import com.example.demo.company.model.Review;

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

	public HashMap<String, Object> getProductList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
//			List<User> list = defaultMapper.selectUserList(map);
//			User info = defaultMapper.selectUser(map);
//			int result = defaultMapper.updateXXX(map);
			
//			resultMap.put("list", list);
			
			List<Company> list = companyMapper.selectProductList(map);
			
			resultMap.put("list", list);
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
	
	public HashMap<String, Object> getProduct(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
//			List<User> list = defaultMapper.selectUserList(map);
//			User info = defaultMapper.selectUser(map);
//			int result = defaultMapper.updateXXX(map);
			
//			resultMap.put("list", list);
			
			Company info = companyMapper.selectProduct(map);
			
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
	//editProduct
	public HashMap<String, Object> editProduct(Company product) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
//			List<User> list = defaultMapper.selectUserList(map);
//			User info = defaultMapper.selectUser(map);
//			int result = defaultMapper.updateXXX(map);
			
//			resultMap.put("list", list);
			
			int result = companyMapper.updateProduct(product);
			
			if(result > 0) {
				resultMap.put("result", "success");
				resultMap.put("message", Message.MSG_ADD);
			}
			
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;  
	}
	//insertProduct
	public HashMap<String, Object> addProduct(Company product) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
//			List<User> list = defaultMapper.selectUserList(map);
//			User info = defaultMapper.selectUser(map);
//			int result = defaultMapper.updateXXX(map);
			
//			resultMap.put("list", list);
			
			int result = companyMapper.insertProduct(product);
			
			if(result > 0) {
				resultMap.put("result", "success");
				resultMap.put("message", Message.MSG_ADD);
			}
			
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;  
	}
	//Company info = companyService.getCompanyInfo(userId);
	public Company getCompanyInfo(String userId) {
		try {
//			List<User> list = defaultMapper.selectUserList(map);
//			User info = defaultMapper.selectUser(map);
//			int result = defaultMapper.updateXXX(map);
			
//			resultMap.put("list", list);
			
			Company info = companyMapper.selectCompanyByUserId(userId);
			return info;
			
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
		}
		return null;
		
	}
	public HashMap<String, Object> removeProduct(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
//			List<User> list = defaultMapper.selectUserList(map);
//			User info = defaultMapper.selectUser(map);
			int result = companyMapper.deleteProduct(map);
			
			if(result > 0) {
				resultMap.put("result", "success");
				resultMap.put("message", Message.MSG_REMOVE);
			}
			
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;  
	} 
	
	//List<Company> selectReservation(HashMap<String, Object> map);
	public HashMap<String, Object> getReservation(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
//			List<User> list = defaultMapper.selectUserList(map);
//			User info = defaultMapper.selectUser(map);
			List<Company> list = companyMapper.selectReservation(map);
			
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_REMOVE);
			
			
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;  
	} 
}