package com.example.demo.admin.dao;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;

import org.cloudinary.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.demo.admin.mapper.PaymentMapper;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
//PaymentService.java
@Service
public class PaymentService {

	@Autowired
	PaymentMapper paymentMapper;
	
	@Autowired
	AdminService adminService;
	
	@Value("${iamport.imp_key}")
	private String impKey;

	@Value("${iamport.imp_secret}")
	private String impSecret;
	
	@Transactional
	public void completePassPayment(HashMap<String, Object> map) {
		paymentMapper.insertPayment(map);
		System.out.println("생성된 payNo = " + map.get("payNo"));
		paymentMapper.insertPaymentPass(map);
	}
	
	public void updateWalletCount(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		int cnt = paymentMapper.selectWalletCnt(map); // 지갑 존재 여부 COUNT(*)

	    if (cnt > 0) {
	        paymentMapper.updateWalletCnt(map);   // 기존 사용자 충전
	        resultMap.put("message", "열람권이 충전되었습니다");
	    } else {
	        paymentMapper.insertWalletCnt(map);   // 첫 구매 생성
	        resultMap.put("message", "열람권 지갑이 생성되었습니다");
	    }
	    
	}
	
	@Transactional
	public void completeReservationPayment(HashMap<String,Object> map){

	   // paymentMapper.insertPayment(map); // 공통 결제

	   // paymentMapper.insertPaymentReservation(map); // 상세
	    
	    //paymentMapper.updateReservationStatus(map); 가 필요할지도???
	}
	
	@Transactional
	public void completeRegistrationPayment(HashMap<String,Object> map){

	    //paymentMapper.insertPayment(map); // 공통 결제

	    //paymentMapper.insertPaymentRegistration(map); // 상세
	    
	}

	public HashMap<String, Object> verifyPayment(HashMap<String, Object> map) {
		System.out.println("넘어온 값 : " + map);
		HashMap<String, Object> result = new HashMap<>();

		try {

			// 프론트에서 받은 값
			String impUid = map.get("imp_uid").toString();
			String merchantUid = map.get("merchant_uid") == null
			        ? ""
			        : map.get("merchant_uid").toString();
			int reqAmount = Integer.parseInt(map.get("amount").toString());

			// 1. 포트원 토큰 발급
			String token = getToken();

			// 2. 실제 결제정보 조회
			HashMap<String, Object> payInfo = getPaymentInfo(token, impUid);

			double realAmount = Integer.parseInt(payInfo.get("amount").toString());

			String status = payInfo.get("status").toString();

			// 3. 결제 상태 확인
			if (!status.equals("paid")) {
				result.put("result", "fail");
				result.put("message", "결제 미완료");
				return result;
			}

			// 4. 금액 검증
			if (realAmount != reqAmount) {
				result.put("result", "fail");
				result.put("message", "금액 위조 의심");
				return result;
			}

			// 5. DB 저장
			map.put("pay_status", "paid");

			String type = map.get("type").toString();

			if (type.equals("PASS")) {
				if (map.get("passNo").toString().equals("1")) {
					HashMap<String, Object> chk = adminService.getPassInfo(map);

					if (chk.get("info") != null) {
						result.put("result", "fail");
						result.put("message", "체험권은 1회만 구매 가능합니다.");
						System.out.println("체험용 패스 여부 : " + chk);
						return result;
					}
				}
				updateWalletCount(map);
				completePassPayment(map);
				
			}else if(type.equals("RES")){
			    // completeReservationPayment(map);

			}else if(type.equals("REG")){
			    completeRegistrationPayment(map);
			}
//			completePassPayment(map);

			result.put("result", "success");
			result.put("payNo", map.get("payNo"));
			result.put("message", "결제 완료");

		} catch (Exception e) {
			e.printStackTrace();

			result.put("result", "fail");
			result.put("message", "서버 오류");
		}

		return result;
	}

	// =========================
	// 토큰 발급
	// =========================
	public String getToken() throws Exception {

		URL url = new URL("https://api.iamport.kr/users/getToken");

		HttpURLConnection conn = (HttpURLConnection) url.openConnection();

		conn.setRequestMethod("POST");
		conn.setRequestProperty("Content-Type", "application/json");
		conn.setDoOutput(true);
		
		String json = "{"
	            + "\"imp_key\":\"" + impKey + "\","
	            + "\"imp_secret\":\"" + impSecret + "\""
	            + "}";

	    OutputStream os = conn.getOutputStream();
	    os.write(json.getBytes("UTF-8"));
	    os.flush();
	    os.close();

	    int code = conn.getResponseCode();

	    BufferedReader br;

	    if (code == 200) {
	        br = new BufferedReader(
	            new InputStreamReader(conn.getInputStream(), "UTF-8"));
	    } else {
	        br = new BufferedReader(
	            new InputStreamReader(conn.getErrorStream(), "UTF-8"));
	    }

	    String line = "";
	    StringBuilder sb = new StringBuilder();

	    while ((line = br.readLine()) != null) {
	        sb.append(line);
	    }

	    br.close();

	    System.out.println("토큰 응답코드 = " + code);
	    System.out.println("토큰 응답본문 = " + sb.toString());

	    if (code != 200) {
	        throw new RuntimeException("토큰 발급 실패");
	    }

	    ObjectMapper mapper = new ObjectMapper();
	    JsonNode root = mapper.readTree(sb.toString());

	    return root.path("response").path("access_token").asText();
	}

