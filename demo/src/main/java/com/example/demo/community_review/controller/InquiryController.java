package com.example.demo.community_review.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.community_review.dao.InquiryService;
import com.example.demo.community_review.model.Inquiry;

@RestController
@RequestMapping("/api/inquiry")
public class InquiryController {

    @Autowired
    private InquiryService inquiryService;

    // 문의 작성 API
    @PostMapping("/add")
    public String addInquiry(@RequestBody Inquiry inquiry) {
        return inquiryService.addInquiry(inquiry);
    }

    // 내 문의 내역 API
    @GetMapping("/list")
    public List<Inquiry> getInquiries(@RequestParam String userId) {
        return inquiryService.getMyInquiries(userId);
    }

    // 문의 삭제 API
    @PostMapping("/delete")
    public String deleteInquiry(@RequestParam Long inquiryNo) {
        return inquiryService.removeInquiry(inquiryNo);
    }
}