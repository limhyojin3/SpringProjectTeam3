package com.example.demo.community_review.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.community_review.dao.CommentService;
import com.example.demo.community_review.model.Comment;

@RestController
@RequestMapping("/api/comment")
public class CommentController {

    @Autowired
    private CommentService commentService;

    // 댓글 등록 API
    @PostMapping("/add")
    public String addComment(@RequestBody Comment comment) { 
        return commentService.addComment(comment);
    }

    @GetMapping("/list")
    public List<Comment> getComments(@RequestParam Long postNo) {
        // 서비스 메서드도 그에 맞춰 postNo만 받도록 수정되어 있어야 합니다.
        return commentService.getComments(postNo); 
    }

    // 댓글 삭제 API
    @PostMapping("/delete")
    public String deleteComment(@RequestParam Long commentNo) {
        return commentService.removeComment(commentNo);
    }
}