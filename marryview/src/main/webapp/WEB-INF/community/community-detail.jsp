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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/community/community-detail.css">

    <style>

</style>
</head>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
    <div class="petal petal-heart"><i class="fas fa-heart"></i></div>
    <div class="petal petal-heart"><i class="fas fa-heart"></i></div>
    <div class="petal petal-heart"><i class="fas fa-heart"></i></div>
    <div class="petal petal-heart"><i class="fas fa-heart"></i></div>
    <div class="petal petal-heart"><i class="fas fa-heart"></i></div>
    <div class="petal petal-heart"><i class="fas fa-heart"></i></div>
    <div class="petal petal-heart"><i class="fas fa-heart"></i></div>
    <div class="petal petal-heart"><i class="fas fa-heart"></i></div>
    <div class="petal petal-heart"><i class="fas fa-heart"></i></div>
    <div class="petal petal-heart"><i class="fas fa-heart"></i></div>
    <div class="petal petal-heart"><i class="fas fa-heart"></i></div>
    <div class="petal petal-heart"><i class="fas fa-heart"></i></div>
    <div class="petal petal-heart"><i class="fas fa-heart"></i></div>
    <div class="petal petal-heart"><i class="fas fa-heart"></i></div>
    <div class="petal petal-heart"><i class="fas fa-heart"></i></div>
    <div class="petal petal-heart"><i class="fas fa-heart"></i></div>
    <div id="app">
        <jsp:include page="/WEB-INF/community/view/community-detail-view.jsp" />
    </div>
    <jsp:include page="/WEB-INF/common/footer.jsp" />

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    postNo: "${postNo}", 
                    post: {}, 
                    commentList: [],
                    newComment: "",
                    commentFile: null,
                    commentPreview: "",
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
                            this.commentList = (data.list || []).map(c => ({
                                ...c,
                                showReply: false,
                                replyContent: "",
                                replyFile: null,
                                replyPreview: "",
                                isEdit: false
                            }));
                        }
                    });
                },
                fnAddComment(parentItem) {
                    const isReply = parentItem != null;

                    const content = isReply
                        ? parentItem.replyContent
                        : this.newComment;

                    const file = isReply
                        ? parentItem.replyFile
                        : this.commentFile;

                    if (!content || !content.trim()) {
                        return alert("내용을 입력하세요.");
                    }

                    if (!this.sessionId || this.sessionId === "null") {
                        return alert("로그인이 필요합니다.");
                    }

                    const formData = new FormData();

                    formData.append("postNo", this.postNo);
                    formData.append("userId", this.sessionId);
                    formData.append("content", content.trim());

                    if (isReply) {
                        formData.append("parentNo", parentItem.commentNo);
                    }

                    if (file) {
                        // Controller의 @RequestParam 이름과 동일해야 함
                        formData.append("files", file);
                    }

                    $.ajax({
                        url: "/api/comment/comm-add.dox",
                        type: "POST",
                        data: formData,

                        // FormData에서는 반드시 false
                        processData: false,
                        contentType: false,

                        success: (res) => {
                            const data =
                                typeof res === "string"
                                    ? JSON.parse(res)
                                    : res;

                            if (data.result === "success") {
                                if (isReply) {
                                    parentItem.replyContent = "";
                                    parentItem.showReply = false;
                                    this.fnRemoveReplyImage(parentItem);
                                } else {
                                    this.newComment = "";
                                    this.fnRemoveCommentImage();
                                }

                                this.fnGetComments();
                            } else {
                                alert("댓글 등록에 실패했습니다.");
                            }
                        },

                        error: (xhr) => {
                            console.error("댓글 등록 오류:", xhr);
                            alert("댓글 등록 중 오류가 발생했습니다.");
                        }
                    });
                },
                fnOpenCommentImage(url) {
                    if (url) {
                        window.open(url, "_blank");
                    }
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
                },
                formatTime(date) {
                    const now = new Date();
                    const target = new Date(date);
                    const diff = Math.floor((now - target) / 1000);
                    if(diff < 60){
                        return "방금 전";
                    }
                    if(diff < 3600){
                        return Math.floor(diff / 60) + "분 전";
                    }
                    if(diff < 86400){
                        return Math.floor(diff / 3600) + "시간 전";
                    }
                    if(diff < 172800){
                        return "어제";
                    }
                    if(diff < 604800){
                        return Math.floor(diff / 86400) + "일 전";
                    }
                    return target.toLocaleDateString('ko-KR');
                },
                fnSelectCommentImage(event) {
                    const file = event.target.files[0];

                    if (!file) {
                        return;
                    }

                    if (!file.type.startsWith("image/")) {
                        alert("이미지 파일만 첨부할 수 있습니다.");
                        event.target.value = "";
                        return;
                    }

                    const maxSize = 10 * 1024 * 1024;

                    if (file.size > maxSize) {
                        alert("이미지는 10MB 이하만 첨부할 수 있습니다.");
                        event.target.value = "";
                        return;
                    }

                    if (this.commentPreview) {
                        URL.revokeObjectURL(this.commentPreview);
                    }

                    this.commentFile = file;
                    this.commentPreview = URL.createObjectURL(file);
                },

                fnRemoveCommentImage() {
                    if (this.commentPreview) {
                        URL.revokeObjectURL(this.commentPreview);
                    }

                    this.commentFile = null;
                    this.commentPreview = "";

                    if (this.$refs.commentFileInput) {
                        this.$refs.commentFileInput.value = "";
                    }
                },
                fnOpenReplyFileInput(item) {
                    const refName = "replyFileInput_" + item.commentNo;
                    const input = this.$refs[refName];

                    // v-for 내부 ref는 배열로 잡히는 경우가 있음
                    if (Array.isArray(input)) {
                        input[0].click();
                    } else if (input) {
                        input.click();
                    }
                },

                fnSelectReplyImage(event, item) {
                    const file = event.target.files[0];

                    if (!file) {
                        return;
                    }

                    if (!file.type.startsWith("image/")) {
                        alert("이미지 파일만 첨부할 수 있습니다.");
                        event.target.value = "";
                        return;
                    }

                    const maxSize = 10 * 1024 * 1024;

                    if (file.size > maxSize) {
                        alert("이미지는 10MB 이하만 첨부할 수 있습니다.");
                        event.target.value = "";
                        return;
                    }

                    if (item.replyPreview) {
                        URL.revokeObjectURL(item.replyPreview);
                    }

                    item.replyFile = file;
                    item.replyPreview = URL.createObjectURL(file);
                },

                fnRemoveReplyImage(item) {
                    if (item.replyPreview) {
                        URL.revokeObjectURL(item.replyPreview);
                    }

                    item.replyFile = null;
                    item.replyPreview = "";

                    const refName = "replyFileInput_" + item.commentNo;
                    const input = this.$refs[refName];

                    if (Array.isArray(input) && input[0]) {
                        input[0].value = "";
                    } else if (input) {
                        input.value = "";
                    }
                },
                
            },
            mounted() { 
                this.fnGetDetail(); 
                document.querySelectorAll('.petal').forEach(el => {
                    el.style.left = Math.random() * 100 + 'vw';
                    el.style.fontSize = (20 + Math.random() * 20) + 'px';
                    el.style.animationDuration = (10 + Math.random() * 10) + 's';
                    el.style.animationDelay = -(Math.random() * 10) + 's';
                });}
        }).mount('#app');
    </script>
</body>

</html>