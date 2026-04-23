<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="navi">
                    <button :class="['navi-btn', activeMenu === 'main' ? 'activebtn' : '']"
                        @click="fnPage('/adminMain.do')">관리자 메인 페이지</button>

                    <button :class="['navi-btn', activeMenu === 'user' ? 'activebtn' : '']"
                        @click="fnPage('/adminUser.do')">전체 회원 목록</button>

                    <button :class="['navi-btn', activeMenu === 'company' ? 'activebtn' : '']"
                        @click="fnPage('/adminCompany.do')">전체 업체 목록</button>

                    <button :class="['navi-btn', activeMenu === 'board' ? 'activebtn' : '']"
                        @click="fnPage('/adminBoard.do')">전체 게시판/리뷰 목록</button>

                    <button :class="['navi-btn', activeMenu === 'reviewWait' ? 'activebtn' : '']"
                        @click="fnPage('/adminReviewWait.do')">승인 대기중인 리뷰</button>

                    <button :class="['navi-btn', activeMenu === 'payment' ? 'activebtn' : '']"
                        @click="fnPage('/adminPayment.do')">결제 및 상품 관리</button>

                    <button :class="['navi-btn', activeMenu === 'report' ? 'activebtn' : '']"
                        @click="fnPage('/adminReport.do')">신고 관리</button>

                    <button :class="['navi-btn', activeMenu === 'inquiry' ? 'activebtn' : '']"
                        @click="fnPage('/adminInquiry.do')">문의 관리</button>

                    <button :class="['navi-btn', activeMenu === 'stats' ? 'activebtn' : '']"
                        @click="fnPage('/adminStatistics.do')">통계</button>
                </div>