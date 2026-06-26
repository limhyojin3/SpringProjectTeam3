package com.example.marryview.community_review.dao;

import java.util.List;
import java.util.Map;
import java.io.File;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.example.marryview.admin.dao.NotificationService;
import com.example.marryview.community_review.mapper.CommentMapper; 

@Service
public class CommentService {

    @Autowired
    private CommentMapper commentMapper;

    @Autowired
    private NotificationService notificationService;
    
    @Autowired
    private FileService fileService;
    
    // 리뷰 댓글 목록
    public List<Map<String, Object>> getReviewCommentList(Map<String, Object> map) {
        return commentMapper.selectReviewCommentList(map);
    }

    // 리뷰 댓글 등록
    public int addReviewComment(Map<String, Object> map, MultipartFile[] files) {

        try {
            if (files != null && files.length > 0 && !files[0].isEmpty()) {
                Map<String, String> fileInfo = fileService.uploadFile(files[0]);

                if (fileInfo != null) {
                    map.put("imgUrl", fileInfo.get("imgUrl"));
                }
            } else {
                map.put("imgUrl", null);
            }

            int result = commentMapper.insertReviewComment(map);

            if (result > 0) {
                notificationService.createReviewCommented(map.get("commentNo"));
            }

            return result;

        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
    
    // 커뮤 댓글 목록
    public List<Map<String, Object>> getCommunityCommentList(Map<String, Object> map) {
        return commentMapper.selectCommunityCommentList(map);
    }

    // 커뮤 댓글 등록
    public int addCommunityComment(Map<String, Object> map, MultipartFile[] files) {

    	 try {
             if (files != null && files.length > 0 && !files[0].isEmpty()) {
                 Map<String, String> fileInfo = fileService.uploadFile(files[0]);

                 if (fileInfo != null) {
                     map.put("imgUrl", fileInfo.get("imgUrl"));
                 }
             } else {
                 map.put("imgUrl", null);
             }

             int result = commentMapper.insertCommunityComment(map);

             if (result > 0) {
                 notificationService.createReviewCommented(map.get("commentNo"));
             }

             return result;

         } catch (Exception e) {
             e.printStackTrace();
             return 0;
         }
    }

    // 댓글 수정
    public int editComment(Map<String, Object> map) {
        return commentMapper.updateComment(map);
    }

    // 댓글 삭제
    public int removeComment(Map<String, Object> map) {
        return commentMapper.deleteComment(map);
    }

    /**
     * 댓글 좋아요 토글 로직
     * 1. 해당 유저가 좋아요를 눌렀는지 확인
     * 2. 안 눌렀으면 INSERT + 카운트 UP
     * 3. 눌렀으면 DELETE + 카운트 DOWN
     */
    @Transactional
    public String toggleCommentLike(Map<String, Object> map) {
        // 1. 좋아요 여부 체크 (0: 없음, 1: 있음)
        int check = commentMapper.checkCommentLike(map);
        
        if (check == 0) {
            // 2-1. 좋아요 추가
            commentMapper.insertCommentLike(map);
            map.put("count", 1);
            commentMapper.updateCommentLikeCnt(map);
            return "liked";
        } else {
            // 2-2. 좋아요 취소
            commentMapper.deleteCommentLike(map);
            map.put("count", -1);
            commentMapper.updateCommentLikeCnt(map);
            return "unliked";
        }
    }
}