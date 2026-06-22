package com.example.demo.company.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.common.Message;
import com.example.demo.company.mapper.CompanyMapper;
import com.example.demo.company.model.Company;
import com.example.demo.company.model.PartnerMember; // 🎯 수혈 완료: 새로 신설한 정규 파트너 회원 도메인 임포트
import com.example.demo.company.model.Review;

@Service
public class CompanyService { 

	@Autowired
	private CompanyMapper companyMapper;

	public HashMap<String, Object> getCompany(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			// 🎯 자바 코어 리팩토링 완결: 구형 Company 대신 신상 가방인 PartnerMember로 완벽 일치
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

	public HashMap<String, Object> getReviewCnt(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Map<String, Object>> list = companyMapper.selectReviewCnt(map);
			Map<String, Object> info = companyMapper.selectNewReviewCnt(map);
			
			// 리뷰 라벨 업데이트 (현재시점에서 3일이상 지난거 0으로)
			companyMapper.updateOldNewLabels(map);
			
			resultMap.put("list", list);
			resultMap.put("info", info);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_REMOVE);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	public HashMap<String, Object> getSimpleReviewCnt(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Map<String, Object>> list = companyMapper.selectSimpleReviewCnt(map);
			Map<String, Object> info = companyMapper.selectNewSimpleReviewCnt(map);
			
			resultMap.put("list", list);
			resultMap.put("info", info);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_REMOVE);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	
	public HashMap<String, Object> getReviewDetails3(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Review> list = companyMapper.selectReviewDetails3(map);

			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_REMOVE);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	public HashMap<String, Object> getSimpleReviewDetails3(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Review> list = companyMapper.selectSimpleReviewDetails3(map);
			
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_REMOVE);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
}