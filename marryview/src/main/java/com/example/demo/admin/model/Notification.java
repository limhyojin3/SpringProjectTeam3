package com.example.demo.admin.model;

import lombok.Data;

@Data
public class Notification {
	private Long notificationNo;
	private String receiverId;
	private String senderId;
	private String notificationType;
	private String content;
	private String targetType;
	private Long targetNo;
	private String isRead;
	private String createdAt;
	private String readAt;
}
