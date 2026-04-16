package com.example.demo.common.inquiry;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.example.demo.common.Message; // [간단주석] 공유해주신 메시지 규격 사용
import java.util.List;

@Service
public class InquiryService {

    @Autowired
    private InquiryMapper inquiryMapper;

    // 문의 등록
    public String addInquiry(Inquiry inquiry) {
        return (inquiryMapper.insertInquiry(inquiry) > 0) ? Message.MSG_ADD : Message.MSG_ERR;
    }

    // 내 문의 목록 조회
    public List<Inquiry> getMyInquiries(String userId) {
        return inquiryMapper.selectInquiryList(userId);
    }

    // 문의 삭제
    public String removeInquiry(Long inquiryNo) {
        return (inquiryMapper.deleteInquiry(inquiryNo) > 0) ? Message.MSG_REMOVE : Message.MSG_ERR;
    }
}