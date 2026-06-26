package com.example.marryview.common;

import lombok.Getter;

@Getter
public class Message {
    private String result;
    private String message;

    // 생성자 (JSON 변환을 위해 필드 채우기)
    public Message(String result, String message) {
        this.result = result;
        this.message = message;
    }

    // --- [1. 단순 문자열 상수 (기존 유지)] ---
    public static final String MSG_ADD = "저장되었습니다.";
    public static final String MSG_EDIT = "수정되었습니다.";
    public static final String MSG_REMOVE = "삭제되었습니다.";
    public static final String MSG_SEARCH = "검색했습니다.";
    public static final String MSG_SERVER_ERR = "서버에 문제가 발생했습니다. 나중에 다시 시도해주세요.";
    public static final String MSG_ERR = "예기치 못한 문제가 발생했습니다. 나중에 다시 시도해주세요.";

    // --- [2. 객체 형태의 상수 (AJAX 리턴용 정석)] ---
    // 성공 관련
    public static final Message SUCCESS_ADD = new Message("success", MSG_ADD);
    public static final Message SUCCESS_EDIT = new Message("success", MSG_EDIT);
    public static final Message SUCCESS_REMOVE = new Message("success", MSG_REMOVE);

    // 에러/로그인 관련 (가장 많이 쓰임)
    public static final Message FAIL_LOGIN = new Message("fail", "로그인이 필요한 서비스입니다.");
    public static final Message FAIL_SERVER = new Message("fail", MSG_SERVER_ERR);
    public static final Message FAIL_AUTH = new Message("fail", "권한이 없습니다.");
}