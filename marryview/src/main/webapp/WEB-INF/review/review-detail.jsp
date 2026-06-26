<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>리뷰 상세보기</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/review/review-detail.css">
    <style>
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
    <div id="app">
        <jsp:include page="/WEB-INF/review/view/review-detail-view.jsp" />
    </div>
    <jsp:include page="/WEB-INF/common/footer.jsp" />

    <script>
        const { createApp } = Vue;
        createApp({
            data() {
                return {
                    reviewNo: "${reviewNo}",
                    sessionId: "${sessionId}",
                    sessionRole: "${sessionRole}",
                    info: null,
                    imgList: [],
                    reviewDetail: null, // 이전/다음글 정보를 담을 변수 추가
                    commentList: [],
                    newComment: "",
                    commentFile: null,
                    commentPreview: "",
                    replyTo: null,
                    replyContent: "",
                    replyFile: null,
                    replyPreview: "",
                    // 신고 관련 데이터 수정
                    reportData: {
                        type: '', // REVIEW or COMMENT
                        targetId: '',
                        targetUserId: '',
                        title: '',        // 추가된 신고 제목
                        reason: '',       // 셀렉트박스 선택값
                        customReason: ''  // 실제 상세 내용
                    },
                    reportOptions: [
                        "부적절한 홍보 게시물",
                        "허위 사실 유포",
                        "욕설 및 비하 발언",
                        "개인정보 노출",
                        "기타 부적절한 내용"
                    ],
                    aiSummary: "",       // 요약 데이터 저장용
                    isSummaryOpen: true, // 접기/펴기 상태
                    errorOccurred: false,
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
                        url: "/api/review/detail.dox",
                        type: "POST",
                        data: JSON.stringify({ reviewNo: this.reviewNo, userId: this.sessionId }),
                        contentType: "application/json",
                        success: (res) => {
                            const data = (typeof res === 'string') ? JSON.parse(res) : res;
                            if (data.result === "success") {
                                this.info = data.info;
                                
                                this.reviewDetail = data.info;
                                // --- [수정된 부분: DB에 이미 요약본이 있다면 즉시 적용] ---
                                if (this.info.summary) {
                                   setTimeout(() => {
                                        this.aiSummary = this.info.summary;
                                    }, 2000);
                                } else {
                                    this.fnGetAiSummary(); // 요약본이 없으면 그제야 AI 호출
                                }
                                if (this.info.imgUrl) {
                                    this.imgList = this.info.imgUrl.split(',').filter(url => url.trim() !== '');
                                }
                                this.fnGetComments();
                            }
                        }
                    });
                },
                fnGoDetail(no) {
                    // URL 파라미터를 변경하여 상세 페이지 재접속
                    location.href = "/api/review/detail.do?reviewNo=" + no;
                },
                fnGetComments() {
                    $.ajax({
                        url: "/api/comment/review-list.dox",
                        type: "POST",
                        data: JSON.stringify({ reviewNo: this.reviewNo, userId: this.sessionId }),
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
                fnGetAiSummary() {
                    console.log("fnGetAiSummary 함수 호출됨!"); // 이게 F12 콘솔에 뜨나요?
                    // 이미 내용이 들어와 있다면 중복 호출 방지
                    if (this.aiSummary) return; 
                    // 여기서 info가 null이면 아예 함수 종료
                    if (!this.info || !this.info.content){
                        console.log("info나 content가 없어서 종료됨:", this.info);
                        return;
                    }
                    $.ajax({
                        url: "/api/review/summary.dox",
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify({
                            reviewNo: this.reviewNo, // JSP 변수 대신 data 속성 활용
                            content: this.info.content
                        }),
                        success: (res)=> {
                            // res가 문자열이라면 객체로 파싱하고, 이미 객체라면 그대로 사용
                            const data = (typeof res === 'string') ? JSON.parse(res) : res;
                            
                            if (data.result === "success") {
                                // 이제 summary 부분만 추출해서 담습니다.
                                this.aiSummary = data.summary; 
                            } else {
                                this.aiSummary = "요약 정보를 불러올 수 없습니다.";
                            }
                        },
                        error: (e) => {
                            console.error("AI 요약 실패:", e);
                            // 에러 시 사용자에게 알려줄 메시지
                            this.aiSummary = "요약 정보를 불러오지 못했습니다.";
                            this.errorOccurred = true;  // ← 추가
                        }
                    });
                },
                // --- 신고 로직 시작 ---
                // 셀렉트박스 변경 시 상세내용 텍스트 처리
                fnHandleReasonChange() {
                    if (this.reportData.reason === "직접 입력") {
                        this.reportData.customReason = ""; // 직접 입력 시 비워줌
                    } else {
                        this.reportData.customReason = this.reportData.reason; // 고정 텍스트 입력
                    }
                },
                openReportModal(type, targetId, targetUserId) {
                    if (!this.sessionId || this.sessionId === 'null') return alert("로그인 후 이용 가능합니다.");
                    // 데이터 초기화
                    this.reportData.type = type;
                    this.reportData.targetId = targetId;
                    this.reportData.targetUserId = targetUserId;
                    this.reportData.title = ""; 
                    this.reportData.reason = "";
                    this.reportData.customReason = "";
                    $('#reportModal').modal('show');
                },
                fnSubmitReport() {
                    // 유효성 검사
                    if (!this.reportData.title.trim()) return alert("신고 제목을 입력해 주세요.");
                    if (!this.reportData.customReason.trim()) return alert("신고 상세 내용을 입력하거나 선택해 주세요.");

                    // 중복 신고 체크 (생략 가능하나 기존 로직 유지)
                    $.ajax({
                        url: "/api/report/check-duplicate.dox", 
                        type: "POST",
                        data: JSON.stringify({
                            reporterId: this.sessionId,
                            targetType: this.reportData.type,
                            targetId: this.reportData.targetId
                        }),
                        contentType: "application/json",
                        success: (res) => {
                            const data = (typeof res === 'string') ? JSON.parse(res) : res;
                            if (data.isDuplicate) {
                                alert("이미 신고하신 게시물/댓글입니다.");
                                $('#reportModal').modal('hide');
                            } else {
                                this.fnSendReport(this.reportData.customReason);
                            }
                        },
                        error: () => {
                            this.fnSendReport(this.reportData.customReason);
                        }
                    });
                },
                fnSendReport(reason) {
                    $.ajax({
                        url: "/api/report/add.dox",
                        type: "POST",
                        data: JSON.stringify({
                            reporterId: this.sessionId,
                            targetType: this.reportData.type,
                            targetId: this.reportData.targetId,
                            targetUserId: this.reportData.targetUserId,
                            reportTitle: this.reportData.title, // 입력받은 제목 전송
                            reportContent: reason
                        }),
                        contentType: "application/json",
                        success: (res) => {
                            const data = (typeof res === 'string') ? JSON.parse(res) : res;
                            if(data.result === "success") {
                                alert("신고가 정상적으로 접수되었습니다.");
                            } else {
                                alert(data.message || "이미 신고 처리되었거나 오류가 발생했습니다.");
                            }
                            $('#reportModal').modal('hide');
                        }
                    });
                },
                // --- 신고 로직 끝 ---
                fnCommentLike(item) {
                    if (!this.sessionId || this.sessionId === 'null') return alert("로그인이 필요합니다.");
                    $.ajax({
                        url: "/api/comment/like.dox",
                        type: "POST",
                        data: JSON.stringify({ commentNo: item.commentNo, userId: this.sessionId }),
                        contentType: "application/json",
                        success: () => { this.fnGetComments(); }
                    });
                },
                fnAddComment() {
                    if (!this.newComment.trim()) {
                        return alert("내용을 입력해주세요.");
                    }
                    if (!this.sessionId || this.sessionId === "null") {
                        return alert("로그인이 필요합니다.");
                    }
                    const formData = new FormData();
                    formData.append("reviewNo", this.reviewNo);
                    formData.append("userId", this.sessionId);
                    formData.append("content", this.newComment);
                    if (this.commentFile) {
                        formData.append("files", this.commentFile);
                    }
                    $.ajax({
                        url: "/api/comment/review-add.dox",
                        type: "POST",
                        data: formData,
                        // FormData 전송 시 반드시 필요
                        processData: false,
                        contentType: false,
                        success: (res) => {
                            const data =
                                typeof res === "string" ? JSON.parse(res) : res;

                            if (data.result === "success") {
                                this.newComment = "";
                                this.fnRemoveCommentImage();
                                this.fnGetComments();
                            } else {
                                alert("댓글 등록에 실패했습니다.");
                            }
                        },
                        error: (xhr) => {
                            console.error(xhr);
                            alert("댓글 등록 중 오류가 발생했습니다.");
                        }
                    });
                },
                fnEditMode(item) { item.isEdit = true; item.oldContent = item.content; },
                fnCancelEdit(item) { item.isEdit = false; item.content = item.oldContent; },
                fnUpdateComment(item) {
                    if(!item.content.trim()) return alert("내용을 입력하세요.");
                    $.ajax({
                        url: "/api/comment/update.dox",
                        type: "POST",
                        data: JSON.stringify({ commentNo: item.commentNo, content: item.content, userId: this.sessionId }),
                        contentType: "application/json",
                        success: () => { item.isEdit = false; alert("수정되었습니다."); }
                    });
                },
                fnDeleteComment(commentNo) {
                    if(!confirm("삭제하시겠습니까?")) return;
                    $.ajax({
                        url: "/api/comment/remove.dox",
                        type: "POST",
                        // ✅ sessionRole을 추가해서 보냅니다.
                        data: JSON.stringify({ 
                            commentNo: commentNo, 
                            userId: this.sessionId,
                            sessionRole: this.sessionRole 
                        }),
                        contentType: "application/json",
                        success: () => { 
                            alert("삭제되었습니다."); 
                            this.fnGetComments(); 
                        }
                    });
                },
                fnLike() {
                    if (!this.sessionId || this.sessionId === 'null') return alert("로그인이 필요합니다.");
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
                            }else if (data.result === "fail") {  // ✅ 추가
                                alert(data.message);
                            }
                        }
                    });
                },
                fnBack() { location.href = "/api/review/list.do"; },
                fnShowReply(commentNo) {
                    this.replyTo = (this.replyTo === commentNo) ? null : commentNo;
                    this.replyContent = ""; 
                },
                fnSaveReply(parentNo) {
                    if (!this.sessionId || this.sessionId === "null") {
                        return alert("로그인이 필요합니다.");
                    }
                    if (!this.replyContent.trim()) {
                        return alert("답글 내용을 입력해주세요.");
                    }
                    const formData = new FormData();
                    formData.append("reviewNo", this.reviewNo);
                    formData.append("userId", this.sessionId);
                    formData.append("content", this.replyContent);
                    formData.append("parentNo", parentNo);
                    if (this.replyFile) {
                        formData.append("files", this.replyFile);
                    }
                    $.ajax({
                        url: "/api/comment/review-add.dox",
                        type: "POST",
                        data: formData,
                        processData: false,
                        contentType: false,
                        success: (res) => {
                            const data =
                                typeof res === "string" ? JSON.parse(res) : res;
                            if (data.result === "success") {
                                this.replyTo = null;
                                this.replyContent = "";
                                this.fnRemoveReplyImage();
                                this.fnGetComments();
                            } else {
                                alert("답글 등록에 실패했습니다.");
                            }
                        },
                        error: (xhr) => {
                            console.error(xhr);
                            alert("답글 등록 중 오류가 발생했습니다.");
                        }
                    });
                },
                fnSelectReplyImage(event) {
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
                    this.replyFile = file;
                    if (this.replyPreview) {
                        URL.revokeObjectURL(this.replyPreview);
                    }
                    this.replyPreview = URL.createObjectURL(file);
                },
                fnRemoveReplyImage() {
                    if (this.replyPreview) {
                        URL.revokeObjectURL(this.replyPreview);
                    }
                    this.replyFile = null;
                    this.replyPreview = "";
                    if (this.$refs.replyFileInput) {
                        this.$refs.replyFileInput.value = "";
                    }
                },
                fnOpenImage(url) {
                    if (url) {
                        window.open(url, '_blank');
                    }
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
                    this.commentFile = file;
                    if (this.commentPreview) {
                        URL.revokeObjectURL(this.commentPreview);
                    }
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
            },
            mounted() { 
                this.fnGetDetail(); 
            }
        }).mount('#app');
    </script>
</body>
</html>