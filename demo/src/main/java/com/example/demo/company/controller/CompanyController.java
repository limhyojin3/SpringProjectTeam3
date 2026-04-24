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

	@RequestMapping("/company10.do")
	public String test2(Model model) throws Exception {
		return "/company/company10";
	}

	/* 미완성 */
	@RequestMapping("/company9.do")
	public String test99(Model model) throws Exception {
		return "/company/company10";
	}
	
	@RequestMapping("/company1.do")
	public String te2(Model model) throws Exception {
		return "/company/company1";
	}
	
	
	@RequestMapping("/company8.do")
	public String te(Model model) throws Exception {
		return "/company/companyBackup0421";
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

		return new Gson().toJson(resultMap);

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

		return new Gson().toJson(resultMap);

	}
	//productRemove.dox
	@ResponseBody
	@PostMapping("/productRemove.dox")
	public String removeProduct(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = companyService.removeProduct(map);

		return new Gson().toJson(resultMap);
	}

}
