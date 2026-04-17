package com.example.demo.community_review.controller;


import java.util.HashMap;
import java.util.List;

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
        // 실제 경로: /WEB-INF/views/community/community-list.jsp
        return "/community/community-list"; 
    }

    // 2. 상세 페이지 이동
    @RequestMapping("/detail.do")
    public String detailPage(HttpServletRequest request, @RequestParam HashMap<String, Object> map) {
        request.setAttribute("postNo", map.get("postNo"));
        // 실제 경로: /WEB-INF/views/community/community-detail.jsp
        return "/community/community-detail"; 
    }
    
    // 3. 작성 페이지 이동
    @RequestMapping("/add.do")
    public String addPage() {
        // 실제 경로: /WEB-INF/views/community/community-add.jsp
        return "/community/community-add";
    }
    
 // 1. 수정 페이지 화면 매핑
    @RequestMapping("/edit.do")
    public String editPage(@RequestParam("postNo") String postNo, Model model, HttpServletRequest request) {
    	// 이 부분은 주소를 직접 치고 들어오는 경우를 대비하기 위한 장치입니다.
    	// 1. 세션에서 로그인한 아이디 꺼내기
        HttpSession session = request.getSession();
        String sessionId = (String) session.getAttribute("userId");
        
        // 2. 해당 글의 정보를 가져와서 작성자 확인 (Service에 메서드 하나 추가 필요)
        HashMap<String, Object> map = new HashMap<>();
        map.put("postNo", postNo);
        String authorId = communityService.getPostAuthor(map);
        
        // 3. 본인이 아니면 목록으로 튕겨내기(로그인 안 했을 때도 튕겨냄)
        if (sessionId == null || !sessionId.equals(authorId) || authorId == null) {
            // 메시지를 띄우고 싶다면 스크립트 처리가 필요하지만, 일단 안전하게 리다이렉트
            return "redirect:/api/community/list.do"; 
        }
    	
        // JSP에서 ${postNo}로 사용할 수 있게 model에 담아 보냄
        model.addAttribute("postNo", postNo);
        
        // 리턴값은 해당 JSP 파일명 (community-edit.jsp)
        return "/community/community-edit"; 
    }

    // --- [데이터 처리 메서드 (AJAX 전용)] ---

    // 1. 목록 데이터 조회
    @PostMapping("/list.dox")
    @ResponseBody
    public String list(@RequestBody HashMap<String, Object> map, HttpServletRequest request) {
        HashMap<String, Object> resultMap = new HashMap<>();
        // 1. 세션에서 아이디 꺼내기
        HttpSession session = request.getSession();
        String sessionId = (String) session.getAttribute("userId");
        
        // 2. 게시글 목록 가져오기
        List<Community> list = communityService.getList(map);
        
        // 3. 응답 봉투에 담기 (이게 빠지면 프론트에서 undefined가 뜹니다)
        resultMap.put("list", list);
        resultMap.put("sessionId", sessionId);
        
        return new Gson().toJson(resultMap);
    }

    // 2. 단건 게시글 상세 조회
    @PostMapping("/getPost.dox")
    @ResponseBody
    public String getPost(@RequestBody HashMap<String, Object> map, HttpServletRequest request) {
        HashMap<String, Object> resultMap = new HashMap<>();
        
        // 세션에서 현재 로그인한 유저 아이디 추출
        HttpSession session = request.getSession();
        
     // [임시 코드] 아직 로그인 기능이 없다면 강제로 세션에 아이디를 심어줍니다.
        // 실제 로그인 기능이 완성되면 이 아랫줄만 지우면 됩니다.
//        if (session.getAttribute("userId") == null) {
            session.setAttribute("userId", "happyjiwon"); 
//        }
        
        String sessionId = (String) session.getAttribute("userId");
        System.out.println("현재 로그인된 아이디: " + sessionId); // 서버 콘솔(Console)창에 출력됨
        
        // 파라미터 맵에 세션 아이디 추가
        map.put("sessionId", sessionId);
        
        // 서비스 호출
        Community post = communityService.getPostDetail(map, request);
        
        resultMap.put("post", post);
     // [중요!] 이 줄이 반드시 있어야 프론트에서 읽을 수 있습니다.
        resultMap.put("sessionId", sessionId);
        
        return new Gson().toJson(resultMap);
    }

    // 3. 게시글 저장 처리
    @PostMapping("/add.dox")
    @ResponseBody
    public String add(@RequestBody Community post, HttpServletRequest request) { // request 추가
    	HttpSession session = request.getSession();
        String sessionId = (String) session.getAttribute("userId"); // "happyjiwon"이 나옴
        
        // 게시글 객체에 세션 아이디를 작성자로 설정
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
        
        // 서비스 호출하여 삭제 수행
        int n = communityService.removePost(map);
        
        // 삭제 성공 시 success, 실패 시 fail 리턴
        resultMap.put("result", n > 0 ? "success" : "fail");
        return new Gson().toJson(resultMap);
    }
    // 5. 게시글 수정 처리
    @PostMapping("/edit.dox")
    @ResponseBody
    public String edit(@RequestBody HashMap<String, Object> map, HttpServletRequest request) {
        HashMap<String, Object> resultMap = new HashMap<>();
        
        // 1. 세션에서 현재 로그인한 유저 확인
        HttpSession session = request.getSession();
        String sessionId = (String) session.getAttribute("userId");
        
        // 2. 작성자와 세션 아이디가 일치하는지 검증 (방어 코드)
        // 프론트에서 넘어온 userId와 세션의 sessionId 비교
        String authorId = communityService.getPostAuthor(map);
        
        if (sessionId == null || authorId == null ||!sessionId.equals(authorId)) {
            resultMap.put("result", "fail");
            resultMap.put("message", "수정 권한이 없습니다.");
            return new Gson().toJson(resultMap);
        }
        
        // [추가] 2-1. 데이터 유효성 검사 (Validation)
        // 제목이나 내용이 공백인 상태로 넘어오는 것을 방지합니다.
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

        // 3. 수정 실행
        int n = communityService.editPost(map);
        
        if (n > 0) {
            resultMap.put("result", "success");
        } else {
            resultMap.put("result", "fail");
            resultMap.put("message", "수정에 실패했습니다.");
        }

        return new Gson().toJson(resultMap);
    }
    
    // 6. 좋아요 토글 처리
    @PostMapping("/toggleLike.dox")
    @ResponseBody
    public String toggleLike(@RequestBody HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        
        
        int status = communityService.toggleLike(map);
        resultMap.put("status", status); 
        return new Gson().toJson(resultMap);
    }
    
    
}