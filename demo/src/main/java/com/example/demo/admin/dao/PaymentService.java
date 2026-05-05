package com.example.demo.admin.dao;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.HashMap;

import org.cloudinary.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.demo.admin.mapper.PaymentMapper;
import com.example.demo.admin.model.Payment;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import java.time.LocalDateTime;
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

	    Integer companyNo = paymentMapper.selectCompanyInfo(map);
	    if (companyNo == null) {
	        throw new RuntimeException("회사 정보 없음");
	    }

	   
	    map.put("companyNo", companyNo);
	    paymentMapper.insertPayment(map); // 공통 결제
	    paymentMapper.insertPaymentRegistration(map); // 상세
	    
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
			
			Object passNoObj = map.get("passNo");

			if (passNoObj == null) {
			    throw new IllegalArgumentException("passNo가 없습니다.");
			}

			int passNo = Integer.parseInt(passNoObj.toString());
			int basePrice = paymentMapper.selectPassPrice(passNo);
			
			int finalAmount = basePrice;   // 기본값
	        int discount = 0;
	        
	        Object obj = map.get("couponCode");
	        String couponCode = (obj == null) ? null : obj.toString();
	        
	        if (couponCode != null && !couponCode.isEmpty()) {

	            map.put("couponCode", couponCode);

	            Payment coupon = paymentMapper.selectCouponInfo(map);

	            if (coupon == null) {
	            	cancelPayment(token, impUid);
	                result.put("result", "fail");
	                result.put("message", "쿠폰 없음");
	                return result;
	            }

	            if (!"UNUSED".equals(coupon.getStatus())) {
	            	cancelPayment(token, impUid);
	                result.put("result", "fail");
	                result.put("message", "이미 사용된 쿠폰");
	                return result;
	            }
	            
	            Timestamp now = new Timestamp(System.currentTimeMillis());

	            Timestamp expiredAt = coupon.getExpiredAt();
	            if (expiredAt != null && expiredAt.before(now)) {
	            	cancelPayment(token, impUid);
	                result.put("result", "fail");
	                result.put("message", "만료된 쿠폰입니다.");
	                return result;
	            }
	            int rate = coupon.getDiscountRate();

	            discount = (basePrice * rate) / 100;

	            finalAmount = basePrice - discount;

	            if (finalAmount < 0) {
	                finalAmount = 0;
	            }
	        }
			
			// 4. 금액 검증
			if (realAmount != finalAmount) {
				cancelPayment(token, impUid);
				result.put("result", "fail");
				result.put("message", "금액 위조 의심");
				return result;
			}

			// 5. DB 저장
			map.put("pay_status", "paid");
			map.put("discountAmount", discount);
			map.put("finalAmount", finalAmount);

			String type = map.get("type").toString();

			if (type.equals("PASS")) {
				if (map.get("passNo").toString().equals("1")) {
					HashMap<String, Object> chk = adminService.getPassInfo(map);

					if (chk.get("info") != null) {
						cancelPayment(token, impUid);
						result.put("result", "fail");
						result.put("message", "체험권은 1회만 구매 가능합니다.");
						System.out.println("체험용 패스 여부 : " + chk);
						return result;
					}
				}
				updateWalletCount(map);
				completePassPayment(map);
				
				if (couponCode != null && !couponCode.isEmpty()) {
	                paymentMapper.updateUsedCoupon(map); // 쿠폰 USED 처리
	            }
				
			}else if(type.equals("RES")){
	// 이미 다른곳에서 구현됨 completeReservationPayment(map);

			}else if(type.equals("REG")){
			    completeRegistrationPayment(map);
			}

			result.put("result", "success");
			result.put("payNo", map.get("payNo"));
			result.put("message", "결제 완료");

		} catch (Exception e) {
			e.printStackTrace();
			//예외 발생시 환불
			try {
				String impUid = map.get("imp_uid").toString();

	            if (impUid != null) {
	                String token = getToken();
	                cancelPayment(token, impUid);
	            }
	        } catch (Exception ex) {
	            ex.printStackTrace();
	        }
			
			result.put("result", "fail");
			result.put("message", "서버 오류");
			
		}

		return result;
	}
	public HashMap<String, Object> verifyPayment2(HashMap<String, Object> map) {
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
			
			int finalAmount = reqAmount;
			// 4. 금액 검증
			if (realAmount != finalAmount) {
				cancelPayment(token, impUid);
				result.put("result", "fail");
				result.put("message", "금액 위조 의심");
				return result;
			}

			// 5. DB 저장
			map.put("pay_status", "paid");
			map.put("finalAmount", finalAmount);

			completeRegistrationPayment(map);
		
			result.put("result", "success");
			result.put("payNo", map.get("payNo"));
			result.put("message", "결제 완료");

		} catch (Exception e) {
			e.printStackTrace();
			//예외 발생시 환불
			try {
				String impUid = map.get("imp_uid").toString();

	            if (impUid != null) {
	                String token = getToken();
	                cancelPayment(token, impUid);
	            }
	        } catch (Exception ex) {
	            ex.printStackTrace();
	        }
			
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
	
	// 패스 환불
	@Transactional
	public HashMap<String, Object> refundPass(HashMap<String, Object> map) {

		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			HashMap<String, Object> info = paymentMapper.selectRefundPassInfo(map);

			if (info == null) {
				resultMap.put("result", "fail");
				resultMap.put("message", "결제정보 없음");
				return resultMap;
			}

			if ("REFUND".equals(String.valueOf(info.get("pay_status")))) {
				resultMap.put("result", "fail");
				resultMap.put("message", "이미 환불된 결제입니다.");
				return resultMap;
			}

			int reviewCnt = Integer.parseInt(String.valueOf(info.get("reviewCnt")));
			int remain = Integer.parseInt(String.valueOf(info.get("remainingCount")));

			// 사용했으면 환불 불가
			if (remain < reviewCnt) {
				resultMap.put("result", "fail");
				resultMap.put("message", "이미 패스권보다 많은 열람권을 사용하여 환불 불가합니다.");
				return resultMap;
			}
			System.out.println("1. 환불 시작");

			String token = getToken();
			
			System.out.println("2. 토큰 완료");
			
			boolean success = cancelPayment(token, info.get("impUid").toString());

			System.out.println("3. 포트원 환불 완료");

			if (!success) {
				throw new RuntimeException();
			}
            
			// 1. 열람권 차감
			paymentMapper.minusWallet(map);

			// 2. 결제상태 환불
			paymentMapper.updateRefundPayment(map);
			System.out.println("4. payment 상태 변경 완료");
			// 3. 패스권 상태 환불
			paymentMapper.updateRefundPass(map);

			resultMap.put("result", "success");
			resultMap.put("message", "패스권 환불 완료");

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", "서버 오류");
		}

		return resultMap;
	}
	
	public boolean cancelPayment(String token, String impUid) throws Exception {

	    URL url = new URL("https://api.iamport.kr/payments/cancel");

	    HttpURLConnection conn =
	        (HttpURLConnection) url.openConnection();

	    conn.setRequestMethod("POST");
	    conn.setRequestProperty("Content-Type","application/json");
	    conn.setRequestProperty("Authorization", token);
	    conn.setDoOutput(true);

	    String json =
	        "{ \"imp_uid\":\""+impUid+"\" }";

	    OutputStream os = conn.getOutputStream();
	    os.write(json.getBytes("UTF-8"));
	    os.flush();
	    os.close();

	    return conn.getResponseCode() == 200;
	}
	
	public String getAccessToken() throws Exception {

	    URL url = new URL("https://api.iamport.kr/users/getToken");
	    HttpURLConnection conn = (HttpURLConnection) url.openConnection();

	    conn.setRequestMethod("POST");
	    conn.setRequestProperty("Content-Type","application/json");
	    conn.setDoOutput(true);

	    String jsonInput =
	      "{ \"imp_key\":\"" + impKey + "\"," +
	      "\"imp_secret\":\"" + impSecret + "\" }";

	    OutputStream os = conn.getOutputStream();
	    os.write(jsonInput.getBytes("UTF-8"));
	    os.flush();
	    os.close();

	    BufferedReader br =
	      new BufferedReader(new InputStreamReader(conn.getInputStream(),"UTF-8"));

	    String line;
	    String result = "";

	    while((line = br.readLine()) != null){
	        result += line;
	    }

	    JsonObject json = JsonParser.parseString(result).getAsJsonObject();

	    return json.get("response")
	               .getAsJsonObject()
	               .get("access_token")
	               .getAsString();
	}
	
	// 쿠폰 조회
	// 쿠폰 조회
	public HashMap<String, Object> getCouponUseList(HashMap<String, Object> map) {

	    HashMap<String, Object> resultMap = new HashMap<>();

	    try {

	        // 만료된 UNUSED 쿠폰 자동 EXPIRED 처리 (선택사항)
	        paymentMapper.updateExpiredCoupon(map);
	        // 페이지네이션
	        int totalCount = paymentMapper.selectMyCouponCount(map);
	        // 사용 가능한 쿠폰 조회
	        resultMap.put("list", paymentMapper.selectCouponUseList(map));
			resultMap.put("totalCount", totalCount);
	        resultMap.put("result", "success");

	    } catch (Exception e) {
	        e.printStackTrace();

	        resultMap.put("result", "fail");
	        resultMap.put("list", null);
	        resultMap.put("message", "쿠폰 조회 실패");
	    }

	    return resultMap;
	}
	
	// 쿠폰 검증
