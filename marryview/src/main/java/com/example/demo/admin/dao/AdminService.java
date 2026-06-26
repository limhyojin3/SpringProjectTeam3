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
import org.springframework.beans.factory.annotation.Value;
import java.util.ArrayList;

@Service
public class AdminService {
	
	@Autowired
	AdminMapper adminMapper;
	
	@Autowired
	NotificationService notificationService;
	
	@Value("${cloudinary.cloud-name}")
	private String cloudinaryCloudName;
	
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
	
	public HashMap<String, Object> getReceiptReviewDetail(
	        HashMap<String, Object> map) {

	    HashMap<String, Object> resultMap =
	            new HashMap<>();

	    try {
	        HashMap<String, Object> detail =
	                adminMapper
	                    .selectReceiptReviewDetail(map);

	        if (detail == null) {
	            resultMap.put("result", "fail");
	            resultMap.put(
	                "message",
	                "리뷰 정보를 찾을 수 없습니다."
	            );
	            return resultMap;
	        }

	        String receiptName =
	                stringValue(
	                    detail.get("receiptName")
	                );

	        detail.put(
	        	    "receiptUrl",
	        	    buildCloudinaryImageUrl(receiptName)
	        	);

	        boolean hasReceipt =
	                receiptName != null
	                && !receiptName.isBlank();

	        boolean reservationLinked =
	                numberValue(
	                    detail.get("reservationLinked")
	                ) > 0;

	        boolean internalCatalog =
	                detail.get("companyNo") != null;

	        if (reservationLinked) {
	            detail.put(
	                "evidenceScope",
	                "INTERNAL_TRANSACTION"
	            );
	            detail.put(
	                "evidenceLabel",
	                "메리뷰 예약 정보 연동"
	            );
	            detail.put(
	                "evidenceDescription",
	                "메리뷰 예약 정보와 제출 증빙을 함께 확인할 수 있습니다."
	            );

	        } else if (internalCatalog) {
	            detail.put(
	                "evidenceScope",
	                "INTERNAL_CATALOG"
	            );
	            detail.put(
	                "evidenceLabel",
	                "메리뷰 등록 업체·상품"
	            );
	            detail.put(
	                "evidenceDescription",
	                "등록 업체·상품 정보는 있으나 메리뷰 예약·결제와 연동된 리뷰는 아닙니다."
	            );

	        } else {
	            detail.put(
	                "evidenceScope",
	                "EXTERNAL_EVIDENCE"
	            );
	            detail.put(
	                "evidenceLabel",
	                "외부 업체 증빙 제출"
	            );
	            detail.put(
	                "evidenceDescription",
	                "메리뷰 정보망 밖의 거래로 실제 결제 여부까지 확인할 수 없습니다."
	            );
	        }

	        List<HashMap<String, Object>> warnings =
	                new ArrayList<>();

	        if (!hasReceipt) {
	            warnings.add(
	                warning(
	                    "MISSING_RECEIPT",
	                    "HIGH",
	                    "첨부된 영수증 또는 결제 증빙이 없습니다."
	                )
	            );
	        }

	        if (!reservationLinked
	                && internalCatalog) {

	            warnings.add(
	                warning(
	                    "NOT_TRANSACTION_LINKED",
	                    "INFO",
	                    "업체·상품 선택 정보만 존재합니다. 메리뷰 예약 또는 결제 완료를 의미하지 않습니다."
	                )
	            );
	        }

	        if (!internalCatalog) {
	            warnings.add(
	                warning(
	                    "EXTERNAL_VERIFICATION_LIMIT",
	                    "INFO",
	                    "외부 업체 거래는 진위를 보증하지 않고, 증빙과 리뷰 사이의 명백한 모순만 검토합니다."
	                )
	            );
	        }

	        detail.put(
	            "reviewStatus",
	            hasReceipt
	                ? "MANUAL_REVIEW"
	                : "REVIEW_REQUIRED"
	        );

	        detail.put("warnings", warnings);

	        detail.put(
	            "policyNotice",
	            "확인할 수 없음과 허위를 구분합니다. 자동 결과만으로 승인 또는 반려하지 않습니다."
	        );

	        resultMap.put("detail", detail);
	        resultMap.put("result", "success");

	    } catch (Exception e) {
	        System.out.println(e.getMessage());

	        resultMap.put("result", "fail");
	        resultMap.put(
	            "message",
	            Message.MSG_SERVER_ERR
	        );
	    }

	    return resultMap;
	}

