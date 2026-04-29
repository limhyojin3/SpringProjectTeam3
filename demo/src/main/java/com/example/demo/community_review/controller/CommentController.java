package com.example.demo.community_review.controller; 

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.community_review.dao.CommentService;
import com.google.gson.Gson;

@RestController
@RequestMapping("/api/comment")
public class CommentController {

    @Autowired
    private CommentService commentService;
    
    private final Gson gson = new Gson(); 
    
    //  리뷰 댓글 목록 조회
    @PostMapping("/Review-list.dox")
    public String selectReviewCommentList(@RequestBody Map<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        // Service에서 목록을 가져옵니다.
        resultMap.put("list", commentService.getReviewCommentList(map));
        resultMap.put("result", "success");
        return gson.toJson(resultMap);
    }
 
    // 리뷰 댓글 등록
    @PostMapping("/Review-add.dox")
    public String addReviewComment(@RequestBody Map<String, Object> map) {
        int n = commentService.addReviewComment(map);
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("result", n > 0 ? "success" : "fail");
        return new Gson().toJson(resultMap);
    }
    
    //  커뮤 댓글 목록 조회
    @PostMapping("/Comm-list.dox")
    public String selectCommunityCommentList(@RequestBody Map<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        // Service에서 목록을 가져옵니다.
        resultMap.put("list", commentService.getCommunityCommentList(map));
        resultMap.put("result", "success");
        return gson.toJson(resultMap);
    }
 
    // 커뮤 댓글 등록
    @PostMapping("/Comm-add.dox")
    public String addCommunityComment(@RequestBody Map<String, Object> map) {
        int n = commentService.addCommunityComment(map);
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("result", n > 0 ? "success" : "fail");
        return new Gson().toJson(resultMap);
    }

    // 수정
    @PostMapping("/update.dox")
    public String updateComment(@RequestBody Map<String, Object> map) {
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