	// =========================
	// 결제 조회
	// =========================
	public HashMap<String, Object> getPaymentInfo(String token, String impUid) throws Exception {

		URL url = new URL("https://api.iamport.kr/payments/" + impUid + "?include_sandbox=true");

		HttpURLConnection conn = (HttpURLConnection) url.openConnection();

		conn.setRequestMethod("GET");
		conn.setRequestProperty("Authorization", token);

		int code = conn.getResponseCode();

	    BufferedReader br;

	    if (code == 200) {
	        br = new BufferedReader(
	            new InputStreamReader(conn.getInputStream(), "UTF-8")
	        );
	    } else {
	        br = new BufferedReader(
	            new InputStreamReader(conn.getErrorStream(), "UTF-8")
	        );
	    }

	    String line = "";
	    StringBuilder sb = new StringBuilder();

	    while ((line = br.readLine()) != null) {
	        sb.append(line);
	    }

	    br.close();

	    System.out.println("응답 : " + sb.toString());

	    ObjectMapper mapper = new ObjectMapper();
	    JsonNode root = mapper.readTree(sb.toString());

	    if (code != 200) {
	        throw new RuntimeException(root.path("message").asText());
	    }

	    HashMap<String, Object> info = new HashMap<>();

	    info.put("amount", root.path("response").path("amount").asInt());
	    info.put("status", root.path("response").path("status").asText());

	    return info;
	}
	
//	public HashMap<String, Object> refundPayment(HashMap<String, Object> map) {
//	    HashMap<String, Object> resultMap = new HashMap<>();
//
//	    try {
//
//	        String impUid = map.get("imp_uid").toString();
//
//	        // -----------------------------
//	        // 1. 포트원 토큰 발급
//	        // -----------------------------
//	        URL url = new URL("https://api.iamport.kr/users/getToken");
//	        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
//
//	        conn.setRequestMethod("POST");
//	        conn.setRequestProperty("Content-Type", "application/json");
//	        conn.setDoOutput(true);
//
//	        String jsonInput =
//	            "{ \"imp_key\":\"테스트REST_API_KEY\", " +
//	            "\"imp_secret\":\"테스트REST_API_SECRET\" }";
//
//	        OutputStream os = conn.getOutputStream();
//	        os.write(jsonInput.getBytes("UTF-8"));
//	        os.flush();
//	        os.close();
//
//	        BufferedReader br =
//	            new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
//
//	        StringBuilder sb = new StringBuilder();
//	        String line = "";
//
//	        while ((line = br.readLine()) != null) {
//	            sb.append(line);
//	        }
//
//	        br.close();
//
//	        JSONObject tokenObj = new JSONObject(sb.toString());
//	        String accessToken =
//	            tokenObj.getJSONObject("response").getString("access_token");
//
//	        // -----------------------------
//	        // 2. 환불 요청
//	        // -----------------------------
//	        URL cancelUrl = new URL("https://api.iamport.kr/payments/cancel");
//	        HttpURLConnection cancelConn =
//	            (HttpURLConnection) cancelUrl.openConnection();
//
//	        cancelConn.setRequestMethod("POST");
//	        cancelConn.setRequestProperty("Content-Type", "application/json");
//	        cancelConn.setRequestProperty("Authorization", accessToken);
//	        cancelConn.setDoOutput(true);
//
//	        String cancelJson =
//	            "{ \"imp_uid\":\"" + impUid + "\", " +
//	            "\"reason\":\"관리자 환불\" }";
//
//	        OutputStream os2 = cancelConn.getOutputStream();
//	        os2.write(cancelJson.getBytes("UTF-8"));
//	        os2.flush();
//	        os2.close();
//
//	        BufferedReader br2 =
//	            new BufferedReader(new InputStreamReader(cancelConn.getInputStream(), "UTF-8"));
//
//	        StringBuilder sb2 = new StringBuilder();
//
//	        while ((line = br2.readLine()) != null) {
//	            sb2.append(line);
//	        }
//
//	        br2.close();
//
//	        // -----------------------------
//	        // 3. DB 상태 변경
//	        // -----------------------------
//	        paymentMapper.updateRefundStatus(map);
//
//	        resultMap.put("result", "success");
//	        resultMap.put("message", "환불 완료");
//
//	    } catch (Exception e) {
//	        e.printStackTrace();
//	        resultMap.put("result", "fail");
//	        resultMap.put("message", "환불 실패");
//	    }
//
//	    return resultMap;
//	}
	
	// 환불
	public HashMap<String, Object> refundPayment(HashMap<String, Object> map) {

		HashMap<String, Object> resultMap = new HashMap<>();

		try {

			// 결제 환불 처리
			paymentMapper.updateRefund(map);

			// 예약 상태 취소
			paymentMapper.updateReservationCancel(map);

			resultMap.put("result", "success");
			resultMap.put("message", "환불 완료");

		} catch (Exception e) {
			e.printStackTrace();

			resultMap.put("result", "fail");
			resultMap.put("message", "환불 실패");
		}

		return resultMap;
	}
	
}