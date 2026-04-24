package com.example.demo.admin.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import com.example.demo.admin.mapper.AdminMapper;
import com.example.demo.admin.model.Admin;
import com.example.demo.common.Message;
import java.util.Map;

@Service
public class AdminService {
	@Autowired
	AdminMapper adminMapper;
	
	public HashMap<String, Object> getSalesList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Admin> list = adminMapper.selectSalesList(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	public HashMap<String, Object> getclientsList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Admin> list = adminMapper.selectClientsList(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	public HashMap<String, Object> getReviewList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Admin> list = adminMapper.selectReviewList(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	public HashMap<String, Object> getReportList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Admin> list = adminMapper.selectReportList(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	public HashMap<String, Object> getPassList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Admin> list = adminMapper.selectPassList(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	public HashMap<String, Object> getPassInfo(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			Admin info = adminMapper.selectPassInfo(map);
			resultMap.put("info", info);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

public boolean getPayInfo(HashMap<String, Object> map) {
		
		String userId = (String) map.get("userId");
		String itemName = (String) map.get("itemName");
		int passNo = Integer.parseInt(String.valueOf(map.get("passNo").toString()));
	    int amount = Integer.parseInt(String.valueOf(map.get("amount").toString()));
	    
		// 1. 최소 검증
		if (userId == null || userId.isEmpty()) {
			return false;
		}
		if (amount <= 0) {
			return false;
		}
		// 2. DB 가격 조회
		int dbPrice = adminMapper.selectPriceInfo(passNo);
		// 3. 비교
		return dbPrice == amount;
	}
	
	public int getPriceInfo(int passNo) {
		return adminMapper.selectPriceInfo(passNo);
	}

	public int addPayment(HashMap<String, Object> map) {
	    return adminMapper.insertPayment(map);
	}

	public int addPaymentPass(HashMap<String, Object> map) {
	    return adminMapper.insertPaymentPass(map);
	}
	
	@Transactional
	public void completePayment(HashMap<String, Object> map) {
		adminMapper.insertPayment(map);
		adminMapper.insertPaymentPass(map);
	}
	
	public HashMap<String, Object> getInquiryList(Map<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Admin> list = adminMapper.selectInquiryList(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	public HashMap<String, Object> addAnswer(Map<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			int count = adminMapper.checkAnswer(map);   

		    if(count > 0) {
		    	adminMapper.updateAnswer(map); 
		    	resultMap.put("result", "success");
				resultMap.put("message", Message.MSG_EDIT);
		    } else {
		    	adminMapper.insertAnswer(map);
				resultMap.put("result", "success");
				resultMap.put("message", Message.MSG_ADD);
			}

		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	
	// 관리자 전체 회원목록 페이지
	public HashMap<String, Object> getUserList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Admin> list = adminMapper.selectUserList(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	
	// 관리자 전체 업체목록 페이지
	public HashMap<String, Object> getCompanyList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Admin> list = adminMapper.selectCompanyList(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	
	// 관리자 전체 회원목록 페이지 밴/해제 기능
	@Transactional
	public HashMap<String, Object> editMemberBan(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    try {
	        String actionType = (String) map.get("action_type");   // BAN / UNBAN

	        // 1. 정지 해제
	        if ("BAN".equals(actionType)) {
	            map.put("status", "STOP");
	        } else if ("UNBAN".equals(actionType)) {
	            map.put("status", "ACTIVE");
	        }
	        
	        adminMapper.updateMemberStatus(map);
	        
	        // 2. 이력 저장
	        adminMapper.insertBanHistory(map);

	        resultMap.put("result", Message.MSG_ADD);

	    } catch (Exception e) {
	        System.out.println(e.getMessage());
	        resultMap.put("result", Message.MSG_SERVER_ERR);
	        throw e; // 트랜잭션 롤백
	    }

	    return resultMap;
	}
	
	//정지 이력 조회
	public HashMap<String, Object> getBanHistory(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Admin> list = adminMapper.selectBanHistory(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	
	private final String IMP_KEY = "6441076133101874";
	 private final String IMP_SECRET = "0QLgaXVjWTQOZmnBlwbma7943DaRO8QiJkViTnqgLEuaqsSu27eLiaRxoQWQnlkPDNNjgIunttaxAPm0";
	    
	 // 결제 검증 핵심 로직
	 public boolean verifyPayment(HashMap<String, Object> map) {
		    int actualPaidAmount = 0;
		    int amount = 0;
		    int dbPrice = 0;

		    try {
		        String impUid = (String) map.get("imp_uid");
		        amount = Integer.parseInt(map.get("amount").toString());
		        int passNo = Integer.parseInt(map.get("passNo").toString());

		        // 1. 토큰 발급
		        String accessToken = getAccessToken();
		        
		        // 2. 포트원 실제 결제액 조회 (샌드박스 포함 필수!)
		        actualPaidAmount = getPaymentData(impUid, accessToken);

		        // 3. DB 상품 가격 조회
		        dbPrice = adminMapper.selectPriceInfo(passNo);

		        // --------------------------------------------------
		        // [중요] 여기서 서버(STS/Eclipse) 콘솔을 확인하세요!
		        // --------------------------------------------------
		        System.out.println("========= [결제 검증 상세 결과] =========");
		        System.out.println("1. 포트원 조회 금액 (A): " + actualPaidAmount);
		        System.out.println("2. 프론트 보낸 금액 (B): " + amount);
		        System.out.println("3. DB 등록 가격 (C): " + dbPrice);
		        System.out.println("========================================");

		        // 검증 성공 조건: A == B 이고 A == C 여야 함
		        boolean isMatch = (actualPaidAmount == amount) && (actualPaidAmount == dbPrice);
		        
		        if(!isMatch) {
		            System.out.println(">>> 검증 불일치 발생!");
		            if(actualPaidAmount == 0) System.out.println("사유: 포트원에서 결제 내역을 찾을 수 없음 (샌드박스 설정 확인 필요)");
		            if(actualPaidAmount != dbPrice) System.out.println("사유: 결제 금액과 DB 가격이 다름");
		        }

		        return isMatch;

		    } catch (Exception e) {
		        System.out.println("검증 중 에러: " + e.getMessage());
		        e.printStackTrace();
		        return false;
		    }
		}

	 private String getAccessToken() {
		    RestTemplate restTemplate = new RestTemplate();
		    String url = "https://api.iamport.kr/users/getToken";

		    // 1. 요청 바디 설정
		    Map<String, String> body = new HashMap<>();
		    body.put("imp_key", "6441076133101874");      // 본인의 API 키
		    body.put("imp_secret", "0QLgaXVjWTQOZmnBlwbma7943DaRO8QiJkViTnqgLEuaqsSu27eLiaRxoQWQnlkPDNNjgIunttaxAPm0"); // 본인의 Secret 키

		    try {
		        // 2. 포트원에 토큰 요청
		        Map response = restTemplate.postForObject(url, body, Map.class);
		        
		        // 3. 응답에서 response 객체 꺼내기
		        Map responseData = (Map) response.get("response");
		        
		        if (responseData != null && responseData.get("access_token") != null) {
		            String token = (String) responseData.get("access_token");
		            System.out.println(">>> 토큰 발급 성공: " + token); // 로그 확인용
		            return token;
		        }
		    } catch (Exception e) {
		        System.out.println("토큰 발급 중 에러: " + e.getMessage());
		    }
		    return null;
		}

   private int getPaymentData(String impUid, String accessToken) {
   	 RestTemplate restTemplate = new RestTemplate();
   	    
   	    String url = "https://api.iamport.kr/payments/" + impUid + "?include_sandbox=true";

   	    HttpHeaders headers = new HttpHeaders();
   	    headers.set("Authorization", accessToken);
   	    HttpEntity<String> entity = new HttpEntity<>(headers);

   	    try {
   	        ResponseEntity<Map> response = restTemplate.exchange(url, HttpMethod.GET, entity, Map.class);
   	        Map responseData = (Map) response.getBody().get("response");
   	        
   	        if (responseData == null) return 0;
   	        
   	        // 포트원은 금액을 숫자로 주므로 안전하게 변환
   	        return Integer.parseInt(String.valueOf(responseData.get("amount")));
   	    } catch (Exception e) {
   	        System.out.println("포트원 조회 중 진짜 에러 발생: " + e.getMessage());
   	        return 0;
   	    }
   }
}