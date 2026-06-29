package com.example.marryview.admin.scheduler;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.example.marryview.admin.dao.NotificationService;

@Component
public class ReviewRequestScheduler {

    @Autowired
    private NotificationService notificationService;

    // 매일 오전 9시에 리뷰 독려 알림 대상 확인
    @Scheduled(cron = "0 0 9 * * *")
    public void sendReviewRequestNotifications() {
        notificationService.sendReviewRequestNotifications();
    }
}