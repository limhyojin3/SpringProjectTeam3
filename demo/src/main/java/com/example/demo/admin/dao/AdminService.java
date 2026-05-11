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

	public HashMap<String, Object> getAllClientsCount(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			int count  = adminMapper.selectAllClientsCount(map);
			resultMap.put("count", count);
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
	
	public HashMap<String, Object> getAllPartnersCount(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			int count  = adminMapper.selectAllPartnersCount(map);
			resultMap.put("count", count);
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
			int totalCount = adminMapper.selectReviewCount(map);

			resultMap.put("list", list);
			resultMap.put("totalCount", totalCount);
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
	
	public HashMap<String, Object> editReviewApprove(HashMap<String, Object> map) {

		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			adminMapper.updateReviewApprove(map);

			resultMap.put("result", "success");

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			throw e; // 트랜잭션 롤백
		}

		return resultMap;
	}
	
	public HashMap<String, Object> editReviewReject(HashMap<String, Object> map) {

		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			adminMapper.updateReviewReject(map);

			resultMap.put("result", "success");

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			throw e; // 트랜잭션 롤백
		}

		return resultMap;
	}

	// 신고 목록 검색어 및 필터 조회
	public HashMap<String, Object> getReportList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Admin> list = adminMapper.selectReportList(map);
			int totalCount = adminMapper.selectReportCount(map);
			List<Admin> killList = adminMapper.selectKillHistory(map);
			
			resultMap.put("list", list);
			resultMap.put("totalCount", totalCount);
			resultMap.put("killList", killList);
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
		String type = String.valueOf(map.get("type"));

		int amount = Integer.parseInt(String.valueOf(map.get("amount").toString()));

		int dbPrice = 0;

		// 1. 최소 검증
		if (userId == null || userId.isEmpty()) {
			return false;
		}
		if (amount <= 0) {
			return false;
		}
		// 2. 결제 종류별 가격 조회
		if ("PASS".equals(type)) {

			int passNo = Integer.parseInt(String.valueOf(map.get("passNo")));

			dbPrice = adminMapper.selectPriceInfo(passNo);

		} else if ("REG".equals(type)) {

			dbPrice = 1000; // 등록비 고정금액

		} else if ("RES".equals(type)) {

			dbPrice = amount; // 임시

		} else {

			return false;

		}
		// 3. 비교
		return dbPrice == amount;
	}

	public int getPriceInfo(int passNo) {
		return adminMapper.selectPriceInfo(passNo);
	}

	public int addPayment(HashMap<String, Object> map) {
		return adminMapper.insertPayment1(map);
	}

