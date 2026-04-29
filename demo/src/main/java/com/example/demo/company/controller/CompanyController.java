package com.example.demo.company.controller;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.company.dao.CompanyService;
import com.example.demo.company.model.Company;
import com.google.gson.Gson;

@Controller
public class CompanyController {

	@Autowired
	CompanyService companyService;

	/* 사용가능 / 이름변경: company10.do -> partnerManagement.do (4/27~) */
	@RequestMapping("/partnerManagement.do")
	public String test2(Model model) throws Exception {
		return "/company/partnerManagement";
	}
	
	/* 상품목록조회(카테고리 / 태그 필터)  + 상품 상세페이지  */
	/* 이름변경: company2.do -> productCategoryTag.do (4/27~)*/
	@RequestMapping("/productCategoryTag.do")
	public String te4(Model model) throws Exception {
		return "/company/productCategoryTag";
	}
	
	
	
	
	
	
	
	
	
	/* 로그인 없이 입장용 */
	@RequestMapping("/company9.do")
	public String test99(Model model) throws Exception {
		return "/company/partnerManagement";
	}
	
	

	@RequestMapping(value = "/company.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String tes1(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = companyService.getCompany(map);

		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/productList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String test2(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = companyService.getProductList(map);

		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/productDetail.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String tes(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = companyService.getProduct(map);

		return new Gson().toJson(resultMap);
	}

	@ResponseBody
	@PostMapping("/upload.dox")
	public String uploadFile2(@RequestParam(value = "file", required = false) MultipartFile file, Company product)
			throws IllegalStateException, IOException {
		// 1. 파일이 저장될 물리적 경로 설정

		if (file != null && !file.isEmpty()) {
			String projectPath = System.getProperty("user.dir");// 현재 프로젝트 폴더 경로를 가져옴
			String uploadDir = projectPath + "/src/main/resources/static/uploads/";

			
			String originalName = file.getOriginalFilename();
			String uuid = UUID.randomUUID().toString();
			String savedName = uuid + "_" + originalName;

			File folder = new File(uploadDir);

			if (!folder.exists()) {
				folder.mkdirs();
			}

			File copyFile = new File(uploadDir + savedName);
			file.transferTo(copyFile);

			product.setImgUrl("/img2/" + savedName);

		}

		HashMap<String, Object> resultMap = companyService.editProduct(product);

//		System.out.println(product);//uniqueNewTagsOnly=[아름다운, 자유로운]
		
		//int insertUniqueNewTagsOnly(Company product);
		
//		companyService.addUniqueNewTagsOnly(product);
		return new Gson().toJson(resultMap);
//		return null;

	}
	
	@ResponseBody
	@PostMapping("/upload2.dox")
	public String uploadFile3(@RequestParam(value = "file", required = false) MultipartFile file, Company product, @RequestParam("userId") String userId)
			throws IllegalStateException, IOException {
		
		Company info = companyService.getCompanyInfo(userId);
		
		if(info != null) {
			product.setCompanyNo(info.getCompanyNo());//9
		}
		
		// 1. 파일이 저장될 물리적 경로 설정

		if (file != null && !file.isEmpty()) {
			String projectPath = System.getProperty("user.dir");// 현재 프로젝트 폴더 경로를 가져옴
			String uploadDir = projectPath + "/src/main/resources/static/uploads/";

			
			String originalName = file.getOriginalFilename();
			String uuid = UUID.randomUUID().toString();
			String savedName = uuid + "_" + originalName;

			File folder = new File(uploadDir);

			if (!folder.exists()) {
				folder.mkdirs();
			}

			File copyFile = new File(uploadDir + savedName);
			file.transferTo(copyFile);

			product.setImgUrl("/img2/" + savedName);

		}

		HashMap<String, Object> resultMap = companyService.addProduct(product);

//		System.out.println(product);
		return new Gson().toJson(resultMap);
//		return null;
	}
	//productRemove.dox
	@ResponseBody
	@PostMapping("/productRemove.dox")
	public String removeProduct(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = companyService.removeProduct(map);

		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/ReservationList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String test23(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = companyService.getReservation(map);

		return new Gson().toJson(resultMap);
	}
	
	//public HashMap<String, Object> getReviewCnt(HashMap<String, Object> map)
	@RequestMapping(value = "/getReviewCnt.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String test3(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = companyService.getReviewCnt(map);

		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/getSimpleReviewCnt.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String tet3(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = companyService.getSimpleReviewCnt(map);

		return new Gson().toJson(resultMap);
	}
	//public HashMap<String, Object> getReviewDetails3(HashMap<String, Object> map) {
		
	@RequestMapping(value = "/ReviewDetails3.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String tet33(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = companyService.getReviewDetails3(map);

		return new Gson().toJson(resultMap);
	}
	//public HashMap<String, Object> getSimpleReviewDetails3(HashMap<String, Object> map)
	@RequestMapping(value = "/SimpleReviewDetails3.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String te2t33(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = companyService.getSimpleReviewDetails3(map);

		return new Gson().toJson(resultMap);
	}
	//public HashMap<String, Object> getTagList(HashMap<String, Object> map)
	@RequestMapping(value = "/getTagAndProductList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String te23t33(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = companyService.getTagAndProductList(map);

		return new Gson().toJson(resultMap);
	}
	
	//getBookedTimes.dox
	//public HashMap<String, Object> getBookedTimes(HashMap<String, Object> map) {
	@RequestMapping(value = "/getBookedTimes.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String te23t3(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = companyService.getBookedTimes(map);

		return new Gson().toJson(resultMap);
	}
	
	//public HashMap<String, Object> addReservation(HashMap<String, Object> map)
	@RequestMapping(value = "/addReservation.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String test99(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = companyService.addReservation(map);

		return new Gson().toJson(resultMap);
	}
	
	//public HashMap<String, Object> getMyReservationList(HashMap<String, Object> map)
	@RequestMapping(value = "/getMyReservationList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String test79(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = companyService.getMyReservationList(map);

		return new Gson().toJson(resultMap);
	}
	
	//addAndEditPaymentFinal
	@RequestMapping(value = "/addAndEditPaymentFinal.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String test89(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = companyService.addAndEditPaymentFinal(map);

		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/getTagList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String tess89(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = companyService.getTagList(map);

		return new Gson().toJson(resultMap);
	}
}
