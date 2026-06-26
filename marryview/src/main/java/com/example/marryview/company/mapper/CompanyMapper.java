package com.example.marryview.company.mapper;

import java.util.HashMap;
import org.apache.ibatis.annotations.Mapper;

import com.example.marryview.company.model.PartnerMember;

@Mapper
public interface CompanyMapper {

    PartnerMember selectCompany(HashMap<String, Object> map);

    String selectCompanyByUserId(String userId);
}