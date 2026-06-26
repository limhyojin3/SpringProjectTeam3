package com.example.demo.company.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.demo.common.Message;
import com.example.demo.company.mapper.ProductInquiryMapper;
import com.example.demo.company.model.ProductInquiry;
import com.example.demo.admin.dao.NotificationService;

@Service
public class ProductInquiryService {

	@Autowired
	private ProductInquiryMapper productInquiryMapper;

	@Autowired
	private NotificationService notificationService;
	
	public HashMap<String, Object> addInquiryProduct(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			int result = productInquiryMapper.insertInquiryProduct(map);

			if (result > 0) {
				notificationService.createProductInquiryReceived(map.get("inquiryNo"));
				
				resultMap.put("result", "success");
				resultMap.put("message", Message.MSG_ADD);
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	
	public HashMap<String, Object> getInquiryProductList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<ProductInquiry> list = productInquiryMapper.selectInquiryProductList(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_ADD);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	@Transactional(rollbackFor = Exception.class)
	public HashMap<String, Object> addProductInquiryAnswer(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			// 1. 문의 내용에 답변한적 없는 경우
			if ("0".equals(String.valueOf(map.get("inquiryAns")))) {
				int result = productInquiryMapper.insertProductInquiryAnswer(map);
				int result1 = productInquiryMapper.updateInquiryAnsStatus(map);

				if (result > 0 && result1 > 0) {
					notificationService.createProductInquiryAnswered(map.get("inquiryNo"));
					
					resultMap.put("result", "success");
					resultMap.put("message", Message.MSG_ADD);
				}
			} 
			// 2. 문의 내용에 답변한적 있는 경우 (수정하는 상황)
			else {
				int result = productInquiryMapper.updateProductInquiryAnswer(map);
				if (result > 0) {
					resultMap.put("result", "success");
					resultMap.put("message", Message.MSG_ADD);
				}
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	
	public HashMap<String, Object> getInquiryAnsYn(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			ProductInquiry info = productInquiryMapper.selectInquiryAnsYn(map);
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

	public HashMap<String, Object> getMyInquiryList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<ProductInquiry> list = productInquiryMapper.selectMyInquiryList(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_ADD);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	
	public HashMap<String, Object> getInquiry1Answer(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			ProductInquiry info = productInquiryMapper.selectInquiry1Answer(map);
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
}