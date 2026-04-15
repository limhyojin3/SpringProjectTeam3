package com.example.demo.community;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface CommunityMapper {
    int insertPost(Community post);
    List<Community> selectPostList();
    Community selectPostById(Long postNo);
    
 // --- 좋아요 관련 메서드 추가 ---

    // 1. 좋아요 여부 확인
    int checkPostLike(@Param("postNo") Long postNo, @Param("userId") String userId);
    
    // 2. 좋아요 기록 추가
    void insertPostLike(@Param("postNo") Long postNo, @Param("userId") String userId);
    
    // 3. 좋아요 기록 삭제
    void deletePostLike(@Param("postNo") Long postNo, @Param("userId") String userId);
    
    // 4. 커뮤니티 테이블의 like_cnt 증감
    void updatePostLikeCount(@Param("postNo") Long postNo, @Param("amount") int amount);
}