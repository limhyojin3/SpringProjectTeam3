package com.example.marryview.community_review.controller; 

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.example.marryview.community_review.dao.CommentService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/api/comment")
public class CommentController {

    @Autowired
    private CommentService commentService;
    
    private final Gson gson = new Gson(); 
    
    //  리뷰 댓글 목록 조회
    @PostMapping("/review-list.dox")
    public String selectReviewCommentList(@RequestBody Map<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        // Service에서 목록을 가져옵니다.
        resultMap.put("list", commentService.getReviewCommentList(map));
        resultMap.put("result", "success");
        return gson.toJson(resultMap);
    }
 
    @PostMapping("/review-add.dox")
    public String addReviewComment(
            @RequestParam Map<String, Object> map,
            @RequestParam(value="files", required=false) MultipartFile[] files
    ) {

        int n = commentService.addReviewComment(map, files);

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("result", n > 0 ? "success" : "fail");

        return gson.toJson(resultMap);
    }
    
    //  커뮤 댓글 목록 조회
    @PostMapping("/comm-list.dox")
    public String selectCommunityCommentList(@RequestBody Map<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        // Service에서 목록을 가져옵니다.
        resultMap.put("list", commentService.getCommunityCommentList(map));
        resultMap.put("result", "success");
        return gson.toJson(resultMap);
    }
 
    // 커뮤 댓글 등록
    @PostMapping("/comm-add.dox")
    public String addCommunityComment(
            @RequestParam Map<String, Object> map,
            @RequestParam(value="files", required=false) MultipartFile[] files
    ) {

        int n = commentService.addCommunityComment(map, files);

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("result", n > 0 ? "success" : "fail");

        return gson.toJson(resultMap);
    }

    // 수정
    @PostMapping("/update.dox")
    public String updateComment(@RequestBody Map<String, Object> map, HttpSession session) {
    	
    	// 1. 세션에서 현재 로그인한 사용자의 아이디를 가져옵니다.
        String sessionId = (String) session.getAttribute("sessionId");
       
        
        // 2. XML 매퍼의 #{userId}와 일치하도록 map에 담아줍니다.
        map.put("userId", sessionId);
        
        int n = commentService.editComment(map);
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("result", n > 0 ? "success" : "fail");
        return new Gson().toJson(resultMap);
    }
 
    // 삭제
    @PostMapping("/remove.dox")
    public String removeComment(@RequestBody Map<String, Object> map) {
        int n = commentService.removeComment(map);
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("result", n > 0 ? "success" : "fail");
        return new Gson().toJson(resultMap);
    }
    
    @PostMapping("/like.dox")
    public Map<String, Object> toggleLike(@RequestBody Map<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            String status = commentService.toggleCommentLike(map);
            resultMap.put("result", "success");
            resultMap.put("status", status); // 'liked' 또는 'unliked' 반환
        } catch (Exception e) {
            resultMap.put("result", "error");
        }
        return resultMap;
    }
}