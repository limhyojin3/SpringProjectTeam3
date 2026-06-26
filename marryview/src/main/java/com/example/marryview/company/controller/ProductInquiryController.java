package com.example.marryview.company.controller;

import java.util.HashMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.marryview.company.dao.ProductInquiryService;
import com.google.gson.Gson;

@Controller
public class ProductInquiryController {

	@Autowired
	private ProductInquiryService productInquiryService;

	/* 상품 상세 뷰에서 소비자의 Q&A 신규 문의 글 등록 */
	@RequestMapping(value = "/addInquiryProduct.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addInquiryProduct(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = productInquiryService.addInquiryProduct(map);
		return new Gson().toJson(resultMap);
	}
	
	/* 파트너 업체 백오피스용 인입 문의 리스트 로드 */
	@RequestMapping(value = "/getInquiryProductList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getInquiryProductList(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = productInquiryService.getInquiryProductList(map);
		return new Gson().toJson(resultMap);
	}
	
	/* 문의 글에 대한 업체의 공식 답변 등록 및 기존 답변 수정 */
	@RequestMapping(value = "/addProductInquiryAnswer.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addProductInquiryAnswer(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = productInquiryService.addProductInquiryAnswer(map);
		return new Gson().toJson(resultMap);
	}

	/* 문의 일련번호 기반 매핑 답변 텍스트 단건 매치 검증 */
	@RequestMapping(value = "/getInquiryAnsYn.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getInquiryAnsYn(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = productInquiryService.getInquiryAnsYn(map);
		return new Gson().toJson(resultMap);
	}
	
	/* 마이페이지 소비자가 자기가 남긴 문의 로그 전체 로드 */
	@RequestMapping(value = "/getMyInquiryList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getMyInquiryList(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = productInquiryService.getMyInquiryList(map);
		return new Gson().toJson(resultMap);
	}

	/* 특정 고유 문의 식별자 일치 여부 정밀 단건 로드 */
	@RequestMapping(value = "/getInquiry1Answer.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getInquiry1Answer(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = productInquiryService.getInquiry1Answer(map);
		return new Gson().toJson(resultMap);
	}
}