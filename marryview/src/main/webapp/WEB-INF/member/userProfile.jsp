<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="/js/page-change.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <title>${profile.nickname}님의 프로필</title>
    <style>
        .profile-header {
            display: flex;
            align-items: center;
            gap: 16px;
            padding: 24px;
            background: white;
            border-radius: 12px;
            border: 1px solid #f0e0e0;
            margin-bottom: 20px;
        }
        .profile-header img {
            width: 70px;
            height: 70px;
            object-fit: contain;
            border-radius: 50%;
            border: 2px solid #ffb6c1;
            padding: 4px;
            background: #fff0f3;
        }
        .profile-header .nick {
            font-size: 18px;
            font-weight: 600;
            color: #333;
        }
        .tab-wrap {
            display: flex;
            gap: 0;
            border-bottom: 2px solid #f0e0e0;
            margin-bottom: 16px;
        }
        .tab-btn {
            padding: 10px 24px;
            cursor: pointer;
            font-size: 14px;
            color: #999;
            border-bottom: 2px solid transparent;
            margin-bottom: -2px;
        }
        .tab-btn.active {
            color: #e07a8a;
            font-weight: 600;
            border-bottom: 2px solid #e07a8a;
        }
        .tab-content {
            background: white;
            border-radius: 12px;
            border: 1px solid #f0e0e0;
            padding: 16px;
            min-height: 330px;
            position: relative; 
            padding-bottom: 60px;
        }
        .list-item {
            padding: 12px 0;
            border-bottom: 1px solid #f5f5f5;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .list-item:last-child {
            border-bottom: none;
        }
        .list-item .title {
            font-size: 14px;
            color: #333;
            text-decoration: none;
        }
        .list-item .title:hover {
            color: #e07a8a;
        }
        .list-item .date {
            font-size: 12px;
            color: #aaa;
            white-space: nowrap;
        }
        .empty-msg {
            text-align: center;
            color: #bbb;
            font-size: 14px;
            padding: 40px 0;
        }
        #app {
            max-width: 800px;
            margin: 40px auto;
            padding: 0 16px;
        }

        .pagination {
            display: flex;
            justify-content: center;
            gap: 6px;
            position: absolute;  /* ✅ 절대 위치 */
            bottom: 16px;        /* ✅ 하단 고정 */
            left: 0;
            right: 0;
        }
        .pagination button {
            padding: 4px 10px;
            border: 1px solid #f0e0e0;
            border-radius: 4px;
            background: white;
            cursor: pointer;
            font-size: 13px;
            color: #666;
        }
        .pagination button.active {
            background: #e07a8a;
            color: white;
            border-color: #e07a8a;
        }
        .pagination button:disabled {
            opacity: 0.4;
            cursor: default;
        }
        .category-tag {
            display: inline-block;
            font-size: 11px;
            padding: 2px 6px;
            border-radius: 10px;
            background: #fff0f3;
            color: #e07a8a;
            margin-right: 6px;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
    <div id="app">
        <!-- 프로필 헤더 -->
        <div class="profile-header">
            <img src="/img/profile/${not empty profile.profileImg ? profile.profileImg : 'heart.png'}" alt="프로필">
            <div class="nick">${profile.nickname}</div>
        </div>

        <!-- 탭 -->
        <div class="tab-wrap">
            <div class="tab-btn" :class="{'active': activeTab === 'review'}" @click="activeTab = 'review'">리뷰</div>
            <div class="tab-btn" :class="{'active': activeTab === 'post'}" @click="activeTab = 'post'">게시글</div>
            <div class="tab-btn" :class="{'active': activeTab === 'comment'}" @click="activeTab = 'comment'">댓글</div>
        </div>

        <!-- 탭 내용 -->
        <div class="tab-content">
            <!-- 리뷰 탭 -->
            <div v-if="activeTab === 'review'">
                <div v-if="reviewList.length === 0" class="empty-msg">작성한 리뷰가 없습니다.</div>
                <div v-for="item in reviewList" :key="item.reviewNo" class="list-item">
                    <a :href="'/api/review/detail.do?reviewNo=' + item.reviewNo" class="title">{{item.title}}</a>
                    <span class="date">{{item.regDate}}</span>
                </div>
                <!-- 리뷰 페이지네이션 -->
                <div class="pagination" v-if="reviewTotalPages > 0">
                    <button :disabled="reviewPage === 1" @click="goPage('review', reviewPage - 1)">이전</button>
                    <button v-for="n in reviewTotalPages" :key="n"
                        :class="{'active': n === reviewPage}"
                        @click="goPage('review', n)">{{n}}</button>
                    <button :disabled="reviewPage === reviewTotalPages" @click="goPage('review', reviewPage + 1)">다음</button>
                </div>
            </div>
            <!-- 게시글 탭 -->
            <div v-if="activeTab === 'post'">
                <div v-if="postList.length === 0" class="empty-msg">작성한 게시글이 없습니다.</div>
                <div v-for="item in postList" :key="item.postNo" class="list-item">
                    
                    <a :href="'/api/community/detail.do?postNo=' + item.postNo" class="title">
                        <span class="category-tag" v-if="item.category">{{item.category}}</span>
                        {{item.title}}
                    </a>
                    <span class="date">{{item.regDate}}</span>
                </div>
                <!-- 게시글 페이지네이션 -->
                <div class="pagination" v-if="postTotalPages > 0">
                    <button :disabled="postPage === 1" @click="goPage('post', postPage - 1)">이전</button>
                    <button v-for="n in postTotalPages" :key="n"
                        :class="{'active': n === postPage}"
                        @click="goPage('post', n)">{{n}}</button>
                    <button :disabled="postPage === postTotalPages" @click="goPage('post', postPage + 1)">다음</button>
                </div>
            </div>
            <!-- 댓글 탭 -->
            <div v-if="activeTab === 'comment'">
                <div v-if="commentList.length === 0" class="empty-msg">작성한 댓글이 없습니다.</div>
                <div v-for="item in commentList" :key="item.commentNo" class="list-item">
                    <span class="title">{{item.content}}</span>
                    <span class="date">{{item.regDate}}</span>
                </div>
                <!-- 댓글 페이지네이션 -->
                <div class="pagination" v-if="commentTotalPages > 0">
                    <button :disabled="commentPage === 1" @click="goPage('comment', commentPage - 1)">이전</button>
                    <button v-for="n in commentTotalPages" :key="n"
                        :class="{'active': n === commentPage}"
                        @click="goPage('comment', n)">{{n}}</button>
                    <button :disabled="commentPage === commentTotalPages" @click="goPage('comment', commentPage + 1)">다음</button>
                </div>
            </div>
        </div>
    </div>
    <input type="hidden" id="targetUserId" value="${targetUserId}">
    <script src="/js/userProfile.js"></script>
    <jsp:include page="/WEB-INF/common/footer.jsp" />
</body>
</html>