package com.example.marryview.community_review.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;

import com.example.marryview.community_review.model.Review;

@Mapper
public interface ReviewMapper {

    /* --- [1] 리뷰 CRUD 및 조회 --- */
    int insertReview(Review review);
    List<HashMap<String, Object>> selectReviewList(HashMap<String, Object> map);
    HashMap<String, Object> selectReviewDetail(HashMap<String, Object> map);
    int selectReviewCount(HashMap<String, Object> map);
    String getReviewTitle(String targetId);
    List<HashMap<String, Object>> selectBestReviewList(HashMap<String, Object> map);

    /* --- [2] 조회수 및 좋아요 --- */
    int updateViewCount(HashMap<String, Object> map);
    int checkReviewLike(HashMap<String, Object> map);
    void insertReviewLike(HashMap<String, Object> map);
    void deleteReviewLike(HashMap<String, Object> map);
    void updateReviewLikeCount(HashMap<String, Object> map);

    /* --- [3] 유료 열람 및 티켓 로직 --- */
    int checkViewLog(HashMap<String, Object> map);
    Integer getUserAccessCount(String userId);
    int deductTicket(String userId);
    int insertViewLog(HashMap<String, Object> map);
    void insertFreeViewLog(Map<String, Object> params);
    int checkViewLogExists(Map<String, Object> params);

    /* --- [4] 업체 및 상품 정보 --- */
    HashMap<String, Object> selectCompanyDetail(HashMap<String, Object> map);
    List<HashMap<String, Object>> selectActiveCompanyList(HashMap<String, Object> map);
    List<Map<String, Object>> selectProductListByCompany(Map<String, Object> map);
    
    /* --- [5] 리뷰와 관련된 기프트콘 --- */
    Map<String, Object> getReviewInfoForGiftcon(String targetId);
    
    int updateSummary(Map<String, Object> map);
}