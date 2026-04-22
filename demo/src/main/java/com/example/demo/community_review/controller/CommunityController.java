package com.example.demo.community_review.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

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
    
    // --- [페이지 이동 메서드] ---
    
    // 1. 목록 페이지 이동
    @RequestMapping("/list.do")
    public String communityPage() {
        return "/community/community-list"; 
    }

    // 2. 상세 페이지 이동
    @RequestMapping("/detail.do")
    public String detailPage(HttpServletRequest request, @RequestParam HashMap<String, Object> map) {
        request.setAttribute("postNo", map.get("postNo"));
        return "/community/community-detail"; 
    }
    
    // 3. 작성 페이지 이동
    @RequestMapping("/add.do")
    public String addPage() {
        return "/community/community-add";
    }
    
    // 4. 수정 페이지 화면 매핑
    @RequestMapping("/edit.do")
    public String editPage(@RequestParam("postNo") String postNo, Model model, HttpServletRequest request) {
        HttpSession session = request.getSession();
        String sessionId = (String) session.getAttribute("userId");
        
        HashMap<String, Object> map = new HashMap<>();
        map.put("postNo", postNo);
        String authorId = communityService.getPostAuthor(map);
        
        if (sessionId == null || !sessionId.equals(authorId) || authorId == null) {
            return "redirect:/api/community/list.do"; 
        }
        
        model.addAttribute("postNo", postNo);
        return "/community/community-edit"; 
    }

    // --- [데이터 처리 메서드 (AJAX 전용)] ---

    // 1. 목록 데이터 조회
    @PostMapping("/list.dox")
    @ResponseBody
    public String list(@RequestBody HashMap<String, Object> map, HttpServletRequest request) {
        HashMap<String, Object> resultMap = new HashMap<>();
        HttpSession session = request.getSession();
        String sessionId = (String) session.getAttribute("userId");
        
        List<Community> list = communityService.getList(map);
        
        resultMap.put("list", list);
        resultMap.put("sessionId", sessionId);
        
        return new Gson().toJson(resultMap);
    }

    // 2. 단건 게시글 상세 조회
    @PostMapping("/getPost.dox")
    @ResponseBody
    public String getPost(@RequestBody HashMap<String, Object> map, HttpServletRequest request) {
        HashMap<String, Object> resultMap = new HashMap<>();
        HttpSession session = request.getSession();
        
        // 테스트용 세션 강제 주입 (로그인 기능 완성 전)
        if (session.getAttribute("userId") == null) {
            session.setAttribute("userId", "th3613"); 
        }
        
        String sessionId = (String) session.getAttribute("userId");
        
        // XML 쿼리의 #{userId}와 매칭하기 위해 map에 세션 아이디를 userId라는 키로 담음
        map.put("userId", sessionId); 
        
        Community post = communityService.getPostDetail(map, request);
        
        resultMap.put("post", post);
        resultMap.put("sessionId", sessionId);
        
        return new Gson().toJson(resultMap);
    }

    // 3. 게시글 저장 처리
    @PostMapping("/add.dox")
    @ResponseBody
    public String add(@RequestBody Community post, HttpServletRequest request) {
        HttpSession session = request.getSession();
        String sessionId = (String) session.getAttribute("userId");
        
        post.setUserId(sessionId);
        
        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("result", communityService.addPost(post));
        return new Gson().toJson(resultMap);
    }
    
    // 4. 게시글 삭제 처리
    @PostMapping("/remove.dox")
    @ResponseBody
    public String remove(@RequestBody HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        int n = communityService.removePost(map);
        resultMap.put("result", n > 0 ? "success" : "fail");
        return new Gson().toJson(resultMap);
    }

    // 5. 게시글 수정 처리
    @PostMapping("/edit.dox")
    @ResponseBody
    public String edit(@RequestBody HashMap<String, Object> map, HttpServletRequest request) {
        HashMap<String, Object> resultMap = new HashMap<>();
        HttpSession session = request.getSession();
        String sessionId = (String) session.getAttribute("userId");
        
        String authorId = communityService.getPostAuthor(map);
        
        if (sessionId == null || authorId == null || !sessionId.equals(authorId)) {
            resultMap.put("result", "fail");
            resultMap.put("message", "수정 권한이 없습니다.");
            return new Gson().toJson(resultMap);
        }
        
        String title = (String) map.get("title");
        String content = (String) map.get("content");

        if (title == null || title.trim().isEmpty()) {
            resultMap.put("result", "fail");
            resultMap.put("message", "제목을 입력해주세요.");
            return new Gson().toJson(resultMap);
        }
        if (content == null || content.trim().isEmpty()) {
            resultMap.put("result", "fail");
            resultMap.put("message", "내용을 입력해주세요.");
            return new Gson().toJson(resultMap);
        }

        int n = communityService.editPost(map);
        resultMap.put("result", n > 0 ? "success" : "fail");
        return new Gson().toJson(resultMap);
    }
    
    // 6. 좋아요 토글 처리 (하트 색깔 핵심 로직)
    @PostMapping("/toggleLike.dox")
    @ResponseBody
    public String toggleLike(@RequestBody HashMap<String, Object> map, HttpServletRequest request) {
        HashMap<String, Object> resultMap = new HashMap<>();
        HttpSession session = request.getSession();
        
        // 좋아요 누르는 사람 아이디 확보
        String sessionId = (String) session.getAttribute("userId");
        if(sessionId == null) {
            resultMap.put("result", "fail");
            resultMap.put("message", "로그인이 필요합니다.");
            return new Gson().toJson(resultMap);
        }
        
        map.put("userId", sessionId);
        
        // 서비스에서 좋아요 체크/증가/감소 처리
        int status = communityService.toggleLike(map);
        
        resultMap.put("status", status); 
        resultMap.put("result", "success");
        
        return new Gson().toJson(resultMap);
    }
}