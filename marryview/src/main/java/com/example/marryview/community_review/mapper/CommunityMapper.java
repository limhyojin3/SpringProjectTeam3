package com.example.marryview.community_review.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;

import com.example.marryview.community_review.model.Community;

@Mapper
public interface CommunityMapper {

    /* ==========================================================
     * [1] 게시글 조회 (Read)
     * ========================================================== */

    /** 전체 게시글 리스트 조회 (검색 및 페이지네이션 포함) */
    List<Community> selectPostList(Map<String, Object> map);

    /** 전체 게시글 개수 조회 (페이지네이션용) */
    int selectPostCount(Map<String, Object> map);

    /** 게시글 상세 조회 */
    Community selectPostDetail(Map<String, Object> map);

    /** 알림 등을 위한 특정 게시글 제목 조회 */
    String getPostTitle(String targetId);


    /* ==========================================================
     * [2] 게시글 관리 (CUD)
     * ========================================================== */

    /** 신규 게시글 등록 */
    int insertPost(Community post);

    /** 게시글 수정 */
    int updatePost(Map<String, Object> map);

    /** 게시글 삭제 (is_deleted 필드 업데이트 또는 실제 삭제) */
    int deletePost(Map<String, Object> map);

    /** 조회수 증가 */
    int updateViewCount(Map<String, Object> map);


    /* ==========================================================
     * [3] 좋아요 기능 (Like)
     * ========================================================== */

    /** 특정 사용자의 게시글 좋아요 여부 확인 */
    int checkPostLike(Map<String, Object> map);

    /** 좋아요 기록 추가 */
    void insertPostLike(Map<String, Object> map);

    /** 좋아요 기록 삭제 */
    void deletePostLike(Map<String, Object> map);

    /** 게시글 테이블의 좋아요 수(like_cnt) 증감 */
    void updatePostLikeCount(Map<String, Object> map);


    /* ==========================================================
     * [4] 권한 및 보안 (Security)
     * ========================================================== */

    /** 게시글 작성자 ID 조회 (수정/삭제 권한 체크용) */
    String selectPostAuthor(Map<String, Object> map);
	// 인기 게시글 목록 조회 메서드
	List<Map<String, Object>> selectPopularPostList();
}