//	public int addPaymentPass(HashMap<String, Object> map) {
//		return adminMapper.insertPaymentPass(map);
//	}

	

	public HashMap<String, Object> getPaymentByPayNo(int payNo) {
		return adminMapper.selectPaymentByPayNo(payNo);
	}

	public HashMap<String, Object> getPaymentFinishInfo(HashMap<String, Object> map) {

		String type = map.get("type").toString();

		if (type.equals("PASS")) {
			return adminMapper.selectPassPayment(map);
		} else if (type.equals("RES")) {
			return adminMapper.selectReservationPayment(map);
		} else if (type.equals("REG")) {
			return adminMapper.selectRegistrationPayment(map);
		}

		return new HashMap<>();
	}

	public HashMap<String, Object> getInquiryList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Admin> list = adminMapper.selectInquiryList(map);
			int totalCount = adminMapper.selectInquiryCount(map);
			
			resultMap.put("list", list);
			resultMap.put("result", "success");
	        resultMap.put("totalCount", totalCount);
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	public HashMap<String, Object> editAnswer(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			
			adminMapper.updateAnswer(map);
			resultMap.put("message", Message.MSG_EDIT);
			
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	
	public HashMap<String, Object> editAnswerStatus(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			
			adminMapper.updateInquiryStatus(map);
			resultMap.put("message", Message.MSG_EDIT);
			
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
			int totalCount = adminMapper.selectUserCount(map);

			resultMap.put("list", list);
			resultMap.put("totalCount", totalCount);

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

	// 관리자 회원 상세 조회
	public HashMap<String, Object> getUserDetail(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			Admin user = adminMapper.selectUserDetail(map);

			resultMap.put("user", user);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);

		} catch (Exception e) {
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
			int totalCount = adminMapper.selectCompanyCount(map);

			resultMap.put("list", list);
			resultMap.put("totalCount", totalCount);

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

	// 관리자 업체 상세 조회
	public HashMap<String, Object> getCompanyDetail(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			Admin company = adminMapper.selectCompanyDetail(map);

			resultMap.put("company", company);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);

		} catch (Exception e) {
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
			String actionType = (String) map.get("action_type"); // BAN / UNBAN

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

	// 정지 이력 조회
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

	// 목록에서 신고승인인듯?
	@Transactional
	public HashMap<String, Object> approveReport(HashMap<String, Object> map) {

		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			// 1. 신고 처리 완료 (action_status = 1)
			adminMapper.updateReportApprove(map);

			// 2. 신고 누적 수 조회 (승인된 것만)
//			int count = adminMapper.selectReportHistory(map);
			// 신고수 1이상인 회원 조회
			
			// 3. 3회 이상이면 자동 정지
//			if (count >= 3) {
//
//				map.put("status", "STOP");
//				adminMapper.updateMemberStatus(map);
//
//				// 이력 기록
//				map.put("action_type", "BAN");
//				map.put("reason", "신고 누적 3회 자동 정지");
//
//				adminMapper.insertBanHistory(map);
//			}
//			resultMap.put("count", count);
			resultMap.put("result", "success");

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			throw e; // 트랜잭션 롤백
		}

		return resultMap;
	}

	// 회원 상세 신고 누적횟수, 이력 조회
	public HashMap<String, Object> getReportInfoList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			List<Admin> list = adminMapper.selectReportInfoList(map);
			int reportCount = adminMapper.selectReportHistory(map);

			resultMap.put("list", list);
			resultMap.put("count", reportCount);
			resultMap.put("result", "success");

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}

		return resultMap;
	}

	// 신고관리 일괄 신고 승인
	@Transactional
	public HashMap<String, Object> batchApproveReport(HashMap<String, Object> map) {

		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			// 1. 신고 일괄 처리
			adminMapper.batchApproveReport(map);
			// 2. 신고 누적 수 조회 (신고게시판 전체)
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_EDIT);

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
			throw e; // 트랜잭션 롤백
		}

		return resultMap;
	}
	
	public HashMap<String, Object> reportBatchReject(HashMap<String, Object> map) {
	    HashMap<String, Object> result = new HashMap<>();

	    try {
	        adminMapper.batchReject(map);
	        result.put("result", "success");
	    } catch (Exception e) {
	        result.put("result", "fail");
	    }

	    return result;
	}

	// 신고 상세 조회
	public HashMap<String, Object> getReportDetail(HashMap<String, Object> map) {

		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			Admin info = adminMapper.selectReportDetail(map);

			resultMap.put("info", info);
			resultMap.put("result", "success");

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}

		return resultMap;
	}

	// 신고 반려
	public HashMap<String, Object> rejectReport(HashMap<String, Object> map) {
		System.out.println("reportReject map: " + map);
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			int result = adminMapper.updateReportReject(map);
			System.out.println("update result: " + result);
			resultMap.put("result", "success");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}

		return resultMap;
	}
	
	// 댓글로 게시판 추적
	public HashMap<String, Object> adminCommentTargetPost(HashMap<String, Object> map) {

		HashMap<String, Object> resultMap = new HashMap<>();

		try {

			Integer postNo = adminMapper.selectCommentPostNo(map);

			if (postNo == null) {
				Integer reviewNo = adminMapper.selectComentReviewNo(map);
//				postNo = adminMapper.selectParentCommentPostNo(map);
				resultMap.put("result", "success");
				resultMap.put("reviewNo", reviewNo);
			}

			if (postNo != null) {
				resultMap.put("result", "success");
				resultMap.put("postNo", postNo);
			}

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", "조회 실패");
		}
System.out.println(resultMap);
		return resultMap;
	}
	
	

	// 게시판 전체 목록
	public HashMap<String, Object> getBoardList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Admin> list = adminMapper.selectBoardList(map);
			int totalCount = adminMapper.selectBoardCount(map);

			resultMap.put("list", list);
			resultMap.put("totalCount", totalCount);

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
	
	// 게시판 삭제하는척만
	public HashMap<String, Object> editBoardApprove(HashMap<String, Object> map) {

		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			
			adminMapper.updateBoardApprove(map);

			resultMap.put("result", "success");

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			throw e; // 트랜잭션 롤백
		}

		return resultMap;
	}
	
	// 게시판 상세
	public HashMap<String, Object> getPostDetail(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			Admin post = adminMapper.selectPostDetail(map);

			resultMap.put("post", post);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

	// 결제 관리
	public HashMap<String, Object> getPaymentList(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		result.put("list", adminMapper.selectPaymentList(map));
		result.put("totalCount", adminMapper.selectPaymentCount(map));
		return result;
	}

	public HashMap<String, Object> getPassPaymentList(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		result.put("list", adminMapper.selectPassPaymentList(map));
		result.put("totalCount", adminMapper.selectPassPaymentCount(map));
		return result;
	}

	public HashMap<String, Object> getReservationPaymentList(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		result.put("list", adminMapper.selectReservationPaymentList(map));
		result.put("totalCount", adminMapper.selectReservationPaymentCount(map));
		return result;
	}

	public HashMap<String, Object> getRegistrationPaymentList(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		result.put("list", adminMapper.selectRegistrationPaymentList(map));
		result.put("totalCount", adminMapper.selectRegistrationPaymentCount(map));
		return result;
	}

// 상품 관리
	// 🔹 상품
	public HashMap<String, Object> getAdminProductList(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		try {
			List<Admin> list = adminMapper.selectAdminProductList(map);
			int count = adminMapper.selectAdminProductCount(map);

			result.put("list", list);
			result.put("totalCount", count);
			result.put("result", "success");
			result.put("message", "상품 조회 성공");

		} catch (Exception e) {
			result.put("result", "fail");
			result.put("message", "상품 조회 실패");
			e.printStackTrace();
		}

		return result;
	}

	// 상품 상태 변경
	public HashMap<String, Object> updateProductStatus(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {

			int cnt = adminMapper.updateProductStatus(map);

			resultMap.put("result", "success");
			resultMap.put("message", "상태가 변경되었습니다.");

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", "상태 변경 실패");
		}

		return resultMap;
	}

	// 상품 삭제
	public HashMap<String, Object> deleteProduct(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			adminMapper.deleteProduct(map);

			resultMap.put("result", "success");
			resultMap.put("message", "삭제되었습니다.");

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", "삭제 실패");
		}

		return resultMap;
	}

	// 상품 상세 조회
	public HashMap<String, Object> selectProductInfo(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			Admin info = adminMapper.selectProductInfo(map);

			resultMap.put("result", "success");
			resultMap.put("info", info);

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", "상세조회 실패");
		}

		return resultMap;
	}

