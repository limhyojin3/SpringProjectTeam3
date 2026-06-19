package com.example.demo.admin.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.demo.admin.model.Notification;

public interface NotificationMapper {
	List<Notification> selectNotificationList(HashMap<String, Object> map);

	int selectUnreadCount(@Param("receiverId") String receiverId);

	int updateNotificationRead(HashMap<String, Object> map);

	int updateAllNotificationsRead(@Param("receiverId") String receiverId);

	int insertInquiryAnswered(HashMap<String, Object> map);

	int insertReviewResult(HashMap<String, Object> map);

	int insertReportResultForReporter(HashMap<String, Object> map);

	int insertReportWarningForTarget(HashMap<String, Object> map);

	int insertInquiryReceivedForAdmins(HashMap<String, Object> map);

	int insertReportReceivedForAdmins(HashMap<String, Object> map);
}
