package com.example.demo.company.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.demo.common.Message;
import com.example.demo.company.mapper.ProductMapper;
import com.example.demo.company.model.Product;

@Service
public class ProductCommandService {

	@Autowired
	private ProductMapper productMapper;

	@Transactional(rollbackFor = Exception.class)
	public HashMap<String, Object> editProduct(Product product) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			int result = productMapper.updateProduct(product);

			if (result > 0) {
				productMapper.deleteProductTagMap(product.getProductNo());
				
				if (product.getUniqueNewTagsOnly() != null && !product.getUniqueNewTagsOnly().isEmpty()) {
					List<Integer> tagIds = productMapper.selectTagIdsByNames(product.getUniqueNewTagsOnly());
					
					if (tagIds != null && !tagIds.isEmpty()) {
						Map<String, Object> mapParam = new HashMap<String, Object>();
						mapParam.put("productNo", product.getProductNo());
						mapParam.put("tagIds", tagIds);
						
						productMapper.insertProductTagMap(mapParam);
					}
				}
				
				resultMap.put("result", "success");
				resultMap.put("message", Message.MSG_ADD);
			} else {
				resultMap.put("result", "fail");
				resultMap.put("message", "변경 대상 상품이 존재하지 않습니다.");
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	@Transactional(rollbackFor = Exception.class)
	public HashMap<String, Object> addProduct(Product product) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			int result = productMapper.insertProduct(product);

			if (result > 0 && product.getUniqueNewTagsOnly() != null && !product.getUniqueNewTagsOnly().isEmpty()) {
				List<Integer> tagIds = productMapper.selectTagIdsByNames(product.getUniqueNewTagsOnly());
				
				if (tagIds != null && !tagIds.isEmpty()) {
					Map<String, Object> mapParam = new HashMap<String, Object>();
					mapParam.put("productNo", product.getProductNo()); 
					mapParam.put("tagIds", tagIds);
					
					productMapper.insertProductTagMap(mapParam);
				}
			}

			if (result > 0) {
				resultMap.put("result", "success");
				resultMap.put("message", Message.MSG_ADD);
			} else {
				resultMap.put("result", "fail");
				resultMap.put("message", "상품 등록 처리에 실패했습니다.");
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	public HashMap<String, Object> removeProduct(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			int result = productMapper.deleteProduct(map);

			if (result > 0) {
				resultMap.put("result", "success");
				resultMap.put("message", Message.MSG_REMOVE);
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
}