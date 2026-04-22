package com.example.demo.community_review.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.community_review.model.Community;

@Mapper
public interface CommunityMapper {
    
 // --- 좋아요 관련 메서드 추가 ---

	// 1. 좋아요 여부 확인 (map 안에 postNo, userId가 있어야 함)
    int checkPostLike(HashMap<String, Object> map);
    
    // 2. 좋아요 기록 추가 (map 안에 postNo, userId가 있어야 함)
    void insertPostLike(HashMap<String, Object> map);
    
    // 3. 좋아요 기록 삭제 (map 안에 postNo, userId가 있어야 함)
    void deletePostLike(HashMap<String, Object> map);
    
    // 4. 커뮤니티 테이블의 like_cnt 증감 (map 안에 postNo, amount가 있어야 함)
    void updatePostLikeCount(HashMap<String, Object> map);
    
    // 5. 게시글 추가 (객체 Community 사용)
    int insertPost(Community post);

    // 6. 게시글 리스트 조회 (조건이 없으므로 인자 생략 가능)
    List<Community> selectPostList(HashMap<String, Object> map);

    // 7. 게시글 상세 조회 (postNo 필요)
    Community selectPostById(HashMap<String, Object> map);
    
    // 8. 상세 조회 (7번이랑 유사 해서 검증해야됨.)
    Community selectPostDetail(HashMap<String, Object> map);
    
    // 9. 조회수 증가
    int updateViewCount(HashMap<String, Object> map);
    
    // 10. 게시글 삭제
    int deletePost(HashMap<String, Object> map);
    
    // 11. 게시글 수정
    int updatePost(HashMap<String, Object> map);

    // 12. 게시글 권한 설정 (수정, 삭제를 주소 직접 입력해서 이동하는 것을 방지하는 용도)
	String selectPostAuthor(HashMap<String, Object> map);

    
    
}