	private HashMap<String, Object> warning(
	        String type,
	        String level,
	        String message) {

	    HashMap<String, Object> warning =
	            new HashMap<>();

	    warning.put("type", type);
	    warning.put("level", level);
	    warning.put("message", message);

	    return warning;
	}

	private int numberValue(Object value) {
	    return value instanceof Number
	            ? ((Number) value).intValue()
	            : 0;
	}

	private String stringValue(Object value) {
	    return value == null
	            ? null
	            : String.valueOf(value);
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
			
			 int updated = adminMapper.updateAnswer(map);

		        resultMap.put(
		            "result",
		            updated > 0 ? "success" : "fail"
		        );
		        resultMap.put(
		            "message",
		            updated > 0
		                ? Message.MSG_EDIT
		                : "문의 답변 대상이 없습니다."
		        );
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
	    String answerContent = String.valueOf(map.getOrDefault("answerContent", "")).trim();

	    if (answerContent.isEmpty()) {
	        resultMap.put("result", "fail");
	        resultMap.put("message", "신고자에게 보낼 답변을 입력해주세요.");
	        return resultMap;
	    }

	    try {
	        int updated = adminMapper.updateReportApprove(map);

	        if (updated == 0) {
	            resultMap.put("result", "fail");
	            resultMap.put("message", "이미 처리되었거나 존재하지 않는 신고입니다.");
	            return resultMap;
	        }

	        resultMap.put("result", "success");
	        resultMap.put("message", "신고 승인 처리가 완료되었습니다.");
	    } catch (Exception e) {
	        resultMap.put("result", "fail");
	        resultMap.put("message", Message.MSG_SERVER_ERR);
	        throw e;
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
	@Transactional
	public HashMap<String, Object> rejectReport(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    String answerContent = String.valueOf(map.getOrDefault("answerContent", "")).trim();

	    if (answerContent.isEmpty()) {
	        resultMap.put("result", "fail");
	        resultMap.put("message", "신고자에게 보낼 답변을 입력해주세요.");
	        return resultMap;
	    }

	    try {
	        int updated = adminMapper.updateReportReject(map);

	        if (updated == 0) {
	            resultMap.put("result", "fail");
	            resultMap.put("message", "이미 처리되었거나 존재하지 않는 신고입니다.");
	            return resultMap;
	        }

	        resultMap.put("result", "success");
	        resultMap.put("message", "신고 반려 처리가 완료되었습니다.");
	    } catch (Exception e) {
	        resultMap.put("result", "fail");
	        resultMap.put("message", Message.MSG_SERVER_ERR);
	        throw e;
	    }

	    return resultMap;
	}
	
	// 답변 전송 성공
	public boolean completeReportAnswer(HashMap<String, Object> map) {
	    return adminMapper.updateReportAnswerStatus(map) > 0;
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
			int memberResult = adminMapper.updateCompanyReg(map);
			int companyResult = adminMapper.updateCompanyRegPaid(map);

			if (memberResult > 0 && companyResult > 0) {
				resultMap.put("result", "success");
				resultMap.put("message", "제휴 업체 등록에 성공했습니다");
			} else {
				throw new IllegalStateException(
					"제휴 업체 등록 대상이 존재하지 않거나 이미 처리되었습니다."
				);
			}


		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", "제휴 업체 등록에 실패했습니다");

			throw e; // 트랜잭션 롤백
		}

		return resultMap;
	}
	
	private String buildCloudinaryImageUrl(
	        String storedName) {

	    if (storedName == null
	            || storedName.isBlank()) {
	        return null;
	    }

	    // 과거 데이터가 전체 URL이면 그대로 사용
	    if (storedName.startsWith("http://")
	            || storedName.startsWith("https://")) {
	        return storedName;
	    }

	    return "https://res.cloudinary.com/"
	            + cloudinaryCloudName
	            + "/image/upload/"
	            + storedName;
	}
}