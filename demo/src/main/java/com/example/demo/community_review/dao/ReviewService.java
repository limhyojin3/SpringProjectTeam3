package com.example.demo.community_review.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringJoiner; // 합치기용 임포트 추가

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
    
    private final Gson gson = new Gson();

    // 1. 리뷰 리스트 조회
    public List<HashMap<String, Object>> selectReviewList(HashMap<String, Object> map) {
        if(map.get("searchKeyword") != null) {
            String keyword = (String) map.get("searchKeyword");
            map.put("searchKeyword", keyword.trim());
        }
        return reviewMapper.selectReviewList(map);
    }
    
    // 2. 조회수 증가
    @Transactional
    public void plusViewCount(HashMap<String, Object> map) {
        reviewMapper.updateViewCount(map);
    }

    // 3. 상세 정보 조회
    public HashMap<String, Object> getReviewDetailInfo(HashMap<String, Object> map) {
        return reviewMapper.selectReviewDetail(map);
    }
    
    // 페이지네이션
    
    public int getReviewCount(HashMap<String, Object> map) {
        return reviewMapper.selectReviewCount(map);
    }

    // 4. 좋아요 토글
    @Transactional
    public HashMap<String, Object> toggleReviewLike(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        int count = reviewMapper.checkReviewLike(map);
        
        if (count > 0) {
            reviewMapper.deleteReviewLike(map);
            map.put("amount", -1);
        } else {
            reviewMapper.insertReviewLike(map);
            map.put("amount", 1);
        }
        
        reviewMapper.updateReviewLikeCount(map);
        
        HashMap<String, Object> info = reviewMapper.selectReviewDetail(map);
        resultMap.put("likeCnt", info.get("likeCnt"));
        resultMap.put("result", "success");
        return resultMap;
    }

    // 5. 업체 관련 조회
    public List<HashMap<String, Object>> selectActiveCompanyList(HashMap<String, Object> map) {
        return reviewMapper.selectActiveCompanyList(map);
    }
    
    /**
     * 6. 리뷰 등록 로직 (방법 A: 여러 장 합치기 고도화)
     * - 영수증: 별도 저장
     * - 리뷰이미지: N장을 쉼표(,)로 구분하여 한 컬럼에 저장
     */
    @Transactional(rollbackFor = Exception.class) 
    public String registerReview(Review review, MultipartFile receipt, List<MultipartFile> reviewFiles) {
        
        if (receipt == null || receipt.isEmpty()) {
            return gson.toJson(new Message("fail", "영수증 인증은 필수입니다."));
        }

        try {
            // [STEP 1] 영수증 파일 처리
            Map<String, String> receiptInfo = fileService.uploadFile(receipt);
            if (receiptInfo != null) {
                review.setReceiptName(receiptInfo.get("storedName")); 
            }

            // [STEP 2] 리뷰 이미지 처리 (여러 장 합치기)
            if (reviewFiles != null && !reviewFiles.isEmpty()) {
                // 쉼표(,)를 구분자로 사용하는 조이너 생성
                StringJoiner originalJoiner = new StringJoiner(",");
                StringJoiner storedJoiner = new StringJoiner(",");
                StringJoiner urlJoiner = new StringJoiner(",");

                for (MultipartFile file : reviewFiles) {
                    if (file != null && !file.isEmpty()) {
                        Map<String, String> imgInfo = fileService.uploadFile(file);
                        
                        if (imgInfo != null) {
                            originalJoiner.add(imgInfo.get("originalName"));
                            storedJoiner.add(imgInfo.get("storedName"));
                            urlJoiner.add(imgInfo.get("imgUrl"));
                        }
                    }
                }

                // 합쳐진 문자열이 있을 때만 객체에 세팅
                if (storedJoiner.length() > 0) {
                    review.setOriginalName(originalJoiner.toString());
                    review.setStoredName(storedJoiner.toString());
                    review.setImgUrl(urlJoiner.toString());
                }
            }
            
            // [STEP 3] DB Insert 실행
            int result = reviewMapper.insertReview(review);
            
            return result > 0 ? gson.toJson(Message.SUCCESS_ADD) : gson.toJson(Message.FAIL_SERVER);

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(gson.toJson(Message.FAIL_SERVER));
        }
    }
    
    @Transactional(rollbackFor = Exception.class)
    public HashMap<String, Object> useAccessTicket(HashMap<String, Object> map) throws Exception {
        HashMap<String, Object> resultMap = new HashMap<>();
        
        // [추가] 프론트에서 보낸 checkOnly 값 확인 ("Y"면 확인만 함)
        String checkOnly = (String) map.get("checkOnly");

        // 1. 이미 본 기록이 있는지 확인 (공통)
        if (reviewMapper.checkViewLog(map) > 0) {
            resultMap.put("result", "ALREADY_VIEWED");
            return resultMap;
        }

        // 2. 만약 "단순 확인용" 호출이었다면 여기서 멈춤
        // 이미 본 기록이 없으므로 "처음 보는 글"이라는 신호를 보냄
        if ("Y".equals(checkOnly)) {
            resultMap.put("result", "NOT_VIEWED_YET");
            return resultMap;
        }

        // 3. 열람권 잔액 확인 (여기서부터는 실제 차감 모드)
        String userId = (String) map.get("userId");
        Integer count = reviewMapper.getUserAccessCount(userId);
        
        if (count == null || count <= 0) {
            resultMap.put("result", "NO_TICKET");
            return resultMap;
        }

        // 4. 실제 차감 및 로그 작성
        reviewMapper.deductTicket(userId);
        reviewMapper.insertViewLog(map);
        
        resultMap.put("result", "SUCCESS");
        return resultMap;
    }
 
    // 1. 단순 잔액 조회 (비즈니스 로직이 따로 없으므로 매퍼 호출 후 리턴)
    public Integer getUserAccessCount(String userId) {
        // 매퍼에서 가져온 값이 null이면 0을 반환하도록 처리
        Integer count = reviewMapper.getUserAccessCount(userId);
        return (count != null) ? count : 0;
    }
    
    // 무료 리뷰 열람 기록 저장 (상세보기 클릭 시 호출)
    public void saveFreeViewLog(Map<String, Object> map, String userId) {
        Map<String, Object> params = new HashMap<>();
        params.put("reviewNo", map.get("reviewNo"));
        params.put("userId", userId);

        // 1. 이미 존재하는지 확인
        int count = reviewMapper.checkViewLogExists(params);

        // 2. 없을 때만 인서트
        if (count == 0) {
            reviewMapper.insertFreeViewLog(params);
        }
    }
    
}