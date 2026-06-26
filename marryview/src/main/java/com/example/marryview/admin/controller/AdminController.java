package com.example.marryview.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.marryview.admin.dao.AdminService;
import com.example.marryview.admin.dao.NotificationService;
import com.example.marryview.admin.model.Admin;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpServletRequest;

@Controller
public class AdminController {

	@Autowired
	AdminService adminService;

	@Autowired
	NotificationService notificationService;

	@RequestMapping("/adminMain.do")
	public String main(Model model) throws Exception {
		return "admin/adminMain";
	}

	@RequestMapping("/adminReview.do")
	public String Review(Model model) throws Exception {
		return "admin/adminReview";
	}

	@RequestMapping("/adminStatistics.do")
	public String Statistics(Model model) throws Exception {
		return "admin/adminStatistics";
	}

	@RequestMapping("/adminReport.do")
	public String adminReport(Model model) throws Exception {
		return "admin/adminReport";
	}

	@RequestMapping("/adminUser.do")
	public String adminUserList(Model model) throws Exception {
		return "admin/adminUser";
	}

	// 관리자 회원 목록 상세 게시판
	@RequestMapping("/adminUserDetail.do")
	public String adminUserDetail() {
		return "admin/adminUserDetail";
	}

	@RequestMapping("/adminPass.do")
	public String adminPass(Model model) throws Exception {
		return "admin/adminPass";
	}

	@RequestMapping("/adminPayFinish.do")
	public String adminPayFinish(@RequestParam("payNo") int payNo, @RequestParam("type") String type, Model model) {

		HashMap<String, Object> map = new HashMap<>();
		map.put("payNo", payNo);
		map.put("type", type);

		HashMap<String, Object> payment = adminService.getPaymentFinishInfo(map);

		model.addAttribute("payment", payment);
		model.addAttribute("type", type);

		return "admin/adminPayFinish";
	}

	@RequestMapping("/adminInquiry.do")
	public String adminInquiry(Model model) {
		return "admin/adminInquiry";
	}

	@RequestMapping("/adminCompany.do")
	public String adminCompany(Model model) {
		return "admin/adminCompany";
	}

	@RequestMapping("/adminCompanyDetail.do")
	public String adminCompanyDetail(Model model) {
		return "admin/adminCompanyDetail";
	}

	@RequestMapping("/adminBoard.do")
	public String adminBoard(Model model) {
		return "admin/adminBoard";
	}

	@RequestMapping("/adminBoardDetail.do")
	public String adminBoardDetail(Model model) {
		return "admin/adminBoardDetail";
	}

	@RequestMapping("/adminPayment.do")
	public String adminPayment(Model model) {
		return "admin/adminPayment";
	}

	@RequestMapping("/adminProduct.do")
	public String adminProduct(Model model) {
		return "admin/adminProduct";
	}

	@RequestMapping("/adminReservation.do")
	public String adminReservation(Model model) {
		return "admin/adminReservation";
	}

	@RequestMapping("/adminRegistration.do")
	public String adminRegistration(Model model) {
		return "admin/adminRegistration";
	}

	@RequestMapping("/adminMyPass.do")
	public String adminMyPass(Model model) {
		return "admin/adminMyPass";
	}
	
	//운영정책
	@RequestMapping("/operationPolicy.do")
	public String operationPolicy() {
	    return "/common/operation_policy";
	}

