package com.example.marryview.member.dao;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import net.nurigo.sdk.NurigoApp;
import net.nurigo.sdk.message.model.Message;
import net.nurigo.sdk.message.request.SingleMessageSendingRequest;
import net.nurigo.sdk.message.service.DefaultMessageService;

@Service
public class SmsService {
	
	// *휴대전화 번호 인증 api*
		@Value("${coolsms.api.key:none}") // 값이 없으면 "none"이라는 문자열을 기본으로 넣음
		private String apiKey;

		@Value("${coolsms.api.secret:none}")
		private String apiSecret;

		@Value("${coolsms.sender:none}")
		private String sender;

		// 인증번호 임시 저장
		private Map<String, String> authCodeMap = new HashMap<>();

		// 인증번호 발송
		public HashMap<String, Object> sendSms(HashMap<String, Object> map) {
		    HashMap<String, Object> resultMap = new HashMap<>();
		    try {
		        DefaultMessageService messageService = NurigoApp.INSTANCE.initialize(apiKey, apiSecret, "https://api.coolsms.co.kr");

		        // 6자리 랜덤 인증번호 생성
		        String authCode = String.valueOf((int)(Math.random() * 900000) + 100000);
		        
		        System.out.println("저장 tel: " + map.get("tel"));
		        System.out.println("저장 authCode: " + authCode);
		        // 임시 저장
		        String tel = ((String)map.get("tel")).replace("-", ""); // 전화번호 - 제거
		        authCodeMap.put(tel, authCode);  // ← map.get("tel") 대신 tel 사용

		        Message message = new Message();
		        message.setFrom(sender);
		        message.setTo((String)map.get("tel"));
		        message.setText("[메리뷰] 인증번호: " + authCode);

		        messageService.sendOne(new SingleMessageSendingRequest(message));

		        resultMap.put("result", "success");
		    } catch (Exception e) {
		        System.out.println(e.getMessage());
		        resultMap.put("result", "fail");
		    }
		    return resultMap;
		}

		// 인증번호 확인
		public HashMap<String, Object> checkSms(HashMap<String, Object> map) {
			System.out.println("확인 tel: " + map.get("tel"));
			System.out.println("입력 authCode: " + map.get("authCode"));
			System.out.println("저장된 authCode: " + authCodeMap.get(map.get("tel")));
		    HashMap<String, Object> resultMap = new HashMap<>();
		    String tel = (String) map.get("tel");
		    String inputCode = (String) map.get("authCode");
		    String savedCode = authCodeMap.get(tel);

		    if(savedCode != null && savedCode.equals(inputCode)) {
		        resultMap.put("result", "success");
		        authCodeMap.remove(tel);  // 인증 완료 후 삭제
		    } else {
		        resultMap.put("result", "fail");
		    }
		    return resultMap;
		}

}
