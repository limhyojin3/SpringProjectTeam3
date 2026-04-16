package com.example.demo.common.like;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.demo.community.CommunityMapper;
import com.example.demo.review.ReviewMapper;

@Service
public class LikeService {

    @Autowired
    private ReviewMapper reviewMapper;

    @Autowired
    private CommunityMapper communityMapper;

    @Transactional
    public boolean toggleLike(LikeDTO likeDto) {
        
        String type = likeDto.getType();
        Long targetId = likeDto.getTargetId();
        String userId = likeDto.getUserId();
        

        // 1. 리뷰(REVIEW) 좋아요 처리
        if ("REVIEW".equals(type)) {
            int count = reviewMapper.checkReviewLike(targetId, userId);
            
            if (count == 0) {
                reviewMapper.insertReviewLike(targetId, userId);
                reviewMapper.updateReviewLikeCount(targetId, 1);
                return true; // 좋아요 성공
            } else {
                reviewMapper.deleteReviewLike(targetId, userId);
                reviewMapper.updateReviewLikeCount(targetId, -1);
                return false; // 좋아요 취소
            }
        } 
        
        // 2. 커뮤니티(COMMUNITY) 좋아요 처리
        else if ("COMMUNITY".equals(type)) {
            int count = communityMapper.checkPostLike(targetId, userId);
            
            if (count == 0) {
                communityMapper.insertPostLike(targetId, userId);
                communityMapper.updatePostLikeCount(targetId, 1);
                return true; // 좋아요 성공
            } else {
                communityMapper.deletePostLike(targetId, userId);
                communityMapper.updatePostLikeCount(targetId, -1);
                return false; // 좋아요 취소
            }
        }
        
        // 타입이 둘 다 아니면 false 리턴
        return false;
    }
}