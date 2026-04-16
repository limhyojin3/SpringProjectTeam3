package com.example.demo.community_review.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.common.Message; // [간단주석] 기존에 만드신 Message 클래스를 사용합니다.
import com.example.demo.community_review.mapper.CommentMapper;
import com.example.demo.community_review.model.Comment;

@Service
public class CommentService {

    @Autowired
    private CommentMapper commentMapper;

    // 댓글 작성 로직
    public String addComment(Comment comment) {
        return (commentMapper.insertComment(comment) > 0) ? Message.MSG_ADD : Message.MSG_ERR;
    }

    // 댓글 목록 조회 로직
    public List<Comment> getComments(Long targetId) {
        return commentMapper.selectCommentList(targetId);
    }

    // 댓글 삭제 로직
    public String removeComment(Long commentNo) {
        return (commentMapper.deleteComment(commentNo) > 0) ? Message.MSG_REMOVE : Message.MSG_ERR;
    }
}