	@RequestMapping(value = "/sales.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String sales(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = adminService.getSalesList(map);

		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/clients.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String clients(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = adminService.getclientsList(map);

		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/allClients.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String allClients(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = adminService.getAllClientsCount(map);

		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/allPartners.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String allPartners(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = adminService.getAllPartnersCount(map);

		return new Gson().toJson(resultMap);
	}

	// 리뷰게시판 목록조회
	@RequestMapping(value = "/viewReview.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String viewReview(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		int pageSize = Integer.parseInt((String) map.get("pageSize"));
		int offSet = Integer.parseInt((String) map.get("offSet"));

		map.put("pageSize", pageSize);
		map.put("offSet", offSet);

		resultMap = adminService.getReviewList(map);

		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/receiptReviewDetail.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String receiptReviewDetail(@RequestParam HashMap<String, Object> map, HttpSession session) {

		if (!"ADMIN".equals(session.getAttribute("sessionRole"))) {

			HashMap<String, Object> denied = new HashMap<>();

			denied.put("result", "forbidden");
			denied.put("message", "관리자만 영수증 검토 정보를 확인할 수 있습니다.");

			return new Gson().toJson(denied);
		}

		return new Gson().toJson(adminService.getReceiptReviewDetail(map));
	}

	// 관리자 리뷰 승인
	@RequestMapping(value = "/reviewApprove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String editReviewApprove(Model model, @RequestParam HashMap<String, Object> map, HttpSession session)
			throws Exception {

		HashMap<String, Object> resultMap = new HashMap<>();

		resultMap = adminService.editReviewApprove(map);

		if ("success".equals(resultMap.get("result"))) {

			boolean notificationCreated = notificationService.createReviewResult(map.get("reviewNo"),
					(String) session.getAttribute("sessionId"), true);

			notificationService.createCompanyReviewReceived(map.get("reviewNo"));

			putNotificationResult(resultMap, notificationCreated);
		}

		return new Gson().toJson(resultMap);
	}

	// 관리자 리뷰 반려
	@RequestMapping(value = "/reviewReject.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String editReviewReject(@RequestParam HashMap<String, Object> map, HttpSession session) {
		HashMap<String, Object> resultMap = new HashMap<>();

		resultMap = adminService.editReviewReject(map);

		if ("success".equals(resultMap.get("result"))) {
			boolean notificationCreated = notificationService.createReviewResult(map.get("reviewNo"),
					(String) session.getAttribute("sessionId"), false);

			putNotificationResult(resultMap, notificationCreated);
		}

		return new Gson().toJson(resultMap);
	}

	// 신고게시판 검색어 필터 목록 조회
	@RequestMapping(value = "/viewReport.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String viewReport(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		int pageSize = Integer.parseInt((String) map.get("pageSize"));
		int offSet = Integer.parseInt((String) map.get("offSet"));

		map.put("pageSize", pageSize);
		map.put("offSet", offSet);

		resultMap = adminService.getReportList(map);

		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/pass.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String pass(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = adminService.getPassList(map);

		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/passCheck.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String passCheck(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = adminService.getPassInfo(map);

		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/inquiry.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String inquiry(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		int pageSize = Integer.parseInt((String) map.get("pageSize"));
		int offSet = Integer.parseInt((String) map.get("offSet"));

		map.put("pageSize", pageSize);
		map.put("offSet", offSet);

		resultMap = adminService.getInquiryList(map);

		return new Gson().toJson(resultMap);
	}

	@RequestMapping(
		    value = "/inquiryAnswer.dox",
		    method = RequestMethod.POST,
		    produces = "application/json;charset=UTF-8"
		)
		@ResponseBody
		public String inquiryAnswer(
		        @RequestParam HashMap<String, Object> map,
		        HttpSession session) {

		    HashMap<String, Object> resultMap =
		        adminService.completeInquiryAnswer(map);

		    if ("success".equals(resultMap.get("result"))) {
		        String adminId =
		            (String) session.getAttribute("sessionId");

		        boolean notificationCreated =
		            notificationService.createInquiryAnswered(
		                map.get("inquiryNo"),
		                adminId
		            );

		        putNotificationResult(resultMap, notificationCreated);
		    }

		    return new Gson().toJson(resultMap);
		}

	@RequestMapping(value = "/changeAnswer.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String changeAnswer(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = adminService.editAnswerStatus(map);

		return new Gson().toJson(resultMap);
	}

	@RequestMapping(
		    value = "/inquiryAnswerUpdate.dox",
		    method = RequestMethod.POST,
		    produces = "application/json;charset=UTF-8"
		)
		@ResponseBody
		public String inquiryAnswerUpdate(
		        @RequestParam HashMap<String, Object> map) {

		    HashMap<String, Object> resultMap =
		        adminService.editAnswer(map);

		    return new Gson().toJson(resultMap);
		}
	
	// 관리자 전체 회원목록 페이지
	@RequestMapping("/userList.dox")
	@ResponseBody
	public HashMap<String, Object> userList(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		int pageSize = Integer.parseInt((String) map.get("pageSize"));
		int offSet = Integer.parseInt((String) map.get("offSet"));

		map.put("pageSize", pageSize);
		map.put("offSet", offSet);

		resultMap = adminService.getUserList(map);

		return resultMap;
	}

	// 관리자 회원 상세 조회
	@RequestMapping(value = "/userDetail.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String userDetail(Model model, @RequestParam HashMap<String, Object> map) throws Exception {

		HashMap<String, Object> resultMap = new HashMap<>();
		resultMap = adminService.getUserDetail(map);

		return new Gson().toJson(resultMap);
	}

	// 관리자 전체 업체목록 페이지
	@RequestMapping("/companyList.dox")
	@ResponseBody
	public HashMap<String, Object> companyList(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		int pageSize = Integer.parseInt((String) map.get("pageSize"));
		int offSet = Integer.parseInt((String) map.get("offSet"));

		map.put("pageSize", pageSize);
		map.put("offSet", offSet);

		resultMap = adminService.getCompanyList(map);

		return resultMap;
	}

	// 관리자 업체 상세 조회
	@RequestMapping(value = "/companyDetail.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String companyDetail(Model model, @RequestParam HashMap<String, Object> map) throws Exception {

		HashMap<String, Object> resultMap = new HashMap<>();
		resultMap = adminService.getCompanyDetail(map);

		return new Gson().toJson(resultMap);
	}

	// 관리자 전체 회원목록 페이지 정지/해제
	@RequestMapping(value = "/editMemberBan.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String editMemberBan(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();

		resultMap = adminService.editMemberBan(map);

		return new Gson().toJson(resultMap);
	}

	// 정지 이력 조회
	@RequestMapping("/banHistory.dox")
	@ResponseBody
	public String banHistory(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		resultMap = adminService.getBanHistory(map);

		return new Gson().toJson(resultMap);
	}

	// 신고관리 일괄 신고 승인
	@RequestMapping(value = "/reportBatchApprove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String reportBatchApprove(Model model, @RequestParam(value = "reportNos") List<Integer> reportNos,
			@RequestParam HashMap<String, Object> map) throws Exception {

		HashMap<String, Object> resultMap = new HashMap<>();

		map.put("reportNos", reportNos);

		resultMap = adminService.batchApproveReport(map);

		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/reportBatchReject.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String reportBatchReject(Model model, @RequestParam(value = "reportNos") List<Integer> reportNos,
			@RequestParam String rejectReason) throws Exception {
		HashMap<String, Object> map = new HashMap<>();

		map.put("reportNos", reportNos);
		map.put("rejectReason", rejectReason);

		map = adminService.reportBatchReject(map);

		return new Gson().toJson(map);
	}

	// 신고 단일 승인
	@RequestMapping(value = "/reportApprove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String reportApprove(
	        @RequestParam HashMap<String, Object> map,
	        HttpSession session) {

	    HashMap<String, Object> resultMap = adminService.approveReport(map);

	    if ("success".equals(resultMap.get("result"))) {
	        boolean notificationCreated = notificationService.createReportResult(
	            map.get("reportNo"),
	            (String) session.getAttribute("sessionId"),
	            true,
	            (String) map.get("answerContent")
	        );

	        if (notificationCreated) {
	            adminService.completeReportAnswer(map);
	        }

	        putNotificationResult(resultMap, notificationCreated);
	    }

	    return new Gson().toJson(resultMap);
	}

	// 신고 반려
	@RequestMapping(value = "/reportReject.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String reportReject(
	        @RequestParam HashMap<String, Object> map,
	        HttpSession session) {

	    HashMap<String, Object> resultMap = adminService.rejectReport(map);

	    if ("success".equals(resultMap.get("result"))) {
	        boolean notificationCreated = notificationService.createReportResult(
	            map.get("reportNo"),
	            (String) session.getAttribute("sessionId"),
	            false,
	            (String) map.get("answerContent")
	        );

	        if (notificationCreated) {
	            adminService.completeReportAnswer(map);
	        }

	        putNotificationResult(resultMap, notificationCreated);
	    }

	    return new Gson().toJson(resultMap);
	}
	
	//알림 재전송
	@RequestMapping(value = "/reportAnswerRetry.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String reportAnswerRetry(
	        @RequestParam HashMap<String, Object> map,
	        HttpSession session) {

	    HashMap<String, Object> resultMap = new HashMap<>();
	    HashMap<String, Object> detailResult = adminService.getReportDetail(map);
	    Admin report = (Admin) detailResult.get("info");

	    if (report == null || report.getActionStatus() == 0) {
	        resultMap.put("result", "fail");
	        resultMap.put("message", "아직 처리되지 않은 신고입니다.");
	        return new Gson().toJson(resultMap);
	    }

	    if (report.getAnswerStatus() == 1) {
	        resultMap.put("result", "fail");
	        resultMap.put("message", "이미 답변 알림이 전송된 신고입니다.");
	        return new Gson().toJson(resultMap);
	    }

	    String answerContent = report.getAnswerContent();
	    if (answerContent == null || answerContent.trim().isEmpty()) {
	        resultMap.put("result", "fail");
	        resultMap.put("message", "저장된 답변 내용이 없습니다.");
	        return new Gson().toJson(resultMap);
	    }

	    boolean notificationCreated = notificationService.createReportResult(
	        report.getReportNo(),
	        (String) session.getAttribute("sessionId"),
	        report.getActionStatus() == 1,
	        answerContent
	    );

	    if (notificationCreated) {
	        adminService.completeReportAnswer(map);
	        resultMap.put("result", "success");
	        resultMap.put("message", "답변 알림을 다시 전송했습니다.");
	    } else {
	        resultMap.put("result", "fail");
	        resultMap.put("message", "답변 알림 재전송에 실패했습니다.");
	    }

	    putNotificationResult(resultMap, notificationCreated);
	    return new Gson().toJson(resultMap);
	}
	
	// 회원 상세 신고 누적횟수, 이력 조회
	@RequestMapping(value = "/reportInfoList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String reportList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {

		HashMap<String, Object> resultMap = new HashMap<>();
		resultMap = adminService.getReportInfoList(map);

		return new Gson().toJson(resultMap);
	}

	// 신고 상세 조회
	@RequestMapping(value = "/reportDetail.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String reportDetail(@RequestParam HashMap<String, Object> map) throws Exception {

		HashMap<String, Object> resultMap = new HashMap<>();

		resultMap = adminService.getReportDetail(map);

		return new Gson().toJson(resultMap);
	}

	// 댓글로 게시판 추적
	@RequestMapping(value = "/adminCommentTargetPost.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String adminCommentTargetPost(@RequestParam HashMap<String, Object> map) {

		HashMap<String, Object> resultMap = adminService.adminCommentTargetPost(map);

		return new Gson().toJson(resultMap);
	}

	// 게시판 조회
	@RequestMapping("/boardList.dox")
	@ResponseBody
	public HashMap<String, Object> boardList(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		int pageSize = Integer.parseInt((String) map.get("pageSize"));
		int offSet = Integer.parseInt((String) map.get("offSet"));

		map.put("pageSize", pageSize);
		map.put("offSet", offSet);

		resultMap = adminService.getBoardList(map);

		return resultMap;
	}

	// 게시판 삭제하는척만
	@RequestMapping(value = "/boardApprove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String boardApprove(Model model, @RequestParam HashMap<String, Object> map) throws Exception {

		HashMap<String, Object> resultMap = new HashMap<>();

		resultMap = adminService.editBoardApprove(map);

		return new Gson().toJson(resultMap);
	}

	// 게시판 상세
	@RequestMapping(value = "/postDetail.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String postDetail(@RequestParam HashMap<String, Object> map) throws Exception {

		HashMap<String, Object> resultMap = new HashMap<>();

		resultMap = adminService.getPostDetail(map);

		return new Gson().toJson(resultMap);
	}

	// 결제 관리
	@RequestMapping("/paymentList.dox")
	@ResponseBody
	public HashMap<String, Object> paymentList(@RequestParam HashMap<String, Object> map) {
		return adminService.getPaymentList(map);
	}

	@RequestMapping("/passPaymentList.dox")
	@ResponseBody
	public HashMap<String, Object> passPaymentList(@RequestParam HashMap<String, Object> map) {
		map.put("pageSize", Integer.parseInt(map.get("pageSize").toString()));
		map.put("offSet", Integer.parseInt(map.get("offSet").toString()));
		return adminService.getPassPaymentList(map);
	}

	@RequestMapping("/reservationPaymentList.dox")
	@ResponseBody
	public HashMap<String, Object> reservationPaymentList(@RequestParam HashMap<String, Object> map) {
		map.put("pageSize", Integer.parseInt(map.get("pageSize").toString()));
		map.put("offSet", Integer.parseInt(map.get("offSet").toString()));
		return adminService.getReservationPaymentList(map);
	}

	@RequestMapping("/registrationPaymentList.dox")
	@ResponseBody
	public HashMap<String, Object> registrationPaymentList(@RequestParam HashMap<String, Object> map) {
		map.put("pageSize", Integer.parseInt(map.get("pageSize").toString()));
		map.put("offSet", Integer.parseInt(map.get("offSet").toString()));
		return adminService.getRegistrationPaymentList(map);
	}

// 상품 관리 쿠폰 관리 패스 관리
	// 목록조회
	@RequestMapping("/productAdminList.dox")
	@ResponseBody
	public HashMap<String, Object> productList(@RequestParam HashMap<String, Object> map) {
		map.put("pageSize", Integer.parseInt(map.get("pageSize").toString()));
		map.put("offSet", Integer.parseInt(map.get("offSet").toString()));
		return adminService.getAdminProductList(map);
	}

	@RequestMapping("/couponList.dox")
	@ResponseBody
	public HashMap<String, Object> couponList(@RequestParam HashMap<String, Object> map) {
		map.put("pageSize", Integer.parseInt(map.get("pageSize").toString()));
		map.put("offSet", Integer.parseInt(map.get("offSet").toString()));
		return adminService.getCouponList(map);
	}

	@RequestMapping("/passList.dox")
	@ResponseBody
	public HashMap<String, Object> passList(@RequestParam HashMap<String, Object> map) {
		map.put("pageSize", Integer.parseInt(map.get("pageSize").toString()));
		map.put("offSet", Integer.parseInt(map.get("offSet").toString()));
		return adminService.getAllPassList(map);
	}

	// 상품 상태 변경 (판매중지 / 재판매)
	@RequestMapping(value = "/productStatusUpdate.dox", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> productStatusUpdate(@RequestParam HashMap<String, Object> map) {

		return adminService.updateProductStatus(map);
	}

	// 상품 삭제
	@RequestMapping("/productDelete.dox")
	@ResponseBody
	public HashMap<String, Object> productDelete(HashMap<String, Object> map) {
		return adminService.deleteProduct(map);
	}

	// 상품 상세
	@RequestMapping("/productView.dox")
	@ResponseBody
	public HashMap<String, Object> productView(HashMap<String, Object> map) {
		return adminService.selectProductInfo(map);
	}

	// 쿠폰 등록
	@RequestMapping("/couponInsert.dox")
	@ResponseBody
	public HashMap<String, Object> couponInsert(@RequestParam HashMap<String, Object> map) {

		return adminService.addCoupon(map);
	}

	// 쿠폰 삭제
	@RequestMapping("/couponDelete.dox")
	@ResponseBody
	public HashMap<String, Object> couponDelete(@RequestParam HashMap<String, Object> map) {

		return adminService.deleteCoupon(map);
	}

	// 패스 상태 변경 (중지 / 재사용)
	@RequestMapping(value = "/passStatusUpdate.dox", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> passStatusUpdate(@RequestParam HashMap<String, Object> map) {

		return adminService.editPassStatus(map);
	}

	// 패스 등록
	@RequestMapping("/passAdd.dox")
	@ResponseBody
	public HashMap<String, Object> passAdd(@RequestParam HashMap<String, Object> map) {

		return adminService.addPass(map);
	}

	// 패스 삭제
	@RequestMapping("/passDelete.dox")
	@ResponseBody
	public HashMap<String, Object> passDelete(@RequestParam HashMap<String, Object> map) {

		return adminService.removePass(map);
	}

	// 마이 패스 조회
	@RequestMapping("/MyPassList.dox")
	@ResponseBody
	public HashMap<String, Object> getMyPassList(@RequestParam HashMap<String, Object> map) {
		map.put("pageSize", Integer.parseInt(map.get("pageSize").toString()));
		map.put("offSet", Integer.parseInt(map.get("offSet").toString()));
		return adminService.getMyPassList(map);
	}

	@RequestMapping("/adminRegistration.dox")
	@ResponseBody
	public HashMap<String, Object> adminRegistration(@RequestParam HashMap<String, Object> map, HttpSession session) {

		HashMap<String, Object> resultMap = adminService.editCompanyReg(map);

		if ("success".equals(resultMap.get("result"))) {
			boolean notificationCreated = notificationService.createPartnerApproved(String.valueOf(map.get("userId")),
					(String) session.getAttribute("sessionId"));

			putNotificationResult(resultMap, notificationCreated);
		}

		return resultMap;
	}

	private void putNotificationResult(HashMap<String, Object> resultMap, boolean notificationCreated) {

		resultMap.put("notificationResult", notificationCreated ? "success" : "fail");

		if (!notificationCreated) {
			resultMap.put("notificationMessage", "업무 처리는 완료됐지만 알림 생성에 실패했습니다.");
		}
	}

}