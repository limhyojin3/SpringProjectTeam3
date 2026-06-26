package com.example.demo.member.controller;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;

import com.example.demo.member.dao.MemberService;
import com.example.demo.member.mapper.MemberMapper;
import com.example.demo.member.model.Member;

import jakarta.servlet.http.HttpSession;

@Controller
public class NaverLoginController {

    @Autowired
    MemberMapper memberMapper;
    
    @Autowired
    private MemberService memberService;

    @Value("${naver.client-id}")
    private String clientId;

    @Value("${naver.client-secret}")
    private String clientSecret; // 네이버는 Secret 키가 추가로 필요합니다.

    @Value("${naver.redirect-uri}")
    private String redirectUri;

    // 1. 네이버 로그인 페이지로 이동
    @GetMapping("/oauth/naver")
    public String naverLogin() {
        // CSRF 방지를 위한 상태 토큰 생성 (여기서는 간단히 UUID 사용)
        String state = UUID.randomUUID().toString();
        
        String url = "https://nid.naver.com/oauth2.0/authorize"
                + "?client_id=" + clientId
                + "&redirect_uri=" + redirectUri
                + "&response_type=code"
                + "&state=" + state; // 네이버는 state 필수
        return "redirect:" + url;
    }

    // 2. 콜백 처리
    @GetMapping("/oauth/naver/callback")
    public String naverCallback(@RequestParam String code, @RequestParam String state, HttpSession session) {
        try {
            // 토큰 가져오기
            String accessToken = getNaverToken(code, state);
            // 유저 정보 가져오기
            Map<String, Object> userInfo = getNaverUserInfo(accessToken);

            // 네이버는 유저 데이터가 "response"라는 큰 맵 안에 담겨서 옵니다.
            Map<String, Object> responseMap = (Map<String, Object>) userInfo.get("response");
            
            String naverId = "naver_" + responseMap.get("id");
            String nickname = (String) responseMap.get("nickname");
            String name = (String) responseMap.get("name");
            String email = (String) responseMap.get("email");

            if (nickname == null || nickname.isEmpty()) {
                nickname = name; // 닉네임이 없을 경우 이름을 대용으로 사용
            }

            // 기존 회원인지 확인 (Mapper 메서드는 기존 카카오 아이디 조회용을 소셜 통합용으로 같이 쓰거나 새로 파셔도 됩니다)
            Member member = memberMapper.selectMemberByKakaoId(naverId); 

            if (member == null) {
                // 회원 기본 테이블 저장
                HashMap<String, Object> insertMap = new HashMap<>();
                insertMap.put("userId", naverId);
                insertMap.put("password", "NAVER_" + UUID.randomUUID().toString());
                memberMapper.insertKakaoMember(insertMap);

                // 회원 상세 테이블 저장
                HashMap<String, Object> detailMap = new HashMap<>();
                detailMap.put("userId", naverId);
                detailMap.put("name", name);
                detailMap.put("nickname", nickname);
                detailMap.put("email", email);  
                memberMapper.insertKakaoMemberDetail(detailMap);
                
                // 쿠폰 발급 추가
                memberService.giveCoupon(naverId, "WELCOME15");
            } else {
                // 기존 회원이면 DB에서 닉네임 가져오기
                String dbNickname = memberMapper.selectNicknameByUserId(naverId);
                if (dbNickname != null && !dbNickname.isEmpty()) {
                    nickname = dbNickname;
                }
            }

            session.setAttribute("sessionId", naverId);
            session.setAttribute("sessionName", nickname);
            session.setAttribute("sessionRole", "USER");
            
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/login.do?error=naver";
        }
        return "redirect:/merryViewHome.do";
    }

    // 네이버 접근 토큰 발급 API 통신
    private String getNaverToken(String code, String state) {
        RestTemplate rt = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        params.add("grant_type", "authorization_code");
        params.add("client_id", clientId);
        params.add("client_secret", clientSecret); // 네이버 토큰 검증용 Secret 추가
        params.add("code", code);
        params.add("state", state);

        HttpEntity<MultiValueMap<String, String>> req = new HttpEntity<>(params, headers);
        ResponseEntity<Map> res = rt.postForEntity(
            "https://nid.naver.com/oauth2.0/token", req, Map.class);

        return (String) res.getBody().get("access_token");
    }

    // 네이버 유저 프로필 API 통신
    private Map<String, Object> getNaverUserInfo(String accessToken) {
        RestTemplate rt = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Bearer " + accessToken);

        HttpEntity<Void> req = new HttpEntity<>(headers);
        ResponseEntity<Map> res = rt.exchange(
            "https://openapi.naver.com/v1/nid/me",
            HttpMethod.GET, req, Map.class);

        return res.getBody();
    }
}