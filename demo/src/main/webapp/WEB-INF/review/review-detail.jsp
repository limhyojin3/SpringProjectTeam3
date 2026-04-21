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
        .detail-container { max-width: 800px; margin: 30px auto; padding: 30px; background: #fff; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        .info-card { background: #fff9fa; border: 1px solid #ffccd5; border-radius: 10px; padding: 15px; display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 20px; }
        
        /* 사진 여러 장일 때 스타일 */
        .img-wrapper { display: flex; flex-wrap: wrap; gap: 10px; justify-content: center; margin-bottom: 20px; }
        .review-img { max-width: 100%; height: auto; border-radius: 8px; border: 1px solid #eee; }
        .single-img { max-width: 100%; }
        .multi-img { max-width: calc(50% - 10px); } /* 2장 이상일 때 2열 배치 예시 */

        .review-content { font-size: 1.1rem; line-height: 1.7; white-space: pre-wrap; margin-bottom: 30px; }
    </style>
</head>
<body>
    <div id="app">
        <jsp:include page="/WEB-INF/common/header.jsp" />

        <div class="detail-container" v-if="info">
            <div class="border-bottom pb-3 mb-4">
                <span :class="info.isPaid == 1 ? 'badge badge-danger' : 'badge badge-primary'">{{ info.isPaid == 1 ? '유료' : '무료' }}</span>
                <h2 class="mt-2">{{ info.title }}</h2>
                <small class="text-muted">{{ info.userId }} | {{ info.regDate }} | 조회 {{ info.viewCnt }}</small>
            </div>

            <div class="info-card">
                <div><b>업체:</b> {{ info.comName }}</div>
                <div><b>비용:</b> {{ Number(info.totalCost || 0).toLocaleString() }}원</div>
                <div><b>평점:</b> ⭐ {{ info.rating }}</div>
                <div><b>경로:</b> {{ info.bookingSource }}</div>
            </div>

            <div v-if="imgList.length > 0" class="img-wrapper">
                <img v-for="(src, index) in imgList" 
                     :key="index" 
                     :src="src" 
                     :class="['review-img', imgList.length > 1 ? 'multi-img' : 'single-img']">
            </div>

            <div class="review-content">{{ info.content }}</div>

            <div class="text-center border-top pt-4">
                <button class="btn btn-outline-secondary mr-2" @click="fnBack">목록</button>
                <button :class="info.isLiked > 0 ? 'btn-danger' : 'btn-outline-danger'" class="btn px-4" @click="fnLike">
                    <i class="fas fa-heart mr-1"></i> {{ info.likeCnt }}
                </button>
            </div>
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
                    imgList: [] // 이미지 경로들을 담을 배열
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
                                
                                // ★ 핵심: imgUrl 문자열을 쉼표로 쪼개서 배열로 변환
                                if (this.info.imgUrl) {
                                    // 공백 제거 후 쉼표로 분리
                                    this.imgList = this.info.imgUrl.split(',').filter(url => url.trim() !== '');
                                }
                            }
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
                fnBack() { location.href = "/api/review/list.do"; }
            },
            mounted() { this.fnGetDetail(); }
        }).mount('#app');
    </script>
</body>
</html>