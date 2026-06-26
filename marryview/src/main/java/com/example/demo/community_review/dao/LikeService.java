package com.example.demo.community_review.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.demo.community_review.mapper.CommunityMapper;
import com.example.demo.community_review.mapper.ReviewMapper;
import com.example.demo.community_review.model.Like;

@Service
public class LikeService {

    @Autowired
    private ReviewMapper reviewMapper;

    @Autowired
    private CommunityMapper communityMapper;

    @Transactional
    public boolean toggleLike(HashMap<String, Object> map,Like likeDto) {
        
        String type = likeDto.getType();
        

        // 1. 리뷰(REVIEW) 좋아요 처리
        if ("REVIEW".equals(type)) {
        	// 커뮤니티와 마찬가지로 map을 그대로 사용합니다.
            // XML에서 #{targetId}, #{userId}를 쓰고 있다면 map에 담겨있어야 합니다.
            int count = reviewMapper.checkReviewLike(map);
            if (count == 0) {
                reviewMapper.insertReviewLike(map);
                reviewMapper.updateReviewLikeCount(map);
                return true; // 좋아요 성공
            } else {
                reviewMapper.deleteReviewLike(map);
                reviewMapper.updateReviewLikeCount(map);
                return false; // 좋아요 취소
            }
        } 
        
        // 2. 커뮤니티(COMMUNITY) 좋아요 처리
        else if ("COMMUNITY".equals(type)) {
            int count = communityMapper.checkPostLike(map);
            
            if (count == 0) {
                communityMapper.insertPostLike(map);
                map.put("amount", 1);
                communityMapper.updatePostLikeCount(map);
                return true; // 좋아요 성공
            } else {
                communityMapper.deletePostLike(map);
                map.put("amount", -1);
                communityMapper.updatePostLikeCount(map);
                return false; // 좋아요 취소
            }
        }
        
        // 타입이 둘 다 아니면 false 리턴
        return false;
    }
}