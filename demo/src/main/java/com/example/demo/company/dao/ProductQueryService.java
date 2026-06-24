package com.example.demo.company.dao;

import java.util.HashMap;
import java.util.List;
import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.common.Message;
import com.example.demo.company.mapper.ProductMapper;
import com.example.demo.company.model.Product;

@Service
public class ProductQueryService {

	@Autowired
	private ProductMapper productMapper;

	public HashMap<String, Object> getProductList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			if (map.get("tags") != null && !map.get("tags").toString().trim().isEmpty()) {
				String tagsStr = map.get("tags").toString();
				tagsStr = tagsStr.replace("[", "").replace("]", "").replace("\"", "");
				
				if (!tagsStr.trim().isEmpty()) {
					String[] tagsArray = tagsStr.split(",");
					List<String> tagList = new ArrayList<>();
					for (String t : tagsArray) {
						if (!t.trim().isEmpty()) {
							tagList.add(t.trim());
						}
					}
					if (!tagList.isEmpty()) {
						map.put("tagList", tagList);
						map.put("tagSize", tagList.size());
					}
				}
			}

			List<Product> list = productMapper.selectProductList(map);

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

	public HashMap<String, Object> getProduct(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			Product info = productMapper.selectProduct(map);

			List<String> currentProductTags = new ArrayList<>();
			if (info != null && info.getTag() != null && !info.getTag().trim().isEmpty()) {
				String[] tags = info.getTag().split(",");
				for (String t : tags) {
					currentProductTags.add(t.trim());
				}
			}
						
			resultMap.put("tagList", currentProductTags);
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