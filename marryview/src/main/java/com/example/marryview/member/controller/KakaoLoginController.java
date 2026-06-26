package com.example.marryview.member.controller;

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

import com.example.marryview.member.dao.MemberService;
import com.example.marryview.member.mapper.MemberMapper;
import com.example.marryview.member.model.Member;

import jakarta.servlet.http.HttpSession;

@Controller
public class KakaoLoginController {
	@Autowired
	MemberMapper memberMapper;
	
	@Autowired
	private MemberService memberService;

    @Value("${kakao.client-id}")
    private String clientId;

    @Value("${kakao.redirect-uri}")
    private String redirectUri;

    // 1. 카카오 로그인 페이지로 이동
    @GetMapping("/oauth/kakao")
    public String kakaoLogin() {
        String url = "https://kauth.kakao.com/oauth/authorize"
                + "?client_id=" + clientId
                + "&redirect_uri=" + redirectUri
                + "&response_type=code";
        return "redirect:" + url;
    }

    // 2. 콜백 처리
    @GetMapping("/oauth/kakao/callback")
    public String kakaoCallback(@RequestParam String code, HttpSession session) {
        try {
            String accessToken = getKakaoToken(code);
            Map<String, Object> userInfo = getKakaoUserInfo(accessToken);

            String kakaoId = "kakao_" + userInfo.get("id");
            Map<String, Object> properties = (Map<String, Object>) userInfo.get("properties");
            String nickname = (String) properties.get("nickname");

            // 이메일 처리 ← 여기 추가
            String email = "";
            Map<String, Object> kakaoAccount = (Map<String, Object>) userInfo.get("kakao_account");
            if (kakaoAccount != null && kakaoAccount.get("email") != null) {
                email = (String) kakaoAccount.get("email");
            } else {
                email = kakaoId + "@kakao.com";
            }

            // 기존 회원인지 확인
            Member member = memberMapper.selectMemberByKakaoId(kakaoId);

            if (member == null) {
                HashMap<String, Object> insertMap = new HashMap<>();
                insertMap.put("userId", kakaoId);
                insertMap.put("password", "KAKAO_" + UUID.randomUUID().toString());
                memberMapper.insertKakaoMember(insertMap);

                HashMap<String, Object> detailMap = new HashMap<>();
                detailMap.put("userId", kakaoId);
                detailMap.put("name", nickname);
                detailMap.put("nickname", nickname);
                detailMap.put("email", email);  
                memberMapper.insertKakaoMemberDetail(detailMap);
                
                memberService.giveCoupon(kakaoId, "WELCOME15");
            } else {
                // 기존 회원이면 DB에서 닉네임 가져오기
                String dbNickname = memberMapper.selectNicknameByUserId(kakaoId);
                if (dbNickname != null && !dbNickname.isEmpty()) {
                    nickname = dbNickname;
                }
            }

            session.setAttribute("sessionId", kakaoId);
            session.setAttribute("sessionName", nickname);
            session.setAttribute("sessionRole", "USER");

        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/login.do?error=kakao";
        }
        return "redirect:/merryViewHome.do";
    }

    private String getKakaoToken(String code) {
        RestTemplate rt = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        params.add("grant_type", "authorization_code");
        params.add("client_id", clientId);
        params.add("redirect_uri", redirectUri);
        params.add("code", code);

        HttpEntity<MultiValueMap<String, String>> req = new HttpEntity<>(params, headers);
        ResponseEntity<Map> res = rt.postForEntity(
            "https://kauth.kakao.com/oauth/token", req, Map.class);

        return (String) res.getBody().get("access_token");
    }

    private Map<String, Object> getKakaoUserInfo(String accessToken) {
        RestTemplate rt = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Bearer " + accessToken);

        HttpEntity<Void> req = new HttpEntity<>(headers);
        ResponseEntity<Map> res = rt.exchange(
            "https://kapi.kakao.com/v2/user/me",
            HttpMethod.GET, req, Map.class);

        return res.getBody();
    }
}