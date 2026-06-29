package com.example.marryview.admin.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.example.marryview.admin.dao.NotificationService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/api/notification")
public class NotificationController {
	
	@Autowired
    private NotificationService notificationService;

	@GetMapping("/list.do")
	public String adminNotificationTest() {
	    return "common/notification-list";
	}
	
	@ResponseBody
    @PostMapping("/list.dox")
    public HashMap<String, Object> list(
            @RequestParam(defaultValue = "20") int limit,
            HttpSession session) {

        HashMap<String, Object> resultMap = new HashMap<>();
        String receiverId = getSessionId(session, resultMap);

        if (receiverId == null) {
            return resultMap;
        }

        resultMap.put(
            "list",
            notificationService.getNotificationList(receiverId, limit)
        );
        resultMap.put("result", "success");

        return resultMap;
    }

	@ResponseBody
	@PostMapping("/wedding-news.dox")
	public HashMap<String, Object> weddingNews() {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    resultMap.put("list", notificationService.getUpcomingWeddingNews());
	    resultMap.put("result", "success");

	    return resultMap;
	}
	
	@ResponseBody
    @PostMapping("/unread-count.dox")
    public HashMap<String, Object> unreadCount(HttpSession session) {
        HashMap<String, Object> resultMap = new HashMap<>();
        String receiverId = getSessionId(session, resultMap);

        if (receiverId == null) {
            return resultMap;
        }

        resultMap.put(
            "unreadCount",
            notificationService.getUnreadCount(receiverId)
        );
        resultMap.put("result", "success");

        return resultMap;
    }

	@ResponseBody
    @PostMapping("/read.dox")
    public HashMap<String, Object> read(
            @RequestParam long notificationNo,
            HttpSession session) {

        HashMap<String, Object> resultMap = new HashMap<>();
        String receiverId = getSessionId(session, resultMap);

        if (receiverId == null) {
            return resultMap;
        }

        boolean updated = notificationService.readNotification(
            notificationNo,
            receiverId
        );

        resultMap.put("result", updated ? "success" : "fail");
        return resultMap;
    }

	@ResponseBody
    @PostMapping("/read-all.dox")
    public HashMap<String, Object> readAll(HttpSession session) {
        HashMap<String, Object> resultMap = new HashMap<>();
        String receiverId = getSessionId(session, resultMap);

        if (receiverId == null) {
            return resultMap;
        }

        resultMap.put(
            "updatedCount",
            notificationService.readAllNotifications(receiverId)
        );
        resultMap.put("result", "success");

        return resultMap;
    }

    private String getSessionId(
            HttpSession session,
            HashMap<String, Object> resultMap) {

        String sessionId = (String) session.getAttribute("sessionId");

        if (sessionId == null) {
            resultMap.put("result", "fail");
            resultMap.put("message", "로그인이 필요합니다.");
        }

        return sessionId;
    }
}
