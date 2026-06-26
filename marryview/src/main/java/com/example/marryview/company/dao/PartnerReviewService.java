package com.example.marryview.company.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.marryview.common.Message;
import com.example.marryview.company.mapper.PartnerReviewMapper;
import com.example.marryview.company.model.Review;

@Service
public class PartnerReviewService {

	@Autowired
	private PartnerReviewMapper partnerReviewMapper;

	public HashMap<String, Object> getReviewCnt(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Map<String, Object>> list = partnerReviewMapper.selectReviewCnt(map);
			Map<String, Object> info = partnerReviewMapper.selectNewReviewCnt(map);
			
			partnerReviewMapper.updateOldNewLabels(map);
			
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
			List<Map<String, Object>> list = partnerReviewMapper.selectSimpleReviewCnt(map);
			Map<String, Object> info = partnerReviewMapper.selectNewSimpleReviewCnt(map);
			
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
			List<Review> list = partnerReviewMapper.selectReviewDetails3(map);
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
			List<Review> list = partnerReviewMapper.selectSimpleReviewDetails3(map);
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