//	public void validateCoupon(Map map) {
//
//	    // 1. 쿠폰 조회
//	    Coupon c = mapper.selectUserCoupon(map);
//
//	    if (c == null) throw new RuntimeException("쿠폰 없음");
//
//	    // 2. 사용 여부
//	    if (!"UNUSED".equals(c.getStatus()))
//	        throw new RuntimeException("이미 사용된 쿠폰");
//
//	    // 3. 만료 체크
//	    if (c.getExpiredAt().isBefore(LocalDateTime.now()))
//	        throw new RuntimeException("쿠폰 만료");
//
//	}
	
	@Transactional
	public HashMap<String, Object> refundAdminReservation(HashMap<String, Object> map) {

	    HashMap<String, Object> resultMap = new HashMap<>();

	    try {

	        // 1. 예약 + 결제 정보 조회
	        HashMap<String, Object> reservation = paymentMapper.selectAdminReservation(map);

	        if (reservation == null) {
	            resultMap.put("result", "fail");
	            resultMap.put("message", "예약 정보 없음");
	            return resultMap;
	        }

	        int dday = Integer.parseInt(String.valueOf(reservation.get("dday")));
	        int payAmount = Integer.parseInt(String.valueOf(reservation.get("amount")));
	        String impUid = String.valueOf(reservation.get("impUid"));

	        int refundAmount = payAmount;

	        // 2. 환불 정책 (스드메 기준)
	        if (dday < 7) {
	            resultMap.put("result", "fail");
	            resultMap.put("message", "환불 불가 (기간초과)");
	            return resultMap;
	        }

	        // 3. 토큰 발급 (이미 존재 메소드)
	        String token = getToken();

	        // 4. 결제 취소 (이미 존재 메소드 재사용)
	        boolean cancelResult = cancelPayment(token, impUid);

	        if (!cancelResult) {
	            resultMap.put("result", "fail");
	            resultMap.put("message", "결제 취소 실패");
	            return resultMap;
	        }

	        // 5. DB 업데이트
	        

	        map.put("refundAmount", refundAmount);
	        map.put("impUid", impUid);


	        paymentMapper.updateRefundReservation(map);
	        paymentMapper.updateRefundReservation2(map);
	        
	        resultMap.put("impUid", impUid);
	        resultMap.put("result", "success");
	        resultMap.put("refundAmount", refundAmount);
	        resultMap.put("message", "환불 완료");

	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "error");
	        resultMap.put("message", "서버 오류 발생");
	    }

	    return resultMap;
	}
	
	//예약 결제
	public HashMap<String, Object> verifyPayment3(HashMap<String, Object> map) {
		System.out.println("전달받은 맵: " + map);
	    HashMap<String, Object> result = new HashMap<>();
		

	    try {

	        String impUid = map.get("imp_uid").toString();
	        int reqAmount = Integer.parseInt(map.get("amount").toString());

	        String token = getToken();
	        HashMap<String, Object> payInfo = getPaymentInfo(token, impUid);

	        int realAmount = (int) payInfo.get("amount"); 
	        String status = payInfo.get("status").toString();

	        if (!status.equals("paid")) {
	            result.put("result", "fail");
	            result.put("message", "결제 미완료");
	            return result;
	        }

	        if (realAmount != reqAmount) {
	            cancelPayment(token, impUid);
	            result.put("result", "fail");
	            result.put("message", "금액 위조 의심");
	            return result;
	        }
	        
	        String merchantUid = map.get("merchant_uid").toString();
	        result.put("result", "success");
	        result.put("impUid", impUid);
	        result.put("message", "결제 완료");
	        result.put("amount", realAmount);
	        
	        System.out.println(map);
	        result.put("merchantUid", merchantUid);
	        result.put("impUid", impUid);
	        System.out.println(map);
	        
	        result.put("result", "success");
	        result.put("message", "결제 완료");
	    } catch (Exception e) {
	        e.printStackTrace();
	        result.put("result", "fail");
	        result.put("message", "서버 오류");
	    }

	    return result;
	}
}