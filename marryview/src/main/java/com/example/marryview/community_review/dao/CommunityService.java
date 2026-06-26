package com.example.marryview.community_review.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.marryview.common.Message;
import com.example.marryview.community_review.mapper.CommunityMapper;
import com.example.marryview.community_review.model.Community;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Service
public class CommunityService {

    @Autowired
    private CommunityMapper communityMapper;

    // 게시글 등록
    public String addPost(Community post) { // 이름은 팀에서 정한 걸로 통일 (예: addPost)
        try {
            // DB 저장 시도
            int result = communityMapper.insertPost(post);
            
            // 성공 시 '등록되었습니다', 실패 시 '오류가 발생했습니다' 메시지 반환
            return (result > 0) ? Message.MSG_ADD : Message.MSG_ERR;
        } catch (Exception e) {
            // 서버 에러(DB 연결 끊김 등) 발생 시 로그 출력 및 서버 에러 메시지 반환
            e.printStackTrace();
            return Message.MSG_SERVER_ERR;
        }
    }
    // 게시글 삭제
    public int removePost(HashMap<String, Object> map) {
        // 성공하면 1, 실패하면 0을 리턴함
        return communityMapper.deletePost(map);
    }
    
    // 페이지네이션
    public int getPostCount(HashMap<String, Object> map) {
        
        return communityMapper.selectPostCount(map);
    }
    
    // 게시글 수정
    public int editPost(HashMap<String, Object> map) {
        try {
            return communityMapper.updatePost(map);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
    

    // 목록 조회
    public List<Community> getList(HashMap<String, Object> map) {
    	// 인자 없이 호출해도 매퍼와 XML이 연결됩니다.
        return communityMapper.selectPostList(map);
    }
    
    public Community getPostDetail(HashMap<String, Object> map) {
        return communityMapper.selectPostDetail(map);
    }

    
    // 좋아요 토글 (중요!)
    public int toggleLike(HashMap<String, Object> map) {
        // 1. 이미 좋아요를 눌렀는지 확인 (checkPostLike)
        int check = communityMapper.checkPostLike(map);
        
        if (check == 0) {
            // 2. 안 눌렀다면 -> 추가(insert) 후 카운트 +1(update)
            communityMapper.insertPostLike(map);
            map.put("amount", 1);
            communityMapper.updatePostLikeCount(map);
            return 1; // 좋아요 성공 상태
        } else {
            // 3. 이미 눌렀다면 -> 삭제(delete) 후 카운트 -1(update)
            communityMapper.deletePostLike(map);
            map.put("amount", -1);
            communityMapper.updatePostLikeCount(map);
            return 0; // 좋아요 취소 상태
        }
    }
    
    // 상세 조회 (조회수 중복 방지 로직 포함)
    public Community getPostDetail(HashMap<String, Object> map, HttpServletRequest request) {
        HttpSession session = request.getSession();
        String sessionId = (String) session.getAttribute("userId");
        int postNo = Integer.parseInt(map.get("postNo").toString());

        // 1. 세션에서 '내가 읽은 글 목록' 확인
        List<Integer> viewedList = (List<Integer>) session.getAttribute("viewedList");
        if (viewedList == null) {
            viewedList = new ArrayList<>();
        }

        // 2. 먼저 글 정보를 가져와서 작성자 확인
        Community post = communityMapper.selectPostDetail(map);
        
        if (post != null) {
            // --- [변수 선언 추가 시작] ---
            // 게시글 작성자와 현재 세션 아이디가 같은지 확인
            boolean isWriter = post.getUserId() != null && post.getUserId().equals(sessionId);
            
            // 이미 세션 주머니(viewedList)에 이 글 번호가 들어있는지 확인
            boolean isAlreadyViewed = viewedList.contains(postNo);
            // --- [변수 선언 추가 끝] ---

            if (!isWriter && !isAlreadyViewed) {
                // [1] DB의 조회수를 먼저 올린다!
                communityMapper.updateViewCount(map);

                // [2] 세션에 기록한다.
                viewedList.add(postNo);
                session.setAttribute("viewedList", viewedList);
            }
        }

        // [3] '그 다음에' 다시 정보를 가져오거나, 조회수가 올라갔다면 객체에 직접 세팅
        // (효율을 위해 아래처럼 직접 세팅하는 방식이 좋습니다)
        if (post != null && !viewedList.contains(postNo) == false && !post.getUserId().equals(sessionId)) {
             // 위 로직이 복잡하면 그냥 이미지 90번 라인처럼 한 번 더 select하셔도 됩니다.
             post = communityMapper.selectPostDetail(map); 
        }
        return post;
    }
    
 // 게시글 작성자 ID 조회
    public String getPostAuthor(HashMap<String, Object> map) {
        // Mapper를 통해 해당 게시글의 정보를 가져옵니다.
        // 기존에 만들어둔 getPostDetail과 로직이 거의 비슷합니다.
        String authorId = communityMapper.selectPostAuthor(map);
        
        if (authorId != null) {
            return authorId; // 작성자 ID만 반환
        }
        return null;
    }
    
    public List<Map<String, Object>> selectPopularPostList() {
        return communityMapper.selectPopularPostList();
    }
    
}