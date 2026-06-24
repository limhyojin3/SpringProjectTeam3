<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>커뮤니티 - MarryView</title>
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">

    <style>
:root{
    --primary-color:#ff4d6d;
    --secondary-color:#ff85a1;
    --bg-soft:#fffafa;
    --dark-text:#2d2d2d;
    --light-gray:#f8f9fa;
}

body{
    background: linear-gradient(
        180deg,
        #fff5f7 0%,
        #ffffff 300px,
        #ffffff 100%
    );
    overflow-x:hidden;
    position:relative;
}

.main-content{
    padding:80px 20px;
    max-width:1000px;
    margin:0 auto;
    min-height:1000px;
}

.post-card{
    background:#fff;
    padding:60px;
    border-radius:35px;
    border:1px solid #ffe4ec;
    box-shadow:0 20px 50px rgba(255,77,109,.08);
}

.post-header{
    border-bottom:1px solid #f3f3f3;
    padding-bottom:35px;
    margin-bottom:45px;
}

.category-tag{
    display:inline-block;
    padding:8px 18px;
    background:linear-gradient(135deg,#ffe4ec,#fff0f3);
    color:#ff4d6d;
    border-radius:999px;
    font-size:14px;
    font-weight:800;
    margin-bottom:20px;
}

.post-title{
    font-size:42px;
    font-weight:900;
    line-height:1.3;
    margin-bottom:20px;
    background:linear-gradient(135deg,#ff4d6d,#ff85a1);
    -webkit-background-clip:text;
    -webkit-text-fill-color:transparent;
}

.post-info{
    display:flex;
    align-items:center;
    gap:15px;
    color:#999;
    font-size:15px;
}

.author-name{
    color:#ff4d6d;
    font-weight:800;
}

.post-content{
    padding:40px 0 70px;
    min-height:350px;
    font-size:18px;
    line-height:2;
    color:#444;
}

.post-content img{
    max-width:100%;
    height:auto;
    border-radius:25px;
    margin:30px 0;
    box-shadow:0 10px 25px rgba(0,0,0,.08);
}

.bottom-area{
    display:flex;
    justify-content:space-between;
    align-items:center;
    padding-top:35px;
    border-top:1px solid #f3f3f3;
}

.btn-like{
    background:#fff;
    color:#ff4d6d;
    border:2px solid #ffe4ec;
    padding:14px 32px;
    border-radius:999px;
    font-weight:800;
    box-shadow:0 8px 20px rgba(255,77,109,.12);
    transition:.25s;
}

.btn-like:hover{
    background:#fff5f7;
    transform:translateY(-2px);
}

.right-btns button{
    padding:12px 25px;
    border:none;
    border-radius:14px;
    font-weight:700;
    margin-left:8px;
    transition:.2s;
}

.right-btns button:hover{
    transform:translateY(-2px);
}

.btn-list{
    background:#f8f9fa;
    color:#666;
}

.btn-edit{
    background:#ff85a1;
    color:#fff;
}

.btn-delete{
    background:#ff4d6d;
    color:#fff;
}

.comment-section{
    margin-top:70px;
    padding-bottom:100px;
}

.comment-title{
    font-size:24px;
    font-weight:900;
    color:#333;
    margin-bottom:25px;
}

.comment-title b{
    color:#ff4d6d;
}

.comment-write-box{
    background:#fff;
    padding:30px;
    border-radius:25px;
    border:1px solid #ffe4ec;
    box-shadow:0 10px 25px rgba(255,77,109,.05);
}

.comment-write-box textarea{
    background:#fff8fa;
    border:none;
    border-radius:15px;
    padding:15px;
    font-size:15px;
}

.comment-write-box textarea:focus{
    background:#fff;
    outline:none;
    box-shadow:0 0 0 3px rgba(255,77,109,.15);
}

.btn-primary-sm{
    background:linear-gradient(135deg,#ff4d6d,#ff85a1);
    color:#fff;
    border:none;
    border-radius:12px;
    padding:10px 25px;
    font-weight:700;
}

.comment-item{
    padding:28px 0;
    border-bottom:1px solid #fff1f4;
    transition:.25s;
}

.comment-item:hover{
    background:#fffafb;
}

.is-reply{
    margin-left:50px;
    background:#fff7f9;
    padding:20px 25px;
    border-radius:20px;
    margin-top:10px;
    border:none;
    position:relative;
}

.is-reply::before{
    content:"↳";
    position:absolute;
    left:-25px;
    top:20px;
    color:#ffb3c1;
    font-size:20px;
}

.comment-header{
    display:flex;
    justify-content:space-between;
    margin-bottom:10px;
    font-size:15px;
}

.comment-body{
    color:#555;
    line-height:1.8;
    font-size:16px;
}

.comment-footer{
    display:flex;
    align-items:center;
    gap:15px;
    margin-top:12px;
}

.comment-like-btn{
    cursor:pointer;
    color:#999;
    font-size:14px;
    display:flex;
    align-items:center;
    gap:5px;
}

.comment-like-btn:hover{
    color:#ff4d6d;
}

.action-link{
    font-size:13px;
    color:#bbb;
    cursor:pointer;
    font-weight:700;
}

.action-link:hover{
    color:#ff4d6d;
}

.btn-report{
    background:#fff7f9;
    color:#ff4d6d;
    border:1px solid #ffd6df;
    padding:7px 14px;
    border-radius:10px;
    font-size:13px;
    font-weight:700;
}

.btn-report:hover{
    background:#ffe8ee;
}

.nickname-link{
    text-decoration:none;
    color:inherit;
}

.nickname-link:hover{
    color:#ff4d6d;
    text-decoration:none;
}

.nickname-container{
    position:relative;
    display:inline-block;
}

.profile-hover-modal{
    position:absolute;
    top:50%;
    left:110%;
    width:190px;
    background:#fff;
    border-radius:18px;
    padding:16px;
    border:1px solid #ffe4ec;
    box-shadow:0 15px 35px rgba(255,77,109,.15);
    z-index:9999;
    transform:translateY(-50%) scale(.95);
    opacity:0;
    animation:profilePopup .25s ease-out forwards;
}

.profile-hover-modal::before{
    content:"";
    position:absolute;
    left:-8px;
    top:50%;
    transform:translateY(-50%);
    border-top:8px solid transparent;
    border-bottom:8px solid transparent;
    border-right:8px solid white;
}

@keyframes profilePopup{
    from{
        opacity:0;
        transform:translateY(-50%) scale(.9);
    }
    to{
        opacity:1;
        transform:translateY(-50%) scale(1);
    }
    
}
.petal{
    position:fixed;
    top:-50px;
    pointer-events:none;
    z-index:-1;
    opacity:.25;

    animation:
        fall linear infinite,
        sway ease-in-out infinite;
}

@keyframes fall{
    from{
        transform:translateY(-50px) rotate(0deg);
    }
    to{
        transform:translateY(110vh) rotate(360deg);
    }
}

@keyframes sway{
    0%,100%{
        margin-left:0;
    }
    50%{
        margin-left:40px;
    }
}
</style>
</head>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
    <div class="petal">🤍</div>
<div class="petal">🤍</div>
<div class="petal">🤍</div>
<div class="petal">🌸</div>
<div class="petal">🌸</div>
<div class="petal">🌸</div>
<div class="petal">🤍</div>
<div class="petal">🤍</div>
<div class="petal">🤍</div>
<div class="petal">🌸</div>
<div class="petal">🌸</div>
<div class="petal">🌸</div>
    <div id="app">
        <main class="main-content">
            <template v-if="post && post.postNo">
                <div class="post-card">
                    <!-- 게시글 헤더 -->
                    <div class="post-header">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="category-tag"># {{ post.category || '일반' }}</span>
                            <button v-if="sessionId && post.userId !== sessionId && post.nickname !== '탈퇴회원'" 
                                    class="btn-report" 
                                    @click="fnOpenReportModal('POST', post.postNo, post.userId)">
                                <i class="fas fa-exclamation-circle"></i> 신고하기
                            </button>
                        </div>
                        <h2 class="post-title">{{ post.title }}</h2>
                        <div class="post-info">
                            <a 
                            v-if="post.nickname !== '탈퇴회원'"
                            :href="'/userProfile.do?userId=' + post.userId" class="nickname-link">
                                <span class="author-name">@{{ post.nickname }}</span>
                            </a>
                            <b v-else class="text-danger">{{ post.nickname }}</b>
                            <span class="text-light">|</span>
                            <span>{{ post.regDate }}</span>
                            <span class="text-light">|</span>
                            <span>조회 {{ post.viewCnt }}</span>
                        </div>
                    </div>

                    <!-- 게시글 본문 -->
                    <div class="post-content" v-html="post.content"></div>

                    <!-- 하단 반응/버튼 -->
                    <div class="bottom-area">
                        <button class="btn-like" @click="post.nickname !== '탈퇴회원' ? fnPostLike() : null" :style="post.nickname === '탈퇴회원' ? 'cursor: default; opacity: 0.7;' : ''">
                            <span v-if="post && post.isLiked > 0">❤️</span>
                            <span v-else>🤍</span>
                            좋아요 {{ post.likeCnt || 0 }}
                        </button>
                        
                        <div class="right-btns">
                            <button class="btn-list" @click="fnGoList">목록으로</button>
                            <button v-if="post.userId === sessionId" class="btn-edit" @click="fnEdit">수정</button>
                            <button v-if="post.userId === sessionId || sessionRole === 'ADMIN'" 
                                    class="btn-delete" 
                                    @click="fnRemove">
                                삭제
                            </button>
                        </div>
                    </div>
                </div>

                <!-- 댓글 섹션 -->
                <div class="comment-section">
                    <h5 class="comment-title">댓글 <b>{{ commentList.length }}</b></h5>
                    
                    <!-- 댓글 입력 -->
                    <div class="comment-write-box mb-5" v-if="sessionId && post.nickname !== '탈퇴회원'">
                        <textarea v-model="newComment" class="form-control" placeholder="따뜻한 댓글을 남겨주세요." rows="3"></textarea>
                        <div class="text-right mt-3">
                            <button class="btn-primary-sm" @click="fnAddComment(null)">등록하기</button>
                        </div>
                    </div>
                    <div v-else-if="post.nickname === '탈퇴회원'" class="alert alert-light text-center py-4" style="border-radius: 20px;">
                        탈퇴한 사용자의 게시글에는 댓글을 작성할 수 없습니다.
                    </div>

                    <!-- 댓글 리스트 -->
                    <div class="comment-list">
                        <div v-for="item in commentList" :key="item.commentNo" :class="['comment-item', { 'is-reply': item.parentNo }]">
                            <div class="comment-header">

                                <div>
                                    <!-- 정상 댓글 -->
                                    <template v-if="item.isDeleted == 0 && item.nickname !== '탈퇴회원'">

                                        <div class="nickname-container"
                                            @mouseenter="fnShowHover(item.userId)"
                                            @mouseleave="fnHideHover">

                                            <a :href="'/userProfile.do?userId=' + item.userId"
                                            class="nickname-link">
                                                @{{ item.nickname }}
                                            </a>

                                            <div v-if="hoverUserId === item.userId && hoverInfo"
                                                class="profile-hover-modal">

                                                <div style="text-align:center;">

                                                    <img
                                                        :src="'/img/profile/' + (hoverInfo.info.profileImg || 'heart.png')"
                                                        style="width:50px;height:50px;border-radius:50%;object-fit:cover;">

                                                    <div class="mt-2 font-weight-bold">
                                                        {{ hoverInfo.info.nickName }}
                                                    </div>

                                                    <div style="font-size:12px;color:#666;">
                                                        게시글 {{ hoverInfo.postTotal }}
                                                        |
                                                        리뷰 {{ hoverInfo.reviewTotal }}
                                                    </div>

                                                </div>

                                            </div>

                                        </div>

                                    </template>

                                    <!-- 탈퇴회원 -->
                                    <template v-else-if="item.nickname === '탈퇴회원'">
                                        <span class="text-danger">탈퇴회원</span>
                                    </template>

                                    <!-- 관리자 삭제 -->
                                    <template v-else-if="item.delRole === 'ADMIN'">
                                        <span class="text-muted">[관리자 삭제]</span>
                                    </template>

                                    <!-- 일반 삭제 -->
                                    <template v-else>
                                        <span class="text-muted">[삭제된 댓글]</span>
                                    </template>
                                </div>

                                <span class="text-muted small">
                                    {{ item.regDate }}
                                </span>

                            </div>

                            <div class="comment-body mt-2">
                                <template v-if="item.isDeleted == 1">
                                    <span class="text-muted" style="font-style: italic;">삭제된 댓글입니다.</span>
                                </template>
                                <template v-else-if="item.nickname === '탈퇴회원'">
                                    <span class="text-muted" style="font-style: italic;">탈퇴한 사용자의 댓글입니다.</span>
                                </template>
                                <template v-else>
                                    <!-- [수정 기능 추가] 수정 모드가 아닐 때 -->
                                    <div v-if="!item.isEdit">
                                        {{ item.content }}
                                    </div>
                                    <!-- [수정 기능 추가] 수정 모드일 때 -->
                                    <div v-else class="edit-box">
                                        <textarea v-model="item.content" class="form-control mb-2" rows="2"></textarea>
                                        <div class="text-right">
                                            <button class="btn btn-xs btn-light border mr-1" @click="item.isEdit = false">취소</button>
                                            <button class="btn btn-xs btn-dark" @click="fnUpdateComment(item)">수정완료</button>
                                        </div>
                                    </div>
                                </template>
                            </div>

                            <div class="comment-footer" v-if="item.isDeleted == 0 && !item.isEdit">
                                <template v-if="post.nickname !== '탈퇴회원' && item.nickname !== '탈퇴회원'">
                                    <span class="comment-like-btn" @click="fnCommentLike(item)">
                                        <i :class="item.isLiked > 0 ? 'fas fa-heart text-danger' : 'far fa-heart'"></i>
                                        <b>{{ item.likeCnt }}</b>
                                    </span>
                                    
                                    <span class="action-link" v-if="!item.parentNo && sessionId" @click="item.showReply = !item.showReply">답글달기</span>
                                    
                                    <span class="action-link" 
                                          v-if="sessionId && item.userId !== sessionId && sessionRole !== 'ADMIN'" 
                                          @click="fnOpenReportModal('COMMENT', item.commentNo, item.userId)">
                                        신고
                                    </span>
                                </template>

                                <span class="action-link" v-if="item.userId === sessionId" @click="fnEditMode(item)">수정</span>
                                <span class="action-link" v-if="item.userId === sessionId || sessionRole === 'ADMIN'" @click="fnRemoveComment(item.commentNo)">삭제</span>
                            </div>

                            <!-- 답글 입력창 -->
                            <div class="mt-3 p-3 bg-white shadow-sm rounded" v-if="item.isDeleted == 0 && item.showReply && item.nickname !== '탈퇴회원' && post.nickname !== '탈퇴회원'">
                                <textarea v-model="item.replyContent" class="form-control border-0 bg-light" rows="2" placeholder="답글을 작성하세요..."></textarea>
                                <div class="text-right mt-2">
                                    <button class="btn btn-sm btn-dark px-3" @click="fnAddComment(item)">답글 등록</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </template>
            
            <div v-else class="text-center py-5">
                <div class="spinner-border text-danger mb-3" role="status"></div>
                <p class="text-muted">게시글을 소중히 불러오고 있습니다...</p>
            </div>
        </main>

        <!-- 신고 모달 -->
        <div class="modal fade" id="reportModal" tabindex="-1" role="dialog">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content" style="border-radius: 25px; border: none; overflow: hidden;">
                    <div class="modal-header" style="background: #fff; border-bottom: 1px solid #f8f9fa; padding: 25px 30px;">
                        <h5 class="modal-title font-weight-bold">신고 접수</h5>
                        <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                    </div>
                    <div class="modal-body" style="padding: 30px;">
                        <div class="form-group mb-4">
                            <label class="small font-weight-bold text-muted">신고 제목</label>
                            <input type="text" v-model="reportInfo.report_title" class="form-control border-0 bg-light" style="border-radius: 12px; padding: 12px;" placeholder="사유를 간단히 입력하세요.">
                        </div>
                        <div class="form-group">
                            <label class="small font-weight-bold text-muted">상세 신고 내용</label>
                            <textarea v-model="reportInfo.report_content" class="form-control border-0 bg-light" style="border-radius: 12px; padding: 12px;" rows="5" placeholder="신고 사유를 구체적으로 적어주시면 관리에 큰 도움이 됩니다."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer" style="border-top: none; padding: 0 30px 30px;">
                        <div class="row w-100 m-0">
                            <div class="col-6 pl-0 pr-2">
                                <button type="button" class="btn btn-light w-100 py-3" style="border-radius: 15px; font-weight: 700;" data-dismiss="modal">취소</button>
                            </div>
                            <div class="col-6 pr-0 pl-2">
                                <button type="button" class="btn btn-danger w-100 py-3" style="border-radius: 15px; background: var(--primary-color); border:none; font-weight: 700;" @click="fnSubmitReport">제출하기</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/WEB-INF/common/footer.jsp" />
    </div>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    postNo: "${postNo}", 
                    post: {}, 
                    commentList: [],
                    newComment: "",
                    sessionId: "${sessionId}",
                    sessionRole: "${sessionRole}",
                    reportInfo: {
                        target_type: '',
                        target_id: '',
                        target_user_id: '',
                        report_title: '',
                        report_content: ''
                    },
                    hoverUserId : null,
                    hoverInfo : null,
                };
            },
            methods: {
                fnShowHover(userId) {
                    this.hoverUserId = userId;

                    axios.get('/userProfileSimple.dox', {
                        params : {
                            userId : userId
                        }
                    }).then(res => {
                        this.hoverInfo = res.data;
                    });
                },

                fnHideHover() {
                    this.hoverUserId = null;
                    this.hoverInfo = null;
                },
                fnGetDetail() {
                    $.ajax({
                        url: "/api/community/getPost.dox",
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json",
                        data: JSON.stringify({ postNo : this.postNo }),
                        success: (res) => {
                            if(res.post) {
                                this.post = res.post;
                                this.fnGetComments();
                            }
                        }
                    });
                },
                fnOpenReportModal(type, id, targetUser) {
                    this.reportInfo = {
                        target_type: type,
                        target_id: id,
                        target_user_id: targetUser,
                        report_title: '',
                        report_content: ''
                    };
                    $('#reportModal').modal('show');
                },
                fnSubmitReport() {
                    if(!this.reportInfo.report_title || !this.reportInfo.report_content) {
                        return alert("제목과 내용을 모두 입력해주세요.");
                    }

                    const sendData = {
                        reporterId: this.sessionId,
                        targetType: this.reportInfo.target_type,
                        targetId: this.reportInfo.target_id,
                        targetUserId: this.reportInfo.target_user_id,
                        reportTitle: this.reportInfo.report_title,
                        reportContent: this.reportInfo.report_content
                    };

                    $.ajax({
                        url: "/api/report/add.dox",
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify(sendData),
                        success: (res) => {
                            if(res.result === "success") {
                                alert("신고가 정상 접수되었습니다.");
                                $('#reportModal').modal('hide');
                            } else {
                                alert(res.message || "이미 신고하셨거나 오류가 발생했습니다.");
                            }
                        }
                    });
                },
                fnGetComments() {
                    $.ajax({
                        url: "/api/comment/comm-list.dox",
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify({ postNo: this.postNo, userId: this.sessionId }),
                        success: (res) => {
                            const data = (typeof res === "string") ? JSON.parse(res) : res;
                            this.commentList = data.list.map(c => ({...c, showReply: false, replyContent: "", isEdit:false}));
                        }
                    });
                },
                fnAddComment(parentItem) {
                    const content = parentItem ? parentItem.replyContent : this.newComment;
                    if(!content) return alert("내용을 입력하세요.");
                    $.ajax({
                        url: "/api/comment/comm-add.dox",
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify({
                            postNo: this.postNo,
                            userId: this.sessionId,
                            content: content,
                            parentNo: parentItem ? parentItem.commentNo : null
                        }),
                        success: (res) => {
                            this.newComment = "";
                            this.fnGetComments();
                        }
                    });
                },
                fnCommentLike(item) {
                    if(!this.sessionId) return alert("로그인이 필요합니다.");
                    $.ajax({
                        url: "/api/comment/like.dox",
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify({ commentNo: item.commentNo, userId: this.sessionId }),
                        success: (res) => { if(res.result === "success") this.fnGetComments(); }
                    });
                },
                fnRemoveComment(commentNo) {
                    if(!confirm("삭제하시겠습니까?")) return;
                    $.ajax({
                        url: "/api/comment/remove.dox",
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify({ 
                            commentNo: commentNo,
                            userId : this.sessionId,
                            sessionRole : this.sessionRole, 
                        }),
                        success: () => { 
                            alert("삭제되었습니다");
                            this.fnGetComments(); 
                        }
                    });
                },
                fnPostLike() {
                    if(!this.sessionId) return alert("로그인이 필요합니다.");
                    $.ajax({
                        url: "/api/community/toggleLike.dox",
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json",
                        data: JSON.stringify({ postNo : this.postNo }),
                        success: (res) => {
                            if(res.result === "success") this.fnGetDetail();
                        }
                    });
                },
                fnGoList() { location.href = "/api/community/list.do"; },
                fnRemove() {
                    if(!confirm("정말 삭제하시겠습니까?")) return;
                    $.ajax({
                        url: "/api/community/remove.dox",
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json",
                        data: JSON.stringify({ postNo : this.postNo }),
                        success: () => {
                            alert("삭제되었습니다.");
                            this.fnGoList();
                        }
                    });
                },
                fnEdit() {
                    location.href = "/api/community/edit.do?postNo=" + this.postNo; 
                },
                fnEditMode(item) {
                    // 1. 모든 댓글의 수정 모드를 해제 (한 번에 하나만 수정 가능하게 설정)
                    this.commentList.forEach(c => {
                        c.isEdit = false;
                    });

                    // 2. 현재 클릭한 댓글만 수정 모드로 전환
                    // Vue 3에서는 직접 할당해도 화면이 바로 바뀝니다.
                    item.isEdit = true;
                    
                    // 3. (선택사항) 취소 시 복구를 위해 기존 내용을 저장해둡니다.
                    item.oldContent = item.content;
                },

                // 2. 수정 완료 처리
                fnUpdateComment(item) {
                    console.log("보내는 데이터:", { commentNo: item.commentNo, content: item.content }); // 이 로그가 찍히는지 확인
                    if (!item.content.trim()) {
                        alert("수정할 내용을 입력해 주세요.");
                        return;
                    }

                    var self = this;
                    var nparmap = {
                        commentNo: item.commentNo,
                        content: item.content
                    };

                    // 기존 리뷰 수정 API 주소 확인 후 변경 필요 (.dox 등)
                    $.ajax({
                        url: "/api/comment/update.dox", // 커뮤니티 댓글 전용 수정 경로
                        type: "POST",
                        data: JSON.stringify(nparmap),
                        contentType: "application/json",
                        success: function(res) {
                            // 1. 만약 응답이 문자열로 왔다면 객체로 변환 (이미 객체라면 그대로 사용)
                            const data = (typeof res === "string") ? JSON.parse(res) : res;
                            
                            console.log("변환된 데이터:", data);
                            if (data.result === "success") {
                                alert("댓글이 수정되었습니다.");
                                item.isEdit = false; // 수정 모드 해제
                                self.fnGetComments();
                            } else {
                                alert("수정에 실패했습니다.");
                            }
                        }
                    });
                }
                
            },
            mounted() { this.fnGetDetail(); 
             document.querySelectorAll('.petal').forEach(el => {
                el.style.left = Math.random() * 100 + 'vw';
                el.style.fontSize = (20 + Math.random() * 20) + 'px';
                el.style.animationDuration = (10 + Math.random() * 10) + 's';
                el.style.animationDelay = Math.random() * 5 + 's';
            });}
        }).mount('#app');
    </script>
</body>

</html>