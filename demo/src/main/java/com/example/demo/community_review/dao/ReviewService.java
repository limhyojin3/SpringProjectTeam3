package com.example.demo.community_review.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.common.Message;
import com.example.demo.community_review.mapper.ReviewMapper;
import com.example.demo.community_review.model.Review;

@Service
public class ReviewService {

    @Autowired
    private ReviewMapper reviewMapper;

    @Autowired
    private FileService fileService;

    // 리뷰 등록 로직 (파일 처리 포함)
    @Transactional // DB 저장 중 에러 발생 시 파일 처리와 함께 롤백하기 위함
    public String registerReview(Review review, MultipartFile file) {
        try {
            // 1. 첨부파일(영수증 등)이 있는지 확인
            if (file != null && !file.isEmpty()) {
                // 원본 파일명 저장
                review.setOriginalName(file.getOriginalFilename());
                
                // FileService를 통해 물리적 저장 후 생성된 고유 파일명 받기
                String savedName = fileService.uploadFile(file);
                review.setStoredName(savedName);
                
                // 파일(영수증)이 있으므로 유료 리뷰(1)로 설정
                review.setIsPaid(1);
            } else {
                // 파일이 없으면 일반 무료 리뷰(0)
                review.setIsPaid(0);
            }

            // 2. 최종 데이터를 DB에 Insert
            int result = reviewMapper.insertReview(review);
            
            // 3. 공통 메시지 클래스를 사용하여 결과 반환
            return (result > 0) ? Message.MSG_ADD : Message.MSG_ERR;

        } catch (Exception e) {
            e.printStackTrace(); // 개발 중 에러 확인용
            return Message.MSG_SERVER_ERR;
        }
    }
}