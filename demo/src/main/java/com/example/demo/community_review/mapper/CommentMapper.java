package com.example.demo.community_review.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.demo.community_review.model.Comment;

@Mapper
public interface CommentMapper {
    // [댓글 등록] 새 댓글 데이터를 저장합니다.
    int insertComment(Comment comment);

    // [댓글 조회] 게시글 타입과 번호에 맞는 삭제되지 않은 댓글 목록을 가져옵니다.
    List<Comment> selectCommentList(@Param("targetId") Long targetId);

    // [댓글 삭제] 실제 데이터를 지우지 않고 삭제 상태값만 변경합니다.
    int deleteComment(Long commentNo);
}