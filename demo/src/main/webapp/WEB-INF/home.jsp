<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/home-style.css">
</head>
<body>
    <div id="app">
        <jsp:include page="/WEB-INF/common/header.jsp" />
        <div id="wrapper">
            <div class="main-content">
                <div class="left-banner">
                    <div class="main-banner-img">
                        <span class="img-placeholder"></span>
                    </div>
                </div>
                <div class="right-sections">
                    <section class="review-section">
                        <div class="section-title-wrap">
                                <h2>이유있는 선택!</h2>
                        </div>

                        <div class="hash-tag-wrap">
                            <span>#감동</span> <span>#행복</span> <span>#결혼준비</span>
                            <div class="review-tag">
                                <span>리얼후기</span>
                            </div>
                        </div>

                        <p class="section-desc">메리뷰를 선택한 소중한 신랑, 신부님들의 리얼한 후기를 확인하세요.</p>
                        <div class="review-grid">
                            <div class="review-card">
                                <div class="review-img-thumb"></div>
                                <p class="review-title">헤로하우스 스튜디오 촬영 후기</p>
                            </div>
                            <div class="review-card">
                                <div class="review-img-thumb"></div>
                                <p class="review-title">헤로하우스 토탈스튜디오 촬영후기</p>
                            </div>
                            <div class="review-card">
                                <div class="review-img-thumb"></div>
                                <p class="review-title">본식 후기(천안 티웨딩-투게더홀)</p>
                            </div>
                            <div class="review-card">
                                <div class="review-img-thumb"></div>
                                <p class="review-title">구로구 명품웨딩프로포즈 더드림홀 결혼...</p>
                            </div>
                        </div>
                    </section>

                    <section class="community-section">
                        <div class="section-header">
                            <h2>커뮤니티 인기글</h2>
                            <a href="#" class="more-link">더보기 ></a>
                        </div>

                        <div class="post-grid">
                            <div class="post-card">
                                <p class="post-text">이제 막 입사한 신입인데 타지 생활 너...</p>
                                <p class="post-text">무 힘들고 정신병 걸릴 것 같습니다... </p>
                                <p class="post-text">눈치만 보고 있는것도 힘들고 아무도...</p>
                                <div class="post-info">
                                    <span><i class="icon-thumb">👍</i> 10</span>
                                    <span><i class="icon-comment">💬</i> 45</span>
                                    <span class="post-views">조회 3648</span>
                                </div>
                            </div>
                            <div class="post-card">
                                <p class="post-text">지방에서 서울로 상경한 30살...</p>
                                <p class="post-text">기술직 자격증 3개</p>
                                <p class="post-text">경력 잡다하게 분야별로 맛보기 3-4개</p>
                                <div class="post-info">
                                    <span><i class="icon-thumb">👍</i> 5</span>
                                    <span><i class="icon-comment">💬</i> 3</span>
                                    <span class="post-views">조회 3404</span>
                                </div>
                            </div>
                            <div class="post-card">
                                <p class="post-text">취준할 땐 그 자체로 스트레스</p>
                                <p class="post-text">취합하고 난 뒤에는 채용취소 될까봐...</p>
                                <p class="post-text">조마조마</p>
                                <div class="post-info">
                                    <span><i class="icon-thumb">👍</i> 50</span>
                                    <span><i class="icon-comment">💬</i> 27</span>
                                    <span class="post-views">조회 5774</span>
                                </div>
                            </div>
                        </div>
                    </section>
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="/WEB-INF/common/footer.jsp" />
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnList: function () {
                let self = this;
                let param = {};
                $.ajax({
                    url: "http://localhost:8080/",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {

                    }
                });
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
        }
    });

    app.mount('#app');
</script>