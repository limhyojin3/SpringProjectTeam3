package com.example.demo.community_review.dao; // 기존 패키지 유지

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.common.Message;
import com.example.demo.community_review.mapper.ReviewMapper;
import com.example.demo.community_review.model.Review;
import com.google.gson.Gson;

@Service
public class ReviewService {

    @Autowired
    private ReviewMapper reviewMapper;

    @Autowired
    private FileService fileService;
    
    /**
     * [통합] 리뷰 리스트 조회 (전체/유료/무료)
     * 기존 getFreeReviewList를 대체합니다.
     */
    public List<HashMap<String, Object>> selectReviewList(HashMap<String, Object> map) {
        // 검색어 전처리 (기존 로직 유지)
        if(map.get("searchKeyword") != null) {
            String keyword = (String) map.get("searchKeyword");
            map.put("searchKeyword", keyword.trim());
        }
        
        // Mapper의 통합 쿼리 호출
        return reviewMapper.selectReviewList(map);
    }

    /**
     * 업체 상세 정보 조회 (유지)
     */
    public HashMap<String, Object> getCompanyDetail(HashMap<String, Object> map) {
        return reviewMapper.selectCompanyDetail(map);
    }
    
    /**
     * 리뷰 등록 로직 (기존 유지)
     */
    @Transactional(rollbackFor = Exception.class) 
    public String registerReview(Review review, MultipartFile receipt, List<MultipartFile> reviewFiles) {
        Gson gson = new Gson();
        
        // 1. 영수증 검증 (형님 기준: 무료/유료 모두 필수)
        if (receipt == null || receipt.isEmpty()) {
            return gson.toJson(new Message("fail", "영수증 인증은 필수입니다."));
        }

        try {
        	// 2. 영수증 파일 업로드
            String savedReceiptName = fileService.uploadFile(receipt); 
            review.setReceiptName(savedReceiptName); // DB의 receipt_name 컬럼에 매핑

            // 3. 리뷰 사진 업로드 (선택 사항)
            if (reviewFiles != null && !reviewFiles.isEmpty()) {
                // 여러 장 중 첫 번째 사진을 대표 이미지(stored_name)로 저장
                // (나중에 여러 장 관리가 필요하면 별도 테이블을 파야 하지만, 일단 단일 컬럼 유지)
                MultipartFile firstImg = reviewFiles.get(0);
                if(!firstImg.isEmpty()) {
                    String savedImgName = fileService.uploadFile(firstImg);
                    review.setStoredName(savedImgName);
                    review.setImgUrl("/uploads/" + savedImgName);
                }    
            }
            
         // 4. DB Insert (Review 객체에는 이제 isPaid, receiptName 등이 다 담겨있음)
            int result = reviewMapper.insertReview(review);
            
            if (result > 0) {
                return gson.toJson(Message.SUCCESS_ADD);
            } else {
                return gson.toJson(Message.FAIL_SERVER);
            }

        } catch (Exception e) {
            throw new RuntimeException(gson.toJson(Message.FAIL_SERVER));
        }
    }
}