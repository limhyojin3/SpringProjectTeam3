package com.example.demo.community_review.controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.example.demo.community_review.dao.CommunityService;
import com.example.demo.community_review.model.Community;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/api/community")
public class CommunityController {

    @Autowired
    private CommunityService communityService;
    
    private final Gson gson = new Gson();

    // --- [페이지 이동 메서드] ---
    
    @RequestMapping("/list.do")
    public String communityPage() {
        return "/community/community-list"; 
    }

    @RequestMapping("/detail.do")
    public String detailPage(HttpServletRequest request, @RequestParam HashMap<String, Object> map) {
        request.setAttribute("postNo", map.get("postNo"));
        return "/community/community-detail"; 
    }
    
    @RequestMapping("/add.do")
    public String addPage(HttpSession session) {
        if (session.getAttribute("sessionId") == null) return "redirect:/login.do";
        return "/community/community-add";
    }
    
    @RequestMapping("/edit.do")
    public String editPage(@RequestParam("postNo") String postNo, Model model, HttpSession session) {
        // [수정] sessionId 키값 사용
        String sessionId = (String) session.getAttribute("sessionId");
        
        if (sessionId == null) return "redirect:/login.do"; 

        HashMap<String, Object> map = new HashMap<>();
        map.put("postNo", postNo);
        String authorId = communityService.getPostAuthor(map);
        
        if (authorId == null || !sessionId.equals(authorId)) {
            return "redirect:/api/community/list.do"; 
        }
        
        model.addAttribute("postNo", postNo);
        return "/community/community-edit"; 
    }

    // --- [데이터 처리 메서드 (AJAX)] ---

    @PostMapping("/list.dox")
    @ResponseBody
    public String list(@RequestBody HashMap<String, Object> map, HttpSession session) {
        HashMap<String, Object> resultMap = new HashMap<>();
        String sessionId = (String) session.getAttribute("sessionId");
        
        List<Community> list = communityService.getList(map);
        int count = communityService.getPostCount(map);
        
        resultMap.put("list", list);
        resultMap.put("sessionId", sessionId); // MemberController와 동일하게 sessionId로 전달
        resultMap.put("count", count);
        
        return gson.toJson(resultMap);
    }

    @PostMapping("/getPost.dox")
    @ResponseBody
    public String getPost(@RequestBody HashMap<String, Object> map, HttpSession session, HttpServletRequest request) {
        HashMap<String, Object> resultMap = new HashMap<>();
        String sessionId = (String) session.getAttribute("sessionId");
        
        map.put("userId", sessionId); // XML 쿼리 내부 변수명 관례에 따라 주입 (값은 sessionId)
        Community post = communityService.getPostDetail(map, request);
        
        resultMap.put("post", post);
        resultMap.put("sessionId", sessionId);
        
        return gson.toJson(resultMap);
    }

    @PostMapping("/add.dox")
    @ResponseBody
    public String add(@RequestBody Community post, HttpSession session) {
        HashMap<String, Object> resultMap = new HashMap<>();
        String sessionId = (String) session.getAttribute("sessionId");
        
        if (sessionId == null) {
            resultMap.put("result", "fail");
            resultMap.put("message", "로그인이 필요합니다.");
            return gson.toJson(resultMap);
        }
        
        post.setUserId(sessionId); 
        resultMap.put("result", communityService.addPost(post));
        return gson.toJson(resultMap);
    }
    
    @PostMapping("/remove.dox")
    @ResponseBody
    public String remove(@RequestBody HashMap<String, Object> map, HttpSession session) {
        HashMap<String, Object> resultMap = new HashMap<>();
        String sessionId = (String) session.getAttribute("sessionId");
        
        String authorId = communityService.getPostAuthor(map);
        if (sessionId == null || !sessionId.equals(authorId)) {
            resultMap.put("result", "fail");
            resultMap.put("message", "삭제 권한이 없습니다.");
            return gson.toJson(resultMap);
        }

        int n = communityService.removePost(map);
        resultMap.put("result", n > 0 ? "success" : "fail");
        return gson.toJson(resultMap);
    }

    @PostMapping("/edit.dox")
    @ResponseBody
    public String edit(@RequestBody HashMap<String, Object> map, HttpSession session) {
        HashMap<String, Object> resultMap = new HashMap<>();
        String sessionId = (String) session.getAttribute("sessionId");
        
        String authorId = communityService.getPostAuthor(map);
        if (sessionId == null || !sessionId.equals(authorId)) {
            resultMap.put("result", "fail");
            resultMap.put("message", "수정 권한이 없습니다.");
            return gson.toJson(resultMap);
        }

        int n = communityService.editPost(map);
        resultMap.put("result", n > 0 ? "success" : "fail");
        return gson.toJson(resultMap);
    }
    
    @PostMapping("/toggleLike.dox")
    @ResponseBody
    public String toggleLike(@RequestBody HashMap<String, Object> map, HttpSession session) {
        HashMap<String, Object> resultMap = new HashMap<>();
        String sessionId = (String) session.getAttribute("sessionId");

        if(sessionId == null) {
            resultMap.put("result", "fail");
            resultMap.put("message", "로그인이 필요합니다.");
            return gson.toJson(resultMap);
        }
        
        map.put("userId", sessionId);
        int status = communityService.toggleLike(map);
        
        resultMap.put("status", status); 
        resultMap.put("result", "success");
        
        return gson.toJson(resultMap);
    }

 
}