package com.example.demo.admin.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import com.example.demo.admin.mapper.AdminMapper;
import com.example.demo.admin.model.Admin;
import com.example.demo.common.Message;

@Service
public class AdminService {
	@Autowired
	AdminMapper adminMapper;

	public HashMap<String, Object> getSalesList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Admin> list = adminMapper.selectSalesList(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	public HashMap<String, Object> getclientsList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Admin> list = adminMapper.selectClientsList(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	public HashMap<String, Object> getReviewList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Admin> list = adminMapper.selectReviewList(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	public HashMap<String, Object> getReportList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Admin> list = adminMapper.selectReportList(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	public HashMap<String, Object> getPassList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Admin> list = adminMapper.selectPassList(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	public HashMap<String, Object> getPassInfo(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			Admin info = adminMapper.selectPassInfo(map);
			resultMap.put("info", info);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	public int getPriceInfo(int passNo) {
        return adminMapper.selectPriceInfo(passNo);
    }
	
	public boolean getPayInfo(HashMap<String, Object> map) {
		
		String userId = (String) map.get("userId");
		String itemName = (String) map.get("itemName");
		int passNo = Integer.parseInt(String.valueOf(map.get("passNo").toString()));
	    int amount = Integer.parseInt(String.valueOf(map.get("amount").toString()));
	    
		// 1. 최소 검증
		if (userId == null || userId.isEmpty()) {
			return false;
		}
		if (amount <= 0) {
			return false;
		}
		// 2. DB 가격 조회
		int dbPrice = adminMapper.selectPriceInfo(passNo);
		// 3. 비교
		return dbPrice == amount;
	}
	
	@Transactional
	public void completePayment(HashMap<String, Object> map) {
	    adminMapper.insertPayment(map);
	    adminMapper.insertPaymentPass(map);
	}
	
	public int addPayment(HashMap<String, Object> map) {
	    return adminMapper.insertPayment(map);
	}

	public int addPaymentPass(HashMap<String, Object> map) {
	    return adminMapper.insertPaymentPass(map);
	}
	
	public String getToken() throws Exception {

	    RestTemplate restTemplate = new RestTemplate();

	    HashMap<String, String> body = new HashMap<>();
	    body.put("imp_key", "");
	    body.put("imp_secret", "");

	    ResponseEntity<HashMap> response = restTemplate.postForEntity(
	        "https://api.iamport.kr/users/getToken",
	        body,
	        HashMap.class
	    );

	    HashMap<String, Object> res = (HashMap<String, Object>) response.getBody().get("response");

	    return (String) res.get("access_token");
	}
	
	public HashMap<String, Object> getPaymentByImpUid(String impUid) throws Exception {

	    String token = getToken();

	    HttpHeaders headers = new HttpHeaders();
	    headers.set("Authorization", token);

	    HttpEntity<?> entity = new HttpEntity<>(headers);

	    RestTemplate restTemplate = new RestTemplate();

	    ResponseEntity<HashMap> response = restTemplate.exchange(
	        "https://api.iamport.kr/payments/" + impUid,
	        HttpMethod.GET,
	        entity,
	        HashMap.class
	    );

	    HashMap<String, Object> body = response.getBody();
	    return (HashMap<String, Object>) body.get("response");
	}
	
}