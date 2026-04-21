package com.example.demo.community_review.controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.community_review.dao.CommentService;
import com.example.demo.community_review.dao.ReviewService;
import com.example.demo.community_review.model.Comment;
import com.google.gson.Gson;

@RestController
@RequestMapping("/api/comment")
public class CommentController {

    @Autowired
    private CommentService commentService;
    
    @Autowired
    private ReviewService reviewService;
    
    private final Gson gson = new Gson();

    // 댓글 등록
    @PostMapping("/add.dox")
    public String addComment(@RequestBody HashMap<String, Object> map) {
        return reviewService.addComment(map);
    }

    // 댓글 리스트 조회
    @PostMapping("/list.dox")
    public String getCommentList(@RequestBody HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        List<HashMap<String, Object>> list = reviewService.getCommentList(map);
        resultMap.put("list", list);
        resultMap.put("result", "success");
        return gson.toJson(resultMap);
    }

    // 댓글 삭제 API
    @PostMapping("/delete")
    public String deleteComment(@RequestParam Long commentNo) {
        return commentService.removeComment(commentNo);
    }
}