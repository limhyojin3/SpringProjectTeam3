package com.example.demo.community_review.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface CommentMapper {
	/**
     * [4] 댓글(Comment) 관리 - 테이블명: comment
     */
    // 특정 게시글(review_no)의 댓글 목록 조회
    List<Map<String, Object>> selectReviewCommentList(Map<String, Object> map);
    
    // 리뷰 게시판 신규 댓글 등록
    int insertReviewComment(Map<String, Object> map);
    
    // 특정 게시글(post_no)의 댓글 목록 조회
    List<Map<String, Object>> selectCommunityCommentList(Map<String, Object> map);
    
    // 커뮤니티 게시판 신규 댓글 등록
    int insertCommunityComment(Map<String, Object> map);
    
    // 댓글 수정
    int updateComment(Map<String, Object> map);

    // [댓글 삭제] 실제 데이터를 지우지 않고 삭제 상태값만 변경합니다.
    int deleteComment(Map<String, Object> map);
    
    // 좋아요 여부 확인
    int checkCommentLike(Map<String, Object> map);      
    
    // 좋아요 추가
    void insertCommentLike(Map<String, Object> map); 
    
    // 좋아요 취소
    void deleteCommentLike(Map<String, Object> map);    
    
    // 댓글 개수 갱신
    void updateCommentLikeCnt(Map<String, Object> map);  
}