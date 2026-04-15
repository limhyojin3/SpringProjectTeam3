package com.example.demo.common.inquiry;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

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