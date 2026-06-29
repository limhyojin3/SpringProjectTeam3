package com.example.marryview.admin.dao;

import java.util.HashMap;
import java.util.List;
import java.util.function.BooleanSupplier;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.marryview.admin.mapper.NotificationMapper;
import com.example.marryview.admin.model.Notification;

@Service
public class NotificationService {
	
	@Autowired
    private NotificationMapper notificationMapper;

    public List<Notification> getNotificationList(
            String receiverId,
            int limit) {

        HashMap<String, Object> map = new HashMap<>();
        map.put("receiverId", receiverId);
        map.put("limit", Math.min(Math.max(limit, 1), 50));

        return notificationMapper.selectNotificationList(map);
    }

    public int getUnreadCount(String receiverId) {
        return notificationMapper.selectUnreadCount(receiverId);
    }

    public List<HashMap<String, Object>> getUpcomingWeddingNews() {
        return notificationMapper.selectUpcomingWeddingNews();
    }
    
    public boolean readNotification(
            long notificationNo,
            String receiverId) {

        HashMap<String, Object> map = new HashMap<>();
        map.put("notificationNo", notificationNo);
        map.put("receiverId", receiverId);

        return notificationMapper.updateNotificationRead(map) > 0;
    }

    public int readAllNotifications(String receiverId) {
        return notificationMapper.updateAllNotificationsRead(receiverId);
    }

    public boolean createInquiryAnswered(
            Object inquiryNo,
            String senderId) {

        return tryCreate("문의 답변", () -> {
            HashMap<String, Object> map = createBaseMap(senderId);
            map.put("inquiryNo", inquiryNo);

            return notificationMapper.insertInquiryAnswered(map) > 0;
        });
    }

    public boolean createReviewResult(
            Object reviewNo,
            String senderId,
            boolean approved) {

        return tryCreate("리뷰 심사 결과", () -> {
            HashMap<String, Object> map = createBaseMap(senderId);
            map.put("reviewNo", reviewNo);
            map.put(
                "notificationType",
                approved ? "REVIEW_APPROVED" : "REVIEW_REJECTED"
            );
            map.put(
                "content",
                approved
                    ? "작성하신 리뷰가 승인되었습니다."
                    : "작성하신 리뷰가 반려되었습니다."
            );

            return notificationMapper.insertReviewResult(map) > 0;
        });
    }

    public boolean createReportResult(
            Object reportNo,
            String senderId,
            boolean approved,
            String answerContent) {

        return tryCreate("신고 처리 결과", () -> {
            HashMap<String, Object> map = createBaseMap(senderId);
            map.put("reportNo", reportNo);
            map.put(
                "notificationType",
                approved ? "REPORT_APPROVED" : "REPORT_REJECTED"
            );
            map.put(
                "content",
                (approved ? "[신고 승인] " : "[신고 반려] ") + answerContent
            );

            boolean reporterCreated =
                notificationMapper.insertReportResultForReporter(map) > 0;

            if (reporterCreated && approved) {
                // 대상자가 없는 신고라면 0건이어도 정상입니다.
                notificationMapper.insertReportWarningForTarget(map);
            }

            return reporterCreated;
        });
    }

