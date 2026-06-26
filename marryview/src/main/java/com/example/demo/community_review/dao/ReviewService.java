package com.example.demo.community_review.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringJoiner; // 합치기용 임포트 추가
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.common.Message;
import com.example.demo.community_review.mapper.ReviewMapper;
import com.example.demo.community_review.model.Review;
import com.example.demo.member.mapper.MemberMapper;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import com.example.demo.admin.dao.NotificationService;

@Service
public class ReviewService {
	@Value("${geminiAi.api.key}") // application.properties의 키값
    private String geminiApiKey;

    @Autowired
    private ReviewMapper reviewMapper;

    @Autowired
    private FileService fileService;
    
    @Autowired
    private MemberMapper memberMapper; //✅기프트콘 로직 추가✅

    @Autowired
    private NotificationService notificationService;
    
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
      //✅ 리뷰 정보 조회 (본인 체크 + 좋아요 수 둘 다 여기서)
        HashMap<String, Object> info = reviewMapper.selectReviewDetail(map);
//        System.out.println("info 내용: " + info);
//        System.out.println("map 내용: " + map);
        
      // ✅ 본인 리뷰 좋아요 방지
        String reviewAuthor = String.valueOf(info.get("userId"));
        String currentUser  = String.valueOf(map.get("userId"));
        
     // ✅ 여기에 추가
//        System.out.println("reviewAuthor: " + reviewAuthor);
//        System.out.println("currentUser: " + currentUser);
//        System.out.println("equals: " + reviewAuthor.equals(currentUser));  

        if (reviewAuthor.equals(currentUser)) {
            resultMap.put("result", "fail");
            resultMap.put("message", "본인 리뷰에는 좋아요를 누를 수 없습니다.");
            return resultMap;
        }
        
        int count = reviewMapper.checkReviewLike(map);
        
        if (count > 0) {
            reviewMapper.deleteReviewLike(map);
            map.put("amount", -1);
        } else {
            reviewMapper.insertReviewLike(map);
            map.put("amount", 1);
        }
        
        reviewMapper.updateReviewLikeCount(map);
        
        info = reviewMapper.selectReviewDetail(map); 
        resultMap.put("likeCnt", info.get("likeCnt"));
        resultMap.put("result", "success");
        
        // ✅ 좋아요 추가일 때만 기프트콘 체크
        if ((int) map.get("amount") == 1) {
            checkAndGiveGiftcon(map);
        }

