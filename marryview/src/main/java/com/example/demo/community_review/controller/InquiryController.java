package com.example.demo.community_review.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.community_review.dao.InquiryService;

@RestController
@RequestMapping("/api/inquiry")
public class InquiryController {

    @Autowired
    private InquiryService inquiryService;

 // 문의 저장
    @PostMapping("/add.dox")
    public Map<String, Object> addInquiry(@RequestBody HashMap<String, Object> map) {
        return inquiryService.addInquiry(map);
    }

    // 내 문의 목록 불러오기
    @PostMapping("/list.dox")
    public Map<String, Object> getMyInquiryList(@RequestBody HashMap<String, Object> map) {
        return inquiryService.getMyInquiryList(map);
    }

    // 문의 상세 내용 불러오기
    @PostMapping("/detail.dox")
    public Map<String, Object> getInquiryDetail(@RequestBody HashMap<String, Object> map) {
        return inquiryService.getInquiryDetail(map);
    }

    // 문의 삭제 API
    @PostMapping("/delete")
    public String deleteInquiry(@RequestParam Long inquiryNo) {
        return inquiryService.removeInquiry(inquiryNo);
    }
}