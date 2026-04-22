<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>리뷰 상세보기</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <style>
        .detail-container { max-width: 800px; margin: 30px auto; padding: 30px; background: #fff; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        .info-card { background: #fff9fa; border: 1px solid #ffccd5; border-radius: 10px; padding: 15px; display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 20px; color: #555; }
        .img-wrapper { display: flex; flex-wrap: wrap; gap: 10px; justify-content: center; margin-bottom: 20px; }
        .review-img { max-width: 100%; height: auto; border-radius: 8px; border: 1px solid #eee; transition: 0.3s; }
        .review-img:hover { transform: scale(1.02); }
        .multi-img { max-width: calc(50% - 10px); }
        .review-content { font-size: 1.1rem; line-height: 1.8; white-space: pre-wrap; margin-bottom: 30px; color: #333; }
        
        /* 댓글 섹션 */
        .comment-section { margin-top: 50px; border-top: 2px solid #fff0f3; padding-top: 30px; }
        .comment-count { color: #ff4d6d; font-weight: bold; }
        .comment-item { padding: 20px 10px; border-bottom: 1px solid #fff0f3; transition: 0.2s; }
        .comment-item:hover { background-color: #fffafb; }
        .comment-user { font-weight: 600; color: #444; }
        .comment-date { font-size: 0.8rem; color: #bbb; margin-left: 10px; }
        .comment-content { margin-top: 10px; font-size: 0.95rem; color: #555; line-height: 1.5; }
        
        /* 대댓글(답글) 스타일 */
        .reply-item { margin-left: 40px; background-color: #fcfcfc; border-left: 3px solid #ffccd5; }
        .reply-mark { color: #ff4d6d; font-weight: bold; margin-right: 5px; }
        
        .comment-input-box { background: #fff9fa; border: 1px solid #ffccd5; padding: 20px; border-radius: 15px; margin-top: 30px; }
        .comment-input-box textarea { border: 1px solid #ffccd5; border-radius: 10px; resize: none; }
        .comment-input-box textarea:focus { border-color: #ff4d6d; box-shadow: 0 0 0 0.2rem rgba(255, 77, 109, 0.1); }
        .btn-comment { background-color: #ff4d6d; border: none; color: white; border-radius: 8px; font-weight: bold; }
        .btn-comment:hover { background-color: #ff3355; }
        
        .comment-action-btns { font-size: 0.75rem; color: #aaa; }
        .comment-action-btns span { cursor: pointer; margin-left: 10px; }
        .comment-action-btns span:hover { color: #ff4d6d; text-decoration: underline; }
        
        /* 댓글 좋아요 스타일 */
        .comment-like-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px !important;  
            cursor: pointer;
            margin-left: 15px;
        }
        .comment-like-btn:hover { transform: scale(1.1); }
        .like-active { color: #ff4d6d !important; font-weight: bold; }
    </style>
</head>
<body>
    <div id="app">
        <jsp:include page="/WEB-INF/common/header.jsp" />

        <div class="detail-container" v-if="info">
            <div class="border-bottom pb-3 mb-4">
                <div class="d-flex justify-content-between align-items-start">
                    <span :class="info.isPaid == 1 ? 'badge badge-danger' : 'badge badge-primary'">
                        {{ info.isPaid == 1 ? '유료리뷰' : '무료리뷰' }}
                    </span>
                    <div v-if="info.userId !== sessionId">
                        <button class="btn btn-sm btn-outline-secondary border-0" @click="fnReportReview">
                            <i class="fas fa-bullhorn text-danger mr-1"></i> <span class="small text-muted">신고</span>
                        </button>
                    </div>
                </div>
                <h2 class="mt-3" style="font-weight: 700; color: #222;">{{ info.title }}</h2>
                <div class="d-flex justify-content-between align-items-center flex-wrap">
                    <small class="text-muted">작성자: <b>{{ info.userId }}</b> | {{ info.regDate }}</small>
                    <small class="text-muted"><i class="far fa-eye"></i> {{ info.viewCnt }} | <i class="far fa-heart text-danger"></i> {{ info.likeCnt }}</small>
                </div>
            </div>

            <div class="info-card">
                <div><i class="fas fa-store mr-2" style="color:#ff4d6d"></i> <b>업체:</b> {{ info.comName }}</div>
                <div><i class="fas fa-won-sign mr-2" style="color:#ff4d6d"></i> <b>비용:</b> {{ Number(info.totalCost || 0).toLocaleString() }}원</div>
                <div><i class="fas fa-star mr-2" style="color:#ffb703"></i> <b>평점:</b> {{ info.rating }} / 5.0</div>
                <div><i class="fas fa-link mr-2" style="color:#ff4d6d"></i> <b>경로:</b> {{ info.bookingSource }}</div>
            </div>

            <div v-if="imgList.length > 0" class="img-wrapper">
                <img v-for="(src, index) in imgList" :key="index" :src="src" :class="['review-img', imgList.length > 1 ? 'multi-img' : 'single-img']">
            </div>

            <div class="review-content">{{ info.content }}</div>

            <div class="text-center border-bottom pb-5">
                <button class="btn btn-light border mr-2 px-4" @click="fnBack">목록으로</button>
                <button :class="info.isLiked > 0 ? 'btn-danger' : 'btn-outline-danger'" class="btn px-5 shadow-sm" @click="fnLike">
                    <i class="fas fa-heart mr-1"></i> {{ info.isLiked > 0 ? '좋아요 취소' : '좋아요' }} {{ info.likeCnt }}
                </button>
            </div>

            <div class="comment-section">
                <h5 class="mb-4">댓글 <span class="comment-count">{{ commentList.length }}</span></h5>
                
                <div class="comment-list">
                    <div v-for="item in commentList" :key="item.commentNo" :class="['comment-item', item.parentNo ? 'reply-item' : '']">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span v-if="item.parentNo" class="reply-mark">ㄴ</span>
                                <span class="comment-user">{{ item.userId }}</span>
                                <span class="comment-date">{{ item.regDate }}</span>
                                
                                <span class="comment-like-btn ml-3" @click="fnCommentLike(item)">
                                    <i :class="item.isLiked > 0 ? 'fas fa-heart text-danger' : 'far fa-heart text-muted'"></i>
                                    <small :class="{'like-active': item.isLiked > 0}">{{ item.likeCnt }}</small>
                                </span>
                            </div>
                            <div class="comment-action-btns">
                                <span v-if="!item.parentNo" @click="fnShowReply(item.commentNo)">
                                    <i class="far fa-comment-dots"></i> {{ replyTo === item.commentNo ? '취소' : '답글' }}
                                </span>
                                
                                <template v-if="item.userId === sessionId && !item.isEdit">
                                    <span @click="fnEditMode(item)"><i class="far fa-edit"></i> 수정</span>
                                    <span @click="fnDeleteComment(item.commentNo)"><i class="far fa-trash-alt"></i> 삭제</span>
                                </template>
                                <template v-else-if="item.userId !== sessionId">
                                    <span @click="fnReportComment(item)" class="report-link text-danger">
                                        <i class="fas fa-exclamation-triangle"></i> 신고
                                    </span>
                                </template>
                            </div>
                        </div>

                        <div v-if="!item.isEdit" class="comment-content">{{ item.content }}</div>
                        <div v-else class="mt-2">
                            <textarea class="form-control edit-textarea" v-model="item.content" rows="2"></textarea>
                            <div class="text-right mt-2">
                                <button class="btn btn-sm btn-light border mr-1" @click="fnCancelEdit(item)">취소</button>
                                <button class="btn btn-sm btn-comment" @click="fnUpdateComment(item)">수정완료</button>
                            </div>
                        </div>

                        <div v-if="replyTo === item.commentNo" class="mt-3 p-3 bg-white border rounded shadow-sm">
                            <textarea class="form-control" v-model="replyContent" rows="2" :placeholder="item.userId + '님께 답글 남기기...'"></textarea>
                            <div class="text-right mt-2">
                                <button class="btn btn-sm btn-comment" @click="fnSaveReply(item.commentNo)">답글 등록</button>
                            </div>
                        </div>
                    </div>
                    
                    <div v-if="commentList.length == 0" class="text-center py-5 text-muted">아직 댓글이 없습니다. 따뜻한 댓글 한마디를 남겨주세요! 🌸</div>
                </div>

                <div class="comment-input-box shadow-sm">
                    <textarea class="form-control mb-2" v-model="newComment" rows="3" placeholder="댓글을 입력해 주세요."></textarea>
                    <div class="text-right">
                        <button class="btn btn-comment px-4 py-2" @click="fnAddComment">댓글 등록</button>
                    </div>
                </div>
            </div>
        </div>
        
        <div v-else class="text-center py-5">
            <div class="spinner-border text-danger" role="status"></div>
            <p class="mt-3">정보를 불러오고 있습니다...</p>
        </div>

        <jsp:include page="/WEB-INF/common/footer.jsp" />
    </div>

    <script>
        const { createApp } = Vue;
        createApp({
            data() {
                return {
                    reviewNo: "${reviewNo}",
                    sessionId: "${sessionId}",
                    info: null,
                    imgList: [],
                    commentList: [],
                    newComment: "",
                    replyTo : null,
                    replyContent : "",
                };
            },
            methods: {
                fnGetDetail() {
                    $.ajax({
                        url: "/api/review/detail.dox",
                        type: "POST",
                        data: JSON.stringify({ reviewNo: this.reviewNo, userId: this.sessionId }),
                        contentType: "application/json",
                        success: (res) => {
                            const data = (typeof res === 'string') ? JSON.parse(res) : res;
                            if (data.result === "success") {
                                this.info = data.info;
                                if (this.info.imgUrl) {
                                    this.imgList = this.info.imgUrl.split(',').filter(url => url.trim() !== '');
                                }
                                this.fnGetComments();
                            }
                        }
                    });
                },
                fnGetComments() {
                    $.ajax({
                        url: "/api/comment/Review-list.dox",
                        type: "POST",
                        // 내 좋아요 여부를 알기 위해 sessionId도 같이 보냄
                        data: JSON.stringify({ 
                            reviewNo: this.reviewNo, 
                            userId: this.sessionId 
                        }),
                        contentType: "application/json",
                        success: (res) => {
                            const data = (typeof res === 'string') ? JSON.parse(res) : res;
                            if (data.result === "success") {
                                this.commentList = (data.list || []).map(item => ({
                                    ...item,
                                    isEdit: false,
                                    oldContent: item.content
                                }));
                            }
                        }
                    });
                },
                //  댓글 좋아요 함수 추가
                fnCommentLike(item) {

                    console.log("클릭됨!", item);
                    if (!this.sessionId || this.sessionId === 'null') return alert("로그인이 필요합니다.");
                    
                    $.ajax({
                        url: "/api/comment/like.dox",
                        type: "POST",
                        data: JSON.stringify({ 
                            commentNo: item.commentNo, 
                            userId: this.sessionId 
                        }),
                        contentType: "application/json",
                        success: (res) => {
                            console.log("서버 응답:", res); // 👈 응답이 오는지 확인
                this.fnGetComments(); // 👈 목록 갱신
                            /*const data = (typeof res === 'string') ? JSON.parse(res) : res;
                            if (data.result === "success") {
                                // 로컬에서만 살짝 바꿔도 되지만 정확성을 위해 다시 불러옴
                                this.fnGetComments();
                            }*/
                        }
                    });
                },
                fnAddComment() {
                    if (!this.newComment.trim()) return alert("내용을 입력해주세요.");
                    if (!this.sessionId || this.sessionId === 'null') return alert("로그인이 필요합니다.");

                    $.ajax({
                        url: "/api/comment/Review-add.dox",
                        type: "POST",
                        data: JSON.stringify({ 
                            reviewNo: this.reviewNo, 
                            userId: this.sessionId, 
                            content: this.newComment 
                        }),
                        contentType: "application/json",
                        success: (res) => {
                            const data = (typeof res === 'string') ? JSON.parse(res) : res;
                            if (data.result === "success") {
                                this.newComment = "";
                                this.fnGetComments();
                            }
                        }
                    });
                },
                fnEditMode(item) {
                    item.isEdit = true;
                    item.oldContent = item.content;
                },
                fnCancelEdit(item) {
                    item.isEdit = false;
                    item.content = item.oldContent;
                },
                fnUpdateComment(item) {
                    if(!item.content.trim()) return alert("내용을 입력하세요.");
                    $.ajax({
                        url: "/api/comment/update.dox",
                        type: "POST",
                        data: JSON.stringify({ 
                            commentNo: item.commentNo, 
                            content: item.content,
                            userId: this.sessionId 
                        }),
                        contentType: "application/json",
                        success: (res) => {
                            item.isEdit = false;
                            alert("댓글이 수정되었습니다.");
                        }
                    });
                },
                fnDeleteComment(commentNo) {
                    if(!confirm("댓글을 삭제하시겠습니까?")) return;
                    $.ajax({
                        url: "/api/comment/remove.dox",
                        type: "POST",
                        data: JSON.stringify({ 
                            commentNo: commentNo, 
                            userId: this.sessionId 
                        }),
                        contentType: "application/json",
                        success: (res) => {
                            alert("삭제되었습니다.");
                            this.fnGetComments();
                        }
                    });
                },
                fnReportReview() {
                    if (!this.sessionId || this.sessionId === 'null') return alert("로그인 후 이용 가능합니다.");
                    const reason = prompt("이 리뷰 게시글을 신고하시겠습니까?\n사유를 입력해 주세요.");
                    if (reason === null) return;
                    if (!reason.trim()) return alert("신고 사유는 필수입니다.");
                    this.fnSendReport('REVIEW', this.reviewNo, this.info.userId, '리뷰 게시물 신고', reason);
                },
                fnReportComment(item) {
                    if (!this.sessionId || this.sessionId === 'null') return alert("로그인 후 이용 가능합니다.");
                    const reason = prompt(`'${item.userId}'님의 댓글을 신고하시겠습니까?\n사유를 입력해 주세요.`);
                    if (reason === null) return;
                    if (!reason.trim()) return alert("신고 사유는 필수입니다.");
                    this.fnSendReport('REVIEW', item.commentNo, item.userId, '댓글 신고', reason);
                },
                fnSendReport(type, id, targetUserId, title, content) {
                    $.ajax({
                        url: "/api/report/add.dox",
                        type: "POST",
                        data: JSON.stringify({
                            reporterId: this.sessionId,
                            targetType: type,
                            targetId: id,
                            targetUserId: targetUserId,
                            reportTitle: title,
                            reportContent: content
                        }),
                        contentType: "application/json",
                        success: (res) => {
                            alert("신고가 정상적으로 접수되었습니다.");
                        }
                    });
                },
                fnLike() {
                    $.ajax({
                        url: "/api/review/like.dox",
                        type: "POST",
                        data: JSON.stringify({ reviewNo: this.reviewNo, userId: this.sessionId }),
                        contentType: "application/json",
                        success: (res) => {
                            const data = (typeof res === 'string') ? JSON.parse(res) : res;
                            if (data.result === "success") {
                                this.info.likeCnt = data.likeCnt;
                                this.info.isLiked = this.info.isLiked > 0 ? 0 : 1;
                            }
                        }
                    });
                },
                fnBack() { 
                    location.href = "/api/review/list.do"; 
                },
                fnShowReply(commentNo) {
                    this.replyTo = (this.replyTo === commentNo) ? null : commentNo;
                    this.replyContent = ""; 
                },
                fnSaveReply(parentNo) {
                    if(this.replyContent.trim() === "") {
                        alert("답글 내용을 입력해주세요.");
                        return;
                    }
                    const nParam = {
                        reviewNo: this.reviewNo,
                        content: this.replyContent,
                        parentNo: parentNo,
                        userId: this.sessionId
                    };
                    $.ajax({
                        url: "/api/comment/Review-add.dox",
                        type: "POST",
                        data: JSON.stringify(nParam),
                        contentType: "application/json",
                        success: (data) => {
                            this.replyTo = null;
                            this.fnGetComments();
                        }
                    });
                }
            },
            mounted() { this.fnGetDetail(); }
        }).mount('#app');
    </script>
</body>
</html>