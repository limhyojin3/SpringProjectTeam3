package com.example.marryview.admin.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.marryview.admin.model.Notification;

public interface NotificationMapper {
	List<Notification> selectNotificationList(HashMap<String, Object> map);
	
	List<HashMap<String, Object>> selectUpcomingWeddingNews();

	int selectUnreadCount(@Param("receiverId") String receiverId);

	int updateNotificationRead(HashMap<String, Object> map);

	int updateAllNotificationsRead(@Param("receiverId") String receiverId);

	int insertInquiryAnswered(HashMap<String, Object> map);

	int insertReviewResult(HashMap<String, Object> map);

	int insertReportResultForReporter(HashMap<String, Object> map);

	int insertReportWarningForTarget(HashMap<String, Object> map);

	int insertInquiryReceivedForAdmins(HashMap<String, Object> map);

	int insertReportReceivedForAdmins(HashMap<String, Object> map);

	int insertReservationRequestedForCompany(HashMap<String, Object> map);
	
	int insertReservationConfirmedForUser(HashMap<String, Object> map);
	
	List<HashMap<String, Object>> selectReviewRequestTargetList(HashMap<String, Object> map);

	int insertReviewRequestNotification(HashMap<String, Object> map);
	
	int insertReservationCanceledForUser(HashMap<String, Object> map);
	
	int insertReservationCanceledForCompany(HashMap<String, Object> map);
	
	int insertProductInquiryReceivedForCompany(HashMap<String, Object> map);

	int insertProductInquiryAnsweredForUser(HashMap<String, Object> map);
	
	int insertCouponIssuedForUser(HashMap<String, Object> map);
	
	int insertGiftconIssuedForUser(HashMap<String, Object> map);
	
	int insertReviewCommentedForAuthor(HashMap<String, Object> map);

	int insertPostCommentedForAuthor(HashMap<String, Object> map);
	
	int insertCompanyReviewReceived(HashMap<String, Object> map);

	int insertPartnerApproved(HashMap<String, Object> map);

	int insertPartnerApplicationReceived(HashMap<String, Object> map);
}