        return resultMap;
    }
    
    //✅ 4-2. 기프트콘 발급 로직
    private void checkAndGiveGiftcon(HashMap<String, Object> map) {
        try {
            String targetId = String.valueOf(map.get("reviewNo"));
//            System.out.println("targetId: " + targetId); // ✅ 확인

            Map<String, Object> reviewInfo = reviewMapper.getReviewInfoForGiftcon(targetId);
//            System.out.println("reviewInfo: " + reviewInfo); // ✅ 확인
            if (reviewInfo == null) return;

            String reviewAuthorId = String.valueOf(reviewInfo.get("userId"));
            Object isPaidObj = reviewInfo.get("isPaid");
            int isPaid = 0;
            if (isPaidObj instanceof Boolean) {
                isPaid = ((Boolean) isPaidObj) ? 1 : 0;
            } else {
                String isPaidStr = String.valueOf(isPaidObj);
                isPaid = (isPaidStr.equals("true") || isPaidStr.equals("1")) ? 1 : 0;
            }
            
            int likeCnt = Integer.parseInt(String.valueOf(reviewInfo.get("likeCnt")));

            String couponCode = null;
            if (isPaid == 1 && likeCnt >= 30) {
                couponCode = "GIFT002"; // 투썸
            } else if (isPaid == 0 && likeCnt >= 40) {
                couponCode = "GIFT003"; // CU
            }

            if (couponCode == null) return;

            // 리뷰 기준 중복 체크
            HashMap<String, Object> couponMap = new HashMap<>();
            couponMap.put("reviewNo",   targetId);
            couponMap.put("couponCode", couponCode);

            int duplicate = memberMapper.checkGiftconByReview(couponMap);
            if (duplicate > 0) return;

            // 발급
            couponMap.put("userId",         reviewAuthorId);
            couponMap.put("giftconCode",    "GC-" + System.currentTimeMillis());
            couponMap.put("giftconBarcode", String.valueOf((long)(Math.random() * 9000000000000L) + 1000000000000L));
            couponMap.put("sourceReviewNo", targetId);

            memberMapper.insertGiftcon(couponMap);
            
            notificationService.createGiftconIssued(
            	    reviewAuthorId,
            	    couponCode,
            	    targetId
            	);
            
            System.out.println("기프트콘 발급 완료: " + couponCode + " → " + reviewAuthorId);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 5. 업체 관련 조회
    public List<HashMap<String, Object>> selectActiveCompanyList(HashMap<String, Object> map) {
        return reviewMapper.selectActiveCompanyList(map);
    }
    
    public List<HashMap<String, Object>> selectBestReviewList(HashMap<String, Object> map) {
        return reviewMapper.selectBestReviewList(map);
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
            
         // [STEP 2.5] 추가: 본문에서 썸네일 추출하여 세팅
            // 저장하기 직전에 본문 HTML에서 첫 번째 이미지 경로를 뽑아 thumbnailUrl에 넣습니다.
            String thumbnail = extractThumbnail(review.getContent());
            if (thumbnail == null) {
                // 본문에 사진이 없으면 영수증 사진을 썸네일로 사용
                thumbnail = review.getImgUrl(); 
            }
            review.setThumbnailUrl(thumbnail);
            
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
    
    public List<Map<String, Object>> getProductListByCompany(Map<String, Object> map) {
        return reviewMapper.selectProductListByCompany(map);
    }
    
    /**
     * 에디터 본문(HTML)에서 첫 번째 이미지의 src 추출
     */
    private String extractThumbnail(String content) {
        if (content == null || content.isEmpty()) return null;
        
        // <img src="..."> 패턴 추출
        Pattern pattern = Pattern.compile("<img[^>]+src\\s*=\\s*['\"]([^'\"]+)['\"]");
        Matcher matcher = pattern.matcher(content);

        if (matcher.find()) {
            return matcher.group(1); 
        }
        return null; // 본문에 사진 없으면 null 리턴
    }

    /**
     * 리뷰 등록
     */
    public int insertReview(Review review) {
        // 본문 파싱해서 썸네일 필드 세팅
        review.setThumbnailUrl(extractThumbnail(review.getContent()));
        
        return reviewMapper.insertReview(review);
    }
    
    public String getAiSummary(Long reviewNo, String content) {
        // 1. 기존 DB에서 요약본 조회 (이미 존재하면 바로 반환)
        HashMap<String, Object> param = new HashMap<>();
        param.put("reviewNo", reviewNo);
        HashMap<String, Object> review = reviewMapper.selectReviewDetail(param);
        
        // DB 컬럼명에 맞춰 'summary' 키 사용
        if (review.get("summary") != null) {
            return (String) review.get("summary");
        }
        
        // 2. AI 요약 생성
        String summary = callGeminiApi(content);

        // 3. DB에 업데이트
        HashMap<String, Object> updateParam = new HashMap<>();
        updateParam.put("reviewNo", reviewNo);
        updateParam.put("summary", summary); // 여기도 'summary' 키 사용
        
        // 메서드명도 updateSummary로 변경 권장
        reviewMapper.updateSummary(updateParam);

        return summary;
    }

    private String callGeminiApi(String content) {
        // 1. API 키 확인 (콘솔에 제대로 찍히는지 확인)
        System.out.println("DEBUG - API Key: " + geminiApiKey);
        
     // 추천하는 가장 안정적인 모델명 (위 리스트에 있는 이름 그대로 사용)
        String modelName = "gemini-2.5-flash-lite"; // 또는 "gemini-2.5-flash"

        // URL 구성을 아래와 같이 변경하세요 (v1beta/ 뒤에 바로 모델명을 붙임)
        String url = "https://generativelanguage.googleapis.com/v1/models/" + modelName + ":generateContent?key=" + geminiApiKey;

        // 타임아웃 설정을 추가하여 무한 대기 방지
        OkHttpClient client = new OkHttpClient.Builder()
                .connectTimeout(15, java.util.concurrent.TimeUnit.SECONDS)
                .readTimeout(15, java.util.concurrent.TimeUnit.SECONDS) 
                .build();

        // AI에게 보낼 요청 본문 구성
        JsonObject jsonBody = new JsonObject();
        JsonObject contentObj = new JsonObject();
        JsonObject partObj = new JsonObject();
        
        partObj.addProperty("text", "다음 리뷰 내용을 읽고, 핵심 장점과 아쉬운 점을 포함하여 3줄 이내로 핵심 요약해줘:\n\n" + content);
        
        com.google.gson.JsonArray partsArray = new com.google.gson.JsonArray();
        partsArray.add(partObj);
        contentObj.add("parts", partsArray);
        
        com.google.gson.JsonArray contentsArray = new com.google.gson.JsonArray();
        contentsArray.add(contentObj);
        jsonBody.add("contents", contentsArray);

        RequestBody body = RequestBody.create(jsonBody.toString(), MediaType.get("application/json; charset=utf-8"));
        Request request = new Request.Builder().url(url).post(body).build();

        try (Response response = client.newCall(request).execute()) {
            // 응답 내용을 담을 문자열 생성 (한 번 읽으면 사라지므로 변수에 저장)
            String responseData = response.body().string();
            
            if (!response.isSuccessful()) {
                System.err.println("--- Gemini API 통신 실패 ---");
                System.err.println("코드: " + response.code());
                System.err.println("메시지: " + response.message());
                System.err.println("응답 본문: " + responseData); 
                return "요약 서비스가 잠시 바쁩니다. 잠시 후 다시 시도해주세요.";
            }
            
            // 성공 시 파싱 진행
            JsonObject root = JsonParser.parseString(responseData).getAsJsonObject();
            String summaryText = root.getAsJsonArray("candidates").get(0).getAsJsonObject()
                    .getAsJsonObject("content").getAsJsonArray("parts").get(0).getAsJsonObject()
                    .get("text").getAsString();

            return summaryText;
        } catch (Exception e) {
            System.err.println("--- Gemini API 호출 중 예외 발생 ---");
            e.printStackTrace(); 
            return "요약 생성 중 오류";
        }
    }
    
}