    private HashMap<String, Object> createBaseMap(String senderId) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("senderId", senderId);
        return map;
    }

    private boolean tryCreate(
            String description,
            BooleanSupplier action) {

        try {
            return action.getAsBoolean();
        } catch (Exception e) {
            System.err.println(
                description + " 알림 생성 실패: " + e.getMessage()
            );
            return false;
        }
    }
    
    public boolean createInquiryReceived(
            Object inquiryNo,
            String senderId) {

        return tryCreate("문의 접수", () -> {
            HashMap<String, Object> map = createBaseMap(senderId);
            map.put("inquiryNo", inquiryNo);

            return notificationMapper
                .insertInquiryReceivedForAdmins(map) > 0;
        });
    }

    public boolean createReportReceived(
            Object reportNo,
            String senderId) {

        return tryCreate("신고 접수", () -> {
            HashMap<String, Object> map = createBaseMap(senderId);
            map.put("reportNo", reportNo);

            return notificationMapper
                .insertReportReceivedForAdmins(map) > 0;
        });
    }
    
    public boolean createReservationRequested(Object resNo) {

        return tryCreate("예약 요청", () -> {
            HashMap<String, Object> map = new HashMap<>();
            map.put("resNo", resNo);

            return notificationMapper
                .insertReservationRequestedForCompany(map) > 0;
        });
    }
    
    public boolean createReservationConfirmed(Object resNo) {

        return tryCreate("예약 확정", () -> {
            HashMap<String, Object> map = new HashMap<>();
            map.put("resNo", resNo);

            return notificationMapper
                .insertReservationConfirmedForUser(map) > 0;
        });
    }
    
    public boolean createReservationCanceled(Object resNo) {

        return tryCreate("예약 취소", () -> {
            HashMap<String, Object> map = new HashMap<>();
            map.put("resNo", resNo);

            return notificationMapper
                .insertReservationCanceledForUser(map) > 0;
        });
    }
    
    public boolean createReservationCanceledForCompany(Object resNo) {

        return tryCreate("업체 예약 취소", () -> {
            HashMap<String, Object> map = new HashMap<>();
            map.put("resNo", resNo);

            return notificationMapper
                .insertReservationCanceledForCompany(map) > 0;
        });
    }
    
    public void sendReviewRequestNotifications() {
        createReviewRequestNotificationsByDelay(
            1,
            "REVIEW_REQUEST_1DAY",
            "이용하신 상품은 어떠셨나요? 다른 예비부부를 위해 후기를 남겨주세요."
        );

        createReviewRequestNotificationsByDelay(
            7,
            "REVIEW_REQUEST_7DAYS",
            "예약하신 상품 이용일로부터 일주일이 지났어요. 바쁘시겠지만 아직 후기를 남기지 않으셨다면 경험을 공유해주세요. 작은 후기 하나가 다른 예비부부에게 큰 도움이 됩니다."
        );

        createReviewRequestNotificationsByDelay(
            30,
            "REVIEW_REQUEST_30DAYS",
            "예약하신 상품 이용일로부터 한 달이 지났어요. 혹시 아직 후기를 남기지 않으셨다면 잠시만 시간을 내어 경험을 들려주세요. 회원님의 진솔한 후기가 다른 예비부부들의 선택에 큰 힘이 됩니다."
        );
    }

    private void createReviewRequestNotificationsByDelay(
            int delayDays,
            String notificationType,
            String content) {

        try {
            HashMap<String, Object> param = new HashMap<>();

            param.put("delayDays", delayDays);
            param.put("notificationType", notificationType);

            List<HashMap<String, Object>> targetList =
                notificationMapper.selectReviewRequestTargetList(param);

            for (HashMap<String, Object> target : targetList) {
                target.put("notificationType", notificationType);
                target.put("content", content);

                notificationMapper.insertReviewRequestNotification(target);
            }

        } catch (Exception e) {
            System.err.println(
                "리뷰 독려 알림 생성 실패("
                + notificationType
                + "): "
                + e.getMessage()
            );
        }
    }
    
    public boolean createProductInquiryReceived(Object inquiryNo) {

        return tryCreate("상품 문의 접수", () -> {
            HashMap<String, Object> map = new HashMap<>();
            map.put("inquiryNo", inquiryNo);

            return notificationMapper
                .insertProductInquiryReceivedForCompany(map) > 0;
        });
    }

    public boolean createProductInquiryAnswered(Object inquiryNo) {

        return tryCreate("상품 문의 답변", () -> {
            HashMap<String, Object> map = new HashMap<>();
            map.put("inquiryNo", inquiryNo);

            return notificationMapper
                .insertProductInquiryAnsweredForUser(map) > 0;
        });
    }
    
    public boolean createCouponIssued(String userId, String couponCode) {

        return tryCreate("쿠폰 발급", () -> {
            HashMap<String, Object> map = new HashMap<>();
            map.put("userId", userId);
            map.put("couponCode", couponCode);

            return notificationMapper
                .insertCouponIssuedForUser(map) > 0;
        });
    }
    
    public boolean createGiftconIssued(String userId, String couponCode, Object reviewNo) {

        return tryCreate("기프티콘 발급", () -> {
            HashMap<String, Object> map = new HashMap<>();
            map.put("userId", userId);
            map.put("couponCode", couponCode);
            map.put("reviewNo", reviewNo);

            return notificationMapper
                .insertGiftconIssuedForUser(map) > 0;
        });
    }
    
    public boolean createReviewCommented(Object commentNo) {

        return tryCreate("리뷰 댓글", () -> {
            HashMap<String, Object> map = new HashMap<>();
            map.put("commentNo", commentNo);

            return notificationMapper
                .insertReviewCommentedForAuthor(map) > 0;
        });
    }

    public boolean createPostCommented(Object commentNo) {

        return tryCreate("게시글 댓글", () -> {
            HashMap<String, Object> map = new HashMap<>();
            map.put("commentNo", commentNo);

            return notificationMapper
                .insertPostCommentedForAuthor(map) > 0;
        });
    }
    
    public boolean createCompanyReviewReceived(Object reviewNo) {
        return tryCreate("업체 리뷰 등록", () -> {
            HashMap<String, Object> map = new HashMap<>();
            map.put("reviewNo", reviewNo);

            return notificationMapper
                .insertCompanyReviewReceived(map) > 0;
        });
    }

    public boolean createPartnerApproved(
            String userId,
            String senderId) {

        return tryCreate("업체 제휴 승인", () -> {
            HashMap<String, Object> map = createBaseMap(senderId);
            map.put("userId", userId);

            return notificationMapper
                .insertPartnerApproved(map) > 0;
        });
    }

    public boolean createPartnerApplicationReceived(
            Object companyNo,
            String senderId) {

        return tryCreate("업체 제휴 결제 접수", () -> {
            HashMap<String, Object> map = createBaseMap(senderId);
            map.put("companyNo", companyNo);

            return notificationMapper
                .insertPartnerApplicationReceived(map) > 0;
        });
    }
}
