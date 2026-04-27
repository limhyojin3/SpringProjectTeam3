package com.example.demo.admin.controller;

import java.util.HashMap;
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

import com.example.demo.admin.dao.AdminService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpServletRequest;

@Controller
public class AdminController {

	@Autowired
	AdminService adminService;

	@RequestMapping("/adminMain.do")
	public String main(Model model) throws Exception {
		return "admin/adminMain";
	}

	@RequestMapping("/adminReviewWait.do")
	public String Review(Model model) throws Exception {
		return "admin/adminReviewWait";
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
	public String adminPayFinish(@RequestParam("payNo") int payNo, Model model) {

//		HashMap<String, Object> payment = adminService.getPaymentByPayNo(payNo);

//		model.addAttribute("payment", payment);

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

	@PostMapping("/verifyPayment.dox")
	@ResponseBody
	public HashMap<String, Object> verifyPayment(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		// 포트원에서 실 결제 검증
		boolean isValid = adminService.getPayInfo(map);

		if (isValid) {
			// 성공 시 디비에 결제 이력 및 패스 정보 저장
			adminService.completePayment(map);

			System.out.println("========= [테스트 결과] =========");
			System.out.println("결제 검증 성공: 실제 금액과 일치합니다.");
			System.out.println("결제 번호(imp_uid): " + map.get("imp_uid"));
			System.out.println("================================");

			result.put("success", true);
			result.put("msg", "결제 검증 완료!");
			result.put("pay_no", map.get("pay_no"));

		} else {
			result.put("success", false);
			result.put("msg", "결제 검증 실패");
		}
		return result;
	}

	@RequestMapping(value = "/inquiry.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String inquiry(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = adminService.getInquiryList(map);

		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/inquiryAnswer.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String inquiryAnswer(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = adminService.addAnswer(map);

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
		public String reportBatchApprove(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		    
		    HashMap<String, Object> resultMap = new HashMap<>();

		    resultMap = adminService.batchApproveReport(map);

		    return new Gson().toJson(resultMap);
		}
		
		// 신고 단일 승인
		@RequestMapping(value = "/reportApprove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
		@ResponseBody
		public String reportApprove(Model model, @RequestParam HashMap<String, Object> map) throws Exception {

		    HashMap<String, Object> resultMap = new HashMap<>();

		    resultMap = adminService.approveReport(map);

		    return new Gson().toJson(resultMap);
		}
		
		// 신고 반려
		@RequestMapping(value = "/reportReject.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
		@ResponseBody
		public String reportReject(@RequestParam HashMap<String, Object> map) {
		    HashMap<String, Object> resultMap = new HashMap<>();

		    resultMap = adminService.rejectReport(map);

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
		
		
		// 상품 관리
		@RequestMapping("/productList.dox")
		@ResponseBody
		public HashMap<String, Object> productList(@RequestParam HashMap<String, Object> map) {
			map.put("pageSize", Integer.parseInt(map.get("pageSize").toString()));
			map.put("offSet", Integer.parseInt(map.get("offSet").toString()));
			return adminService.getProductList(map);
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
}