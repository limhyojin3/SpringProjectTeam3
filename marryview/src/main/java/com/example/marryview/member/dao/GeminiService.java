package com.example.marryview.member.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.example.marryview.member.model.ChatRequest;
import com.example.marryview.member.model.ChatResponse;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class GeminiService {

    @Qualifier("geminiRestTemplate")
    private final RestTemplate restTemplate;

    @Value("${gemini.api.url}")
    private String apiUrl;

    @Value("${gemini.api.key}")
    private String geminiApiKey;

    @Autowired
    private MemberService memberService;
    // 카테고리 감지 메서드 추가
    private String detectCategory(String prompt) {
        if (prompt.contains("스튜디오")) return "스튜디오";
        else if (prompt.contains("드레스")) return "드레스";
        else if (prompt.contains("메이크업")) return "메이크업";
        else if (prompt.contains("돌잔치")) return "돌잔치";
        else if (prompt.contains("아이생일") || prompt.contains("생일파티")) return "아이생일파티";
        else if (prompt.contains("가족사진") || prompt.contains("가족")) return "가족사진";
        else if (prompt.contains("가녀발") || prompt.contains("가을")) return "가녀발";
        else if (prompt.contains("부모님") || prompt.contains("신생아")) return "부모님신생아";
        else if (prompt.contains("우정사진") || prompt.contains("우정")) return "우정사진";
        else if (prompt.contains("브라이덜") || prompt.contains("샤워")) return "브라이덜샤워";
        else if (prompt.contains("파티룸")) return "파티룸";
        else if (prompt.contains("결혼")) return "결혼";
        else if (prompt.contains("가족행사")) return "가족행사";
        else if (prompt.contains("친구")) return "친구와함께";
        return "";
    }

    public String getContents(String prompt) {
        try {
        	String systemInstruction = "당신은 메리뷰의 친절한 고객 상담 AI입니다. " +
                    "항상 존댓말(~요, ~습니다)을 사용하고 공손하게 답변해주세요. " +
                    "반말은 절대 사용하지 마세요.\n\n";
            // 추천 관련 키워드 감지
            String context = "";
            boolean hasCategory = !detectCategory(prompt).isEmpty();
            
            if (prompt.contains("메리뷰 인기 상품") || prompt.contains("상품 추천") || prompt.contains("인기 상품")) {
                List<HashMap<String, Object>> topProducts = memberService.getTopReviewedProducts();
                StringBuilder sb = new StringBuilder();
                sb.append("다음은 메리뷰에서 리뷰가 가장 많은 인기 상품 목록입니다:\n");
                for (HashMap<String, Object> p : topProducts) {
                    sb.append("- ").append(p.get("product_name"))
                      .append(" (카테고리: ").append(p.get("large_category")).append("/").append(p.get("medium_category")).append(")")
                      .append(" 리뷰 수: ").append(p.get("review_cnt")).append("개\n");
                }
                sb.append("\n위 데이터를 참고하여 답변해주세요.\n\n");
                sb.append("1. 답변은 3줄 이내로 간결하게\n");
                sb.append("2. 상품명과 리뷰 수만 언급\n");
                sb.append("3. 불필요한 설명이나 추측 금지\n");
                sb.append("4. 친근하고 짧게 답변\n\n");
                context = sb.toString();
            }
            if (prompt.contains("비용") || prompt.contains("가격") || prompt.contains("평균") || prompt.contains("저렴") || prompt.contains("얼마")) {
                List<HashMap<String, Object>> avgPrices = memberService.getAverageProductPrice();
//                System.out.println("가격 데이터: " + avgPrices);  // ✅ 임시 로그
                StringBuilder sb = new StringBuilder();
                sb.append("다음은 메리뷰에 등록된 상품의 카테고리별 평균 가격입니다:\n");
                for (HashMap<String, Object> p : avgPrices) {
                    sb.append("- ").append(p.get("large_category"))
                      .append("/").append(p.get("medium_category"))
                      .append(": 평균 ").append(p.get("avg_price")).append("원")
                      .append(" (상품 수: ").append(p.get("product_cnt")).append("개)\n");
                }
                sb.append("\n위 데이터를 참고하여 친절하게 답변해주세요.\n\n");
                sb.append("1. 카테고리별 평균 가격을 간결하게 안내\n");
                sb.append("2. 불필요한 설명이나 추측 금지\n");
                sb.append("3. 친근하고 짧게 3줄 이내로 답변\n\n");
                sb.append("4. 날짜나 시점 언급 금지\n");
                sb.append("5. 고객센터 문의 유도 금지\n");
                context += sb.toString();
            }
            
            if (hasCategory &&(prompt.contains("저렴") || prompt.contains("싼") || prompt.contains("최저") || prompt.contains("얼마"))) {
                // 카테고리 키워드 감지
            	String category = detectCategory(prompt); 

                List<HashMap<String, Object>> cheapest = memberService.getCheapestProducts(category);
                StringBuilder sb2 = new StringBuilder();
                sb2.append("다음은 메리뷰에서 가장 저렴한 상품 목록입니다:\n");
                for (HashMap<String, Object> p : cheapest) {
                    sb2.append("- ").append(p.get("product_name"))
                       .append(" (").append(p.get("large_category")).append("/").append(p.get("medium_category")).append(")")
                       .append(": ").append(p.get("original_price")).append("원\n");
                }
                sb2.append("\n위 데이터를 참고하여 3줄 이내로 친절하게 답변해주세요.\n\n");
                context += sb2.toString();
            }
            if (hasCategory &&(prompt.contains("리뷰") && (prompt.contains("많은") || prompt.contains("인기")))) {
            	String category = detectCategory(prompt); 

                List<HashMap<String, Object>> mostReviewed = memberService.getMostReviewedProductsByCategory(category);
                StringBuilder sb3 = new StringBuilder();
                sb3.append("다음은 메리뷰에서 리뷰가 가장 많은 상품 목록입니다:\n");
                for (HashMap<String, Object> p : mostReviewed) {
                    sb3.append("- ").append(p.get("product_name"))
                       .append(" (").append(p.get("large_category")).append("/").append(p.get("medium_category")).append(")")
                       .append(": 리뷰 ").append(p.get("review_cnt")).append("개\n");
                }
                sb3.append("\n위 데이터를 참고하여 3줄 이내로 친절하게 답변해주세요.\n\n");
                context += sb3.toString();
            }

            String requestUrl = apiUrl + "?key=" + geminiApiKey;
            ChatRequest request = new ChatRequest(systemInstruction + context + prompt);
            ChatResponse response = restTemplate.postForObject(requestUrl, request, ChatResponse.class);
            return response.getCandidates().get(0).getContent().getParts().get(0).getText();
        } catch (Exception e) {
//        	e.printStackTrace();
            return "현재 AI 서비스가 일시적으로 불안정합니다. 잠시 후 다시 시도해주세요.😥";
        }
    }
    
    
}