package com.example.demo.company.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.company.model.Company;

@Mapper
public interface CompanyMapper {
	/*
	 * // 여러개 리턴 -> selectXXXList public List<Company>
	 * selectUserList(HashMap<String, Object> map); // 한개 리턴 -> selectXXX public
	 * Company selectUser(HashMap<String, Object> map); // 삭제 public int
	 * deleteUser(HashMap<String, Object> map); // 수정 public int
	 * updateUser(HashMap<String, Object> map); // 삽입 public int
	 * insertUser(HashMap<String, Object> map);
	 */
	//updateProduct
	int updateProduct(Company product);
	
	Company selectProduct(HashMap<String, Object> map);
	
	Company selectCompany(HashMap<String, Object> map);

	public List<Company> selectProductList(HashMap<String, Object> map);
}