// 🔹 쿠폰
	public HashMap<String, Object> getCouponList(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		try {
			List<Admin> list = adminMapper.selectCouponList(map);
			int count = adminMapper.selectCouponCount(map);

			result.put("list", list);
			result.put("totalCount", count);
			result.put("result", "success");
			result.put("message", "쿠폰 조회 성공");

		} catch (Exception e) {
			result.put("result", "fail");
			result.put("message", "쿠폰 조회 실패");
			e.printStackTrace();
		}

		return result;
	}

	public HashMap<String, Object> addCoupon(HashMap<String, Object> map) {

		HashMap<String, Object> resultMap = new HashMap<>();

		try {

			int cnt = adminMapper.insertCoupon(map);

			if (cnt > 0) {
				resultMap.put("result", "success");
				resultMap.put("message", "쿠폰이 등록되었습니다.");
			} else {
				resultMap.put("result", "fail");
				resultMap.put("message", "쿠폰 등록 실패");
			}

		} catch (Exception e) {
			e.printStackTrace();

			resultMap.put("result", "fail");
			resultMap.put("message", "오류 발생");
		}

		return resultMap;
	}

	public HashMap<String, Object> deleteCoupon(HashMap<String, Object> map) {

		HashMap<String, Object> resultMap = new HashMap<>();

		try {

			int cnt = adminMapper.deleteCoupon(map);

			if (cnt > 0) {
				resultMap.put("result", "success");
				resultMap.put("message", "쿠폰이 삭제되었습니다.");
			} else {
				resultMap.put("result", "fail");
				resultMap.put("message", "삭제 실패");
			}

		} catch (Exception e) {
			e.printStackTrace();

			resultMap.put("result", "fail");
			resultMap.put("message", "오류 발생");
		}

		return resultMap;
	}

	// 🔹 패스
	public HashMap<String, Object> getAllPassList(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		try {
			List<Admin> list = adminMapper.selectAllPassList(map);
			int count = adminMapper.selectPassCount(map);

			result.put("list", list);
			result.put("totalCount", count);
			result.put("result", "success");
			result.put("message", "패스 조회 성공");

		} catch (Exception e) {
			result.put("result", "fail");
			result.put("message", "패스 조회 실패");
			e.printStackTrace();
		}

		return result;
	}

	public HashMap<String, Object> editPassStatus(HashMap<String, Object> map) {

		HashMap<String, Object> resultMap = new HashMap<>();

		try {

			int cnt = adminMapper.updatePassStatus(map);

			if (cnt > 0) {
				resultMap.put("result", "success");
				resultMap.put("message", "상태가 변경되었습니다.");
			} else {
				resultMap.put("result", "fail");
				resultMap.put("message", "변경 실패");
			}

		} catch (Exception e) {
			e.printStackTrace();

			resultMap.put("result", "fail");
			resultMap.put("message", "오류 발생");
		}

		return resultMap;
	}

	// 패스 등록
	public HashMap<String, Object> addPass(HashMap<String, Object> map) {

		HashMap<String, Object> resultMap = new HashMap<>();

		try {

			map.put("price", Integer.parseInt(map.get("price").toString()));

			int cnt = adminMapper.insertPass(map);

			if (cnt > 0) {
				resultMap.put("result", "success");
				resultMap.put("message", "등록되었습니다.");
			} else {
				resultMap.put("result", "fail");
				resultMap.put("message", "등록 실패");
			}

		} catch (Exception e) {
			e.printStackTrace();

			resultMap.put("result", "fail");
			resultMap.put("message", "오류 발생");
		}

		return resultMap;
	}

	// 패스 삭제
	public HashMap<String, Object> removePass(HashMap<String, Object> map) {

		HashMap<String, Object> resultMap = new HashMap<>();

		try {

			int cnt = adminMapper.deletePass(map);

			if (cnt > 0) {
				resultMap.put("result", "success");
				resultMap.put("message", "삭제되었습니다.");
			} else {
				resultMap.put("result", "fail");
				resultMap.put("message", "삭제 실패");
			}

		} catch (Exception e) {
			e.printStackTrace();

			resultMap.put("result", "fail");
			resultMap.put("message", "오류 발생");
		}

		return resultMap;
	}
	
	// 마이 패스 페이지
	public HashMap<String, Object> getMyPassList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Admin> list = adminMapper.selectMyPassList(map);
			int totalCount = adminMapper.selectMyPassCount(map);

			Integer remainingCount = adminMapper.selectMyWallet(map);

			resultMap.put("list", list);
			resultMap.put("totalCount", totalCount);
			resultMap.put("remainingCount", remainingCount != null ? remainingCount : 0);
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
	
	//제휴 등록
	@Transactional
	public HashMap<String, Object> editCompanyReg(HashMap<String, Object> map) {

		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			adminMapper.updateCompanyReg(map);
			adminMapper.updateCompanyRegPaid(map);
			resultMap.put("result", "success");
			resultMap.put("message", "제휴 업체 등록에 성공했습니다");


		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", "제휴 업체 등록에 실패했습니다");

			throw e; // 트랜잭션 롤백
		}

		return resultMap;
	}
}