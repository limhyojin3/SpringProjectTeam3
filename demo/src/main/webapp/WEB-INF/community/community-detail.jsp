<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>커뮤니티 - MerryView</title>
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <style>
        :root { --primary-color: #ff4d6d; --dark-color: #1a1a1a; }
        .main-content { padding: 50px 40px; max-width: 1000px; margin: 0 auto; min-height: 800px; }
        .post-header { border-bottom: 2px solid var(--dark-color); padding-bottom: 30px; margin-bottom: 30px; }
        .category-tag { display: inline-block; padding: 5px 15px; background: #fff0f3; color: var(--primary-color); border-radius: 20px; font-weight: 800; font-size: 0.9rem; margin-bottom: 15px; }
        .post-title { font-size: 36px; color: var(--dark-color); font-weight: 800; margin-bottom: 20px; letter-spacing: -1px; }
        .post-info { display: flex; align-items: center; gap: 15px; color: #888; font-size: 15px; }
        .post-content { padding: 50px 10px; line-height: 2; min-height: 300px; font-size: 18px; color: #333; white-space: pre-wrap; }
        .bottom-area { border-top: 1px solid #eee; padding-top: 40px; margin-top: 40px; display: flex; justify-content: space-between; align-items: center; }
        button { padding: 10px 25px; cursor: pointer; border: none; border-radius: 12px; font-size: 15px; transition: 0.3s; font-weight: 700; }
        .btn-like { background-color: #fff; color: var(--primary-color); border: 2px solid var(--primary-color); display: flex; align-items: center; gap: 8px; }
        .btn-list { background-color: #f5f5f5; color: #666; }
        .btn-edit { background-color: var(--dark-color); color: white; margin-right: 5px; }
        .btn-delete { background-color: #ffb3c1; color: #fff; }
        .comment-section { border-top: 1px solid #eee; padding-top: 50px; margin-top: 50px; }
        .comment-item { padding: 20px 0; border-bottom: 1px solid #f1f1f1; }
        .is-reply { margin-left: 50px; background-color: #fcfcfc; padding: 20px; border-radius: 15px; border-bottom: none; margin-top: 5px; }
        .comment-header { font-size: 14px; margin-bottom: 10px; }
        .comment-body { font-size: 16px; color: #444; }
        .comment-like-btn { cursor: pointer; display: inline-flex; align-items: center; gap: 8px; color: #888; font-size: 14px; }
        .text-danger { color: var(--primary-color) !important; }
        .action-link { font-size: 13px; cursor: pointer; color: #aaa; margin-left: 15px; }
        .comment-write-box textarea { border-radius: 15px; padding: 15px; border: 1px solid #ddd; resize: none; }
        .btn-primary-sm { background: var(--primary-color); color: white; padding: 8px 20px; border-radius: 10px; }
        
        /* 신고 버튼 스타일 */
        .btn-report { background-color: #fff; color: #dc3545; border: 1px solid #dc3545; padding: 5px 12px; font-size: 13px; margin-left: 10px; }
        .btn-report:hover { background-color: #dc3545; color: #fff; }
    </style>
</head>
<body>
    <div id="app">
        <jsp:include page="/WEB-INF/common/header.jsp" />

        <main class="main-content">
            <template v-if="post && post.postNo">
                <div class="post-header">
                    <div class="d-flex justify-content-between align-items-start">
                        <span class="category-tag"># {{ post.category || '일반' }}</span>
                        <button v-if="sessionId && post.userId !== sessionId" class="btn-report" @click="fnOpenReportModal('POST', post.postNo, post.userId)">
                            <i class="fas fa-siren-on"></i> 신고
                        </button>
                    </div>
                    <h2 class="post-title">{{ post.title }}</h2>
                    <div class="post-info">
                        <span>작성자 <strong>@{{ post.userId }}</strong></span>
                        <span>|</span>
                        <span>{{ post.regDate }}</span>
                        <span>|</span>
                        <span>조회 {{ post.viewCnt }}</span>
                    </div>
                </div>

                <div class="post-content">{{ post.content }}</div>

                <div class="bottom-area">
                    <button class="btn-like" @click="fnPostLike">
                        <template v-if="post && post.isLiked > 0">
                            <span style="color: #ff4d6d;">❤️</span>
                        </template>
                        <template v-else>
                            <span>🤍</span>
                        </template>
                        좋아요 {{ post.likeCnt || 0 }}
                    </button>
                    <div class="right-btns">
                        <button class="btn-list" @click="fnGoList">목록으로</button>
                        <template v-if="post.userId === sessionId">
                            <button class="btn-edit" @click="fnEdit">수정</button>
                            <button class="btn-delete" @click="fnRemove">삭제</button>
                        </template>
                    </div>
                </div>

                <div class="comment-section">
                    <h5 class="mb-4">댓글 <b>{{ commentList.length }}</b></h5>
                    
                    <div class="comment-write-box mb-4" v-if="sessionId">
                        <textarea v-model="newComment" class="form-control" placeholder="댓글을 입력해주세요." rows="3"></textarea>
                        <div class="text-right mt-2">
                            <button class="btn-primary-sm" @click="fnAddComment(null)">등록</button>
                        </div>
                    </div>

                    <div class="comment-list">
                        <div v-for="item in commentList" :key="item.commentNo" :class="['comment-item', { 'is-reply': item.parentNo }]">
                            <div class="comment-header d-flex justify-content-between">
                                <b>@{{ item.userId }}</b>
                                <span class="text-muted small">{{ item.regDate }}</span>
                            </div>
                            <div class="comment-body">{{ item.content }}</div>
                            <div class="comment-footer mt-2">
                                <span class="comment-like-btn" @click="fnCommentLike(item)">
                                    <i :class="item.isLiked > 0 ? 'fas fa-heart text-danger' : 'far fa-heart'"></i>
                                    <small>{{ item.likeCnt }}</small>
                                </span>
                                <span class="action-link" v-if="!item.parentNo && sessionId" @click="item.showReply = !item.showReply">답글</span>
                                <span class="action-link" v-if="item.userId === sessionId" @click="fnRemoveComment(item.commentNo)">삭제</span>
                                <span class="action-link text-danger" v-if="sessionId && item.userId !== sessionId" @click="fnOpenReportModal('MEMBER', item.commentNo, item.userId)">신고</span>
                            </div>

                            <div class="mt-3" v-if="item.showReply">
                                <textarea v-model="item.replyContent" class="form-control" rows="2" placeholder="답글 작성..."></textarea>
                                <div class="text-right mt-2">
                                    <button class="btn btn-sm btn-dark" @click="fnAddComment(item)">답글 등록</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </template>
            <div v-else class="text-center py-5">
                <p class="text-muted">게시글을 불러오고 있습니다...</p>
            </div>
        </main>

        <div class="modal fade" id="reportModal" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <div class="modal-content" style="border-radius: 20px;">
                    <div class="modal-header" style="border-bottom: none; padding: 30px 30px 10px;">
                        <h5 class="modal-title font-weight-bold">신고하기</h5>
                        <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                    </div>
                    <div class="modal-body" style="padding: 20px 30px;">
                        <div class="form-group">
                            <label class="small font-weight-bold">신고 제목</label>
                            <input type="text" v-model="reportInfo.report_title" class="form-control" placeholder="사유를 간단히 입력하세요.">
                        </div>
                        <div class="form-group">
                            <label class="small font-weight-bold">신고 내용</label>
                            <textarea v-model="reportInfo.report_content" class="form-control" rows="5" placeholder="상세 내용을 입력하세요."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer" style="border-top: none; padding: 10px 30px 30px;">
                        <button type="button" class="btn btn-light btn-block" style="border-radius: 10px;" data-dismiss="modal">취소</button>
                        <button type="button" class="btn btn-danger btn-block" style="border-radius: 10px; background: var(--primary-color); border:none;" @click="fnSubmitReport">신고 제출</button>
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
                    sessionId: "" ,
                    commentList: [],
                    newComment: "",
                    sessionId: "${sessionId}", // JSP 세션값이 잘 들어오는지 확인
                    // 신고 관련 데이터
                    reportInfo: {
                        target_type: '',
                        target_id: '',
                        target_user_id: '',
                        report_title: '',
                        report_content: ''
                    }
                };
            },
            methods: {
                fnGetDetail() {
                    $.ajax({
                        url: "/api/community/getPost.dox",
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json",
                        data: JSON.stringify({ postNo : this.postNo }),
                        success: (res) => {
                            const data = (typeof res === "string") ? JSON.parse(res) : res;
                            if(data.post) {
                                this.post = data.post;
                                this.sessionId = data.sessionId;
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

                    // 전송할 데이터 객체 생성 (기존 데이터 + 신고자 ID)
                    const sendData = {
                        reporterId: this.sessionId,                   // 신고자 ID
                        targetType: this.reportInfo.target_type,      // target_type -> targetType
                        targetId: this.reportInfo.target_id,          // target_id -> targetId
                        targetUserId: this.reportInfo.target_user_id, // target_user_id -> targetUserId
                        reportTitle: this.reportInfo.report_title,    // report_title -> reportTitle (중요!)
                        reportContent: this.reportInfo.report_content // report_content -> reportContent (중요!)
                    };

                    $.ajax({
                        url: "/api/report/add.dox",
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify(sendData), // reporterId가 포함된 데이터를 보냄
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
                        url: "/api/comment/Comm-list.dox",
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify({ postNo: this.postNo, userId: this.sessionId }),
                        success: (res) => {
                            const data = JSON.parse(res);
                            this.commentList = data.list.map(c => ({...c, showReply: false, replyContent: ""}));
                        }
                    });
                },
                fnAddComment(parentItem) {
                    const content = parentItem ? parentItem.replyContent : this.newComment;
                    if(!content) return alert("내용을 입력하세요.");
                    $.ajax({
                        url: "/api/comment/Comm-add.dox",
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
                        data: JSON.stringify({ commentNo: commentNo }),
                        success: () => { this.fnGetComments(); }
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
                            const data = (typeof res === "string") ? JSON.parse(res) : res;
                            if(data.result === "success") this.fnGetDetail();
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
                }
            },
            mounted() { this.fnGetDetail(); }
        }).mount('#app');
    </script>
</body>
</html>