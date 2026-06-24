package com.example.demo.company.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import com.example.demo.company.model.Review;

@Mapper
public interface PartnerReviewMapper {

	List<Map<String, Object>> selectReviewCnt(HashMap<String, Object> map);

	List<Map<String, Object>> selectSimpleReviewCnt(HashMap<String, Object> map);

	Map<String, Object> selectNewReviewCnt(HashMap<String, Object> map);

	Map<String, Object> selectNewSimpleReviewCnt(HashMap<String, Object> map);

	List<Review> selectReviewDetails3(HashMap<String, Object> map);

	List<Review> selectSimpleReviewDetails3(HashMap<String, Object> map);

	void updateOldNewLabels(HashMap<String, Object> map);
}