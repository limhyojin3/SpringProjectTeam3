package com.example.marryview.company.controller;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
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

import com.example.marryview.company.dao.CompanyService;
import com.example.marryview.company.dao.ProductCommandService;
import com.example.marryview.company.dao.ProductMetadataService;
import com.example.marryview.company.dao.ProductQueryService;
import com.example.marryview.company.model.Company;
import com.example.marryview.company.model.Product;
import com.google.gson.Gson;

@Controller
public class ProductController {

	@Autowired
	private ProductQueryService productQueryService;

	@Autowired
	private ProductCommandService productCommandService;

	@Autowired
	private ProductMetadataService productMetadataService;

	@Autowired
	private CompanyService companyService;

	/* 상품 카테고리/태그 필터링 메인 페이지 이동 */
	@RequestMapping("/productCategoryTag.do")
	public String productCategoryTag(Model model) throws Exception {
		return "/company/productCategoryTag";
	}
	
	/* 전체 상품 리스트 로드 */
	@RequestMapping(value = "/productList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String productList(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = productQueryService.getProductList(map);
		return new Gson().toJson(resultMap);
	}

	/* 특정 상품 단건 상세 조회 및 매핑 태그 정보 로드 */
	@RequestMapping(value = "/productDetail.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String productDetail(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = productQueryService.getProduct(map);
		return new Gson().toJson(resultMap);
	}

	/* 기등록 상품 정보 수정 및 물리 이미지 업로드 단자 */
	@ResponseBody
	@PostMapping("/upload.dox")
	public String upload(@RequestParam(value = "file", required = false) MultipartFile file, Product product, @RequestParam("userId") String userId)
			throws IllegalStateException, IOException {

		if (file != null && !file.isEmpty()) {
			String projectPath = System.getProperty("user.dir");
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

		HashMap<String, Object> resultMap = productCommandService.editProduct(product);
		return new Gson().toJson(resultMap);
	}
	
	/* 신규 상품 최초 등록 및 물리 이미지 업로드 단자 */
	@ResponseBody
	@PostMapping("/upload2.dox")
	public String upload2(@RequestParam(value = "file", required = false) MultipartFile file, Product product, @RequestParam("userId") String userId)
			throws IllegalStateException, IOException {
		
		Company info = companyService.getCompanyInfo(userId);
		if (info != null) {
			product.setCompanyNo(info.getCompanyNo());
		}
		
		if (file != null && !file.isEmpty()) {
			String projectPath = System.getProperty("user.dir");
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

		HashMap<String, Object> resultMap = productCommandService.addProduct(product);
		return new Gson().toJson(resultMap);
	}

	/* 상품 논리/물리 영구 삭제 단자 */
	@ResponseBody
	@PostMapping("/productRemove.dox")
	public String productRemove(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = productCommandService.removeProduct(map);
		return new Gson().toJson(resultMap);
	}
	
	/* 카테고리 진입 시 최초 태그 사전 및 전체 상품 동시 로드 */
	@RequestMapping(value = "/getTagAndProductList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getTagAndProductList(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = productMetadataService.getTagAndProductList(map);
		return new Gson().toJson(resultMap);
	}
	
	/* 순수 태그 사전 키워드 리스트 로드 */
	@RequestMapping(value = "/getTagList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getTagList(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = productMetadataService.getTagList(map);
		return new Gson().toJson(resultMap);
	}

	/* 상품 동적 트리 반환 API 단자 */
	@RequestMapping(value = "/getCategoryTree.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getCategoryTree() throws Exception {
		HashMap<String, Object> treeData = productMetadataService.getCategoryTree();
		return new Gson().toJson(treeData);
	}

	/* 💡 company_like 단선 제어 전용 실시간 하트 온오프 비동기 창구 */
	@ResponseBody
	@PostMapping("/companyLikeToggle.dox")
	public String companyLikeToggle(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = productCommandService.toggleCompanyLike(map);
		return new Gson().toJson(resultMap);
	}

	/* 💡 [신규 개통] 브라우저 상품 패키지 3열 격자판 하트와 통신하며 실시간 product_like 스위칭 결과를 사출하는 비동기 창구 */
	@ResponseBody
	@PostMapping("/productLikeToggle.dox")
	public String productLikeToggle(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = productCommandService.toggleProductLike(map);
		return new Gson().toJson(resultMap);
	}
}