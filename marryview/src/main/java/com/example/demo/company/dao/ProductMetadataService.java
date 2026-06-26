package com.example.demo.company.dao;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.common.Message;
import com.example.demo.company.mapper.ProductMapper;
import com.example.demo.company.model.Product;

@Service
public class ProductMetadataService {

	@Autowired
	private ProductMapper productMapper;

	public HashMap<String, Object> getTagAndProductList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<String> taglist = productMapper.selectTagList(map);
			List<Product> productListForTag = productMapper.selectProductListForTag(map);

			resultMap.put("productListForTag", productListForTag);
			resultMap.put("taglist", taglist);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_REMOVE);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	public HashMap<String, Object> getTagList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<String> tagList = productMapper.selectTagList(map);

			resultMap.put("tagList", tagList);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_ADD);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	@SuppressWarnings("unchecked")
	public HashMap<String, Object> getCategoryTree() {
		LinkedHashMap<String, Object> categoryTree = new LinkedHashMap<String, Object>();
		try {
			List<HashMap<String, Object>> categories = productMapper.selectDistinctCategories();
			List<HashMap<String, Object>> tagsWithMedium = productMapper.selectAllTagsWithMedium();

			HashMap<String, List<String>> tagMapByMedium = new HashMap<String, List<String>>();
			for (HashMap<String, Object> row : tagsWithMedium) {
				String medium = (String) row.get("medium_category");
				String tag = (String) row.get("tag");
				if (medium != null && tag != null) {
					if (!tagMapByMedium.containsKey(medium)) {
						tagMapByMedium.put(medium, new ArrayList<String>());
					}
					tagMapByMedium.get(medium).add(tag);
				}
			}

			for (HashMap<String, Object> row : categories) {
				String large = (String) row.get("large_category");
				String medium = (String) row.get("medium_category");
				if (large == null || medium == null) continue;

				if (!categoryTree.containsKey(large)) {
					HashMap<String, Object> largeNode = new HashMap<String, Object>();
					largeNode.put("mediums", new ArrayList<String>());
					largeNode.put("tags", new HashMap<String, List<String>>());
					categoryTree.put(large, largeNode);
				}

				HashMap<String, Object> largeNode = (HashMap<String, Object>) categoryTree.get(large);
				List<String> mediumsList = (List<String>) largeNode.get("mediums");
				if (!mediumsList.contains(medium)) {
					mediumsList.add(medium);
				}

				HashMap<String, List<String>> tagsNode = (HashMap<String, List<String>>) largeNode.get("tags");
				List<String> tagsForThisMedium = tagMapByMedium.get(medium);
				if (tagsForThisMedium == null) {
					tagsForThisMedium = new ArrayList<String>();
				}
				tagsNode.put(medium, tagsForThisMedium);
			}
		} catch (Exception e) {
			System.out.println("동적 카테고리 트리 가공 예외 발생: " + e.getMessage());
		}
		return categoryTree;
	}
}