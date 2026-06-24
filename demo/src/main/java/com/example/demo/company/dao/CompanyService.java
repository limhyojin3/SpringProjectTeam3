package com.example.demo.company.dao;

import java.util.HashMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.common.Message;
import com.example.demo.company.mapper.CompanyMapper;
import com.example.demo.company.model.Company;
import com.example.demo.company.model.PartnerMember;

@Service
public class CompanyService {

	@Autowired
	private CompanyMapper companyMapper;

	public HashMap<String, Object> getCompany(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			PartnerMember info = companyMapper.selectCompany(map);
			resultMap.put("info", info);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_ADD);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	public Company getCompanyInfo(String userId) {
		try {
			String companyNoStr = companyMapper.selectCompanyByUserId(userId);
			if (companyNoStr != null) {
				Company info = new Company();
				info.setCompanyNo(Long.parseLong(companyNoStr));
				info.setUserId(userId);
				return info;
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
		return null;
	}
}