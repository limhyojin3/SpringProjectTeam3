package com.example.marryview.community_review.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.web.multipart.MultipartFile;

@Mapper
public interface CommentMapper {

    /* ==========================================================
     * [1] 댓글 조회 (Select)
     * ========================================================== */
    
    /** 리뷰 게시글(review_no)별 댓글 목록 조회 */
    List<Map<String, Object>> selectReviewCommentList(Map<String, Object> map);
    
    /** 커뮤니티 게시글(post_no)별 댓글 목록 조회 */
    List<Map<String, Object>> selectCommunityCommentList(Map<String, Object> map);
    
    /** 알림 등을 위한 특정 댓글 내용 조회 */
    String getCommentContent(String targetId);


    /* ==========================================================
     * [2] 댓글 작성 (Insert)
     * ========================================================== */

    /** 리뷰 게시판 신규 댓글 등록 */
    int insertReviewComment(Map<String, Object> map);
    
    /** 커뮤니티 게시판 신규 댓글 등록 */
    int insertCommunityComment(Map<String, Object> map);


    /* ==========================================================
     * [3] 댓글 수정 및 삭제 (Update/Delete)
     * ========================================================== */

    /** 댓글 내용 수정 */
    int updateComment(Map<String, Object> map);

    /** 댓글 논리 삭제 (is_deleted 상태값 변경) */
    int deleteComment(Map<String, Object> map);


    /* ==========================================================
     * [4] 좋아요 기능 (Like)
     * ========================================================== */
    
    /** 특정 사용자의 댓글 좋아요 여부 확인 (0 또는 1) */
    int checkCommentLike(Map<String, Object> map);      
    
    /** 댓글 좋아요 추가 */
    void insertCommentLike(Map<String, Object> map); 
    
    /** 댓글 좋아요 취소 */
    void deleteCommentLike(Map<String, Object> map);    
    
    /** 댓글 테이블의 좋아요 합계(like_cnt) 갱신 */
    void updateCommentLikeCnt(Map<String, Object> map);  
}