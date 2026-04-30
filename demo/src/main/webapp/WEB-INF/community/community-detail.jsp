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
        :root { 
            --primary-color: #ff4d6d; 
            --secondary-color: #ff85a1;
            --bg-soft: #fffafa;
            --dark-text: #2d2d2d;
            --light-gray: #f8f9fa;
        }

        body { background-color: var(--bg-soft); font-family: 'Pretendard', sans-serif; }

        .main-content { padding: 60px 20px; max-width: 1000px; margin: 0 auto; min-height: 1000px; }
        
        /* 게시글 카드 레이아웃 */
        .post-card { 
            background: #fff; padding: 50px; border-radius: 30px; 
            box-shadow: 0 10px 40px rgba(255, 77, 109, 0.05);
            border: 1px solid rgba(255, 77, 109, 0.1);
        }

        /* 헤더 섹션 */
        .post-header { border-bottom: 1px solid #f0f0f0; padding-bottom: 30px; margin-bottom: 40px; }
        .category-tag { 
            display: inline-block; padding: 6px 18px; background: #fff0f3; 
            color: var(--primary-color); border-radius: 50px; font-weight: 700; 
            font-size: 14px; margin-bottom: 20px; 
        }
        .post-title { font-size: 38px; color: var(--dark-text); font-weight: 800; margin-bottom: 20px; letter-spacing: -1.5px; }
        .post-info { display: flex; align-items: center; gap: 15px; color: #999; font-size: 15px; }
        .author-name { color: #444; font-weight: 700; }

        /* 본문 내용 */
        .post-content { 
            padding: 20px 0 60px; line-height: 1.8; min-height: 350px; 
            font-size: 18px; color: #444; 
        }
        .post-content img { max-width: 100%; height: auto; border-radius: 20px; margin: 25px 0; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }

        /* 하단 반응 및 버튼 영역 */
        .bottom-area { 
            display: flex; justify-content: space-between; align-items: center;
            padding-top: 30px; border-top: 1px solid #f0f0f0; 
        }
        
        .btn-like { 
            background: #fff; color: var(--primary-color); border: 2px solid #fff0f3; 
            padding: 12px 28px; border-radius: 50px; font-weight: 700; transition: 0.3s;
            box-shadow: 0 4px 10px rgba(255, 77, 109, 0.1);
        }
        .btn-like:hover { transform: scale(1.05); background: #fff0f3; }

        .right-btns button { padding: 12px 25px; border-radius: 14px; font-weight: 700; border: none; transition: 0.2s; margin-left: 8px; }
        .btn-list { background: var(--light-gray); color: #777; }
        .btn-edit { background: #333; color: #fff; }
        .btn-delete { background: #ffb3c1; color: #fff; }

        /* 댓글 섹션 */
        .comment-section { margin-top: 60px; padding-bottom: 100px; }
        .comment-title { font-weight: 800; font-size: 22px; margin-bottom: 25px; color: var(--dark-text); }
        .comment-title b { color: var(--primary-color); }

        /* 댓글 쓰기 상자 */
        .comment-write-box { 
            background: #fff; padding: 25px; border-radius: 20px; 
            border: 1px solid #f0f0f0; box-shadow: 0 5px 15px rgba(0,0,0,0.02);
        }
        .comment-write-box textarea { 
            border: none; background: #fafafa; border-radius: 15px; 
            padding: 15px; font-size: 15px; transition: 0.3s;
        }
        .comment-write-box textarea:focus { background: #fff; box-shadow: 0 0 0 2px var(--primary-color); outline: none; }
        .btn-primary-sm { background: var(--primary-color); color: white; padding: 10px 25px; border-radius: 12px; border: none; font-weight: 700; }

        /* 댓글 아이템 */
        .comment-item { padding: 25px 0; border-bottom: 1px solid #f5f5f5; transition: 0.3s; }
        .is-reply { 
            margin-left: 50px; background-color: #fff9fa; padding: 20px 25px; 
            border-radius: 20px; border-bottom: none; margin-top: 10px; 
            position: relative;
        }
        .is-reply::before { content: '↳'; position: absolute; left: -25px; top: 20px; color: #ccc; font-size: 20px; }

        .comment-header { display: flex; justify-content: space-between; margin-bottom: 10px; font-size: 15px; }
        .comment-body { color: #555; line-height: 1.6; font-size: 16px; }
        .comment-footer { display: flex; align-items: center; gap: 15px; margin-top: 12px; }
        
        .comment-like-btn { cursor: pointer; color: #999; font-size: 14px; display: flex; align-items: center; gap: 5px; }
        .action-link { font-size: 13px; color: #bbb; cursor: pointer; font-weight: 600; }
        .action-link:hover { color: var(--primary-color); }

        /* 신고 버튼 */
        .btn-report { background: transparent; color: #ff8a8a; border: 1px solid #ffeded; padding: 6px 14px; border-radius: 8px; font-size: 13px; font-weight: 700; }
        .btn-report:hover { background: #fff0f0; color: #dc3545; }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
    
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
                            <span class="author-name">@{{ post.nickname }}</span>
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
                                <b :class="{'text-muted': item.nickname === '탈퇴회원' || item.isDeleted == 1}">
                                    <template v-if="item.isDeleted == 0">@{{ item.nickname }}</template>
                                    <template v-else-if="item.delRole === 'ADMIN'">[관리자 삭제]</template>
                                    <template v-else>[삭제된 댓글]</template>
                                </b>
                                <span class="text-muted small">{{ item.regDate }}</span>
                            </div>

                            <div class="comment-body mt-2">
                                <template v-if="item.isDeleted == 1">
                                    <span class="text-muted" style="font-style: italic;">삭제된 댓글입니다.</span>
                                </template>
                                <template v-else-if="item.nickname === '탈퇴회원'">
                                    <span class="text-muted" style="font-style: italic;">탈퇴한 사용자의 댓글입니다.</span>
                                </template>
                                <template v-else>
                                    {{ item.content }}
                                </template>
                            </div>

                            <div class="comment-footer" v-if="item.isDeleted == 0">
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
                        url: "/api/comment/Comm-list.dox",
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify({ postNo: this.postNo, userId: this.sessionId }),
                        success: (res) => {
                            const data = (typeof res === "string") ? JSON.parse(res) : res;
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
                }
            },
            mounted() { this.fnGetDetail(); }
        }).mount('#app');
    </script>
</body>
</html>