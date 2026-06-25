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
    
    <style>
        .detail-container { 
            max-width: 900px; /* 가독성을 위해 너비를 살짝 넓힘 */
            margin: 30px auto; 
            padding: 40px; /* 내부 여백 확대 */
            background: #fff; 
            border-radius: 20px; /* 더 부드러운 곡선 */
            box-shadow: 0 10px 30px rgba(0,0,0,0.05); 
        }        
        .info-card { background: #fff9fa; border: 1px solid #ffccd5; border-radius: 10px; padding: 15px; display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 20px; color: #555; }
        .img-wrapper { 
            display: flex; 
            flex-direction: column; /* 가로가 아닌 세로 방향 정렬 */
            align-items: center; 
            gap: 20px; 
            margin: 30px 0; 
        }        
        .review-img { 
            width: 100%; /* 박스 너비에 꽉 채움 */
            max-width: 100%; 
            height: auto; 
            border-radius: 12px; 
            border: 1px solid #f1f1f1; 
            transition: transform 0.3s ease; 
        }
        .review-img:hover { 
            transform: translateY(-5px); 
            box-shadow: 0 10px 20px rgba(0,0,0,0.1); 
        }
        .multi-img { max-width: calc(50% - 10px); }
        /* 본문 텍스트 간격 조정 */
        .review-content { 
            font-size: 1.1rem; 
            line-height: 1.8; 
            white-space: pre-wrap; 
            margin: 30px 0; 
            padding: 0 10px; /* 텍스트가 양 끝에 붙지 않게 여백 */
            color: #333; 
            word-break: break-word; /* 긴 단어 자동 줄바꿈 */
        }

        /* 2. v-html 내부 이미지(Quill 생성) 최적화 */
        .review-content :deep(img) {
            display: block;
            max-width: 100% !important; /* 부모 너비를 절대 넘지 않음 */
            height: auto !important;    /* 비율 유지 */
            margin: 30px auto;          /* 위아래 간격 및 중앙 정렬 */
            border-radius: 12px;        /* 부드러운 모서리 처리 */
            transition: transform 0.3s ease;
        }
        /* 에디터 내부 이미지 스타일 강제 적용 */
        .review-content img {
           max-width: 100%;    /* 본문 너비를 넘지 않음 */
    height: auto;       /* 비율 유지 */
    object-fit: contain; /* 잘리지 않고 전체가 다 보이게 함 */
        }

        /* 3. 가로가 너무 긴 사진(1920x500 등)을 위한 특수 효과 */
        /* 마우스를 올리면 원본을 더 잘 볼 수 있게 살짝 확대 */
        .review-content :deep(img:hover) {
            transform: scale(1.01);
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            cursor: zoom-in; /* 클릭하면 커질 것 같은 느낌 제공 */
        }

        /* 4. 에디터 내부 공백(p 태그) 정렬 */
        .review-content :deep(p) {
            margin-bottom: 1.5rem;
        }

        /* 5. 비디오나 iframe이 있을 경우를 대비 */
        .review-content :deep(iframe) {
            max-width: 100%;
            width: 100%;
            aspect-ratio: 16 / 9;
            border-radius: 12px;
        }
        
        .comment-section { margin-top: 50px; border-top: 2px solid #fff0f3; padding-top: 30px; }
        .comment-count { color: #f4a096; font-weight: bold; }
        .comment-item { padding: 20px 10px; border-bottom: 1px solid #fff0f3; transition: 0.2s; }
        .comment-item:hover { background-color: #fffafb; }
        .comment-user { font-weight: 600; color: #444; }
        .comment-date { font-size: 0.8rem; color: #bbb; margin-left: 10px; }
        .comment-content { margin-top: 10px; font-size: 0.95rem; color: #555; line-height: 1.5; }
        
        .reply-item { margin-left: 40px; background-color: #fcfcfc; border-left: 3px solid #ffccd5; }
        .reply-mark { color: #f4a096; font-weight: bold; margin-right: 5px; }
        
        .comment-input-box { background: #fff9fa; border: 1px solid #ffccd5; padding: 20px; border-radius: 15px; margin-top: 30px; }
        .comment-input-box textarea { border: 1px solid #ffccd5; border-radius: 10px; resize: none; }
        .btn-comment {
            background-color: #f4a096;
            border: none;
            border-radius: 30px;
            font-weight: 700;
            color: #fff;
            padding: 8px 24px;
            transition: all 0.2s;
            box-shadow: 1px 1px 2px #ffb3c1;
        }
        .btn-comment:hover {
            background-color: #e0354f;
            color: #fff;
        }
        
        .comment-action-btns { font-size: 0.75rem; color: #aaa; }
        .comment-action-btns span { cursor: pointer; margin-left: 10px; }
        .comment-action-btns span:hover { color: #f4a096; text-decoration: underline; }
        
        .comment-like-btn { display: inline-flex; align-items: center; gap: 8px !important; cursor: pointer; margin-left: 15px; }
        .like-active { color: #f4a096  !important; font-weight: bold; }

        /* 신고 모달 스타일 */
        .modal-header { background-color: #ff4d6d; color: white; }
        .btn-report-submit { background-color: #ff4d6d; color: white; border: none; }
        .btn-report-submit:hover { background-color: #ff3355; color: white; }

        .info-card { 
            background: #fff9fa; 
            border: 1px solid #ffccd5; 
            border-radius: 15px; 
            padding: 25px; 
            display: grid; 
            grid-template-columns: 1fr 1fr; /* 2열 유지 */
            gap: 15px 30px; /* 행과 열 간격 분리 */
            margin-bottom: 40px; 
            color: #555; 
            position: relative;
        }
        /* 전체 컨테이너 */
        .post-navigation {
            margin: 40px 0;
            border: 1px solid #e1e1e1;
            border-radius: 12px;
            overflow: hidden;
            background-color: #fff;
            list-style: none;
            padding: 0;
        }

        /* 각 행 스타일 */
        .post-navigation li {
            display: flex;
            align-items: center;
            padding: 20px 25px;
            cursor: pointer;
            transition: all 0.3s ease; /* 부드러운 전환 효과 */
            position: relative;
        }

        /* 구분선 */
        .post-navigation li:first-child {
            border-bottom: 1px solid #f0f0f0;
        }

        /* 마우스를 올렸을 때(Hover) 배경색과 텍스트 이동 효과 */
        .post-navigation li:hover {
            background-color: #fff5f7;
        }

        .post-navigation li:hover .nav-title {
            color: #f4a096;
            transform: translateX(5px);
        }

        /* 라벨 디자인 (이전글/다음글 뱃지) */
        .nav-label {
            font-size: 0.85rem;
            font-weight: 700;
            color: #999;
            width: 70px;
            text-transform: uppercase;
        }

        /* 제목 텍스트 */
        .nav-title {
            flex: 1;
            font-size: 1rem;
            color: #444;
            font-weight: 500;
            transition: all 0.3s ease;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            margin: 0 15px;
        }

        /* 화살표 아이콘 커스텀 */
        .nav-arrow {
            font-size: 1.2rem;
            color: #ccc;
            transition: color 0.3s;
        }

        .post-navigation li:hover .nav-arrow {
            color: #f4a096;
        }

        /* 글이 없을 때 스타일 */
        .nav-none {
            background-color: #fafafa !important;
            cursor: default !important;
        }

        .nav-none .nav-title {
            color: #bbb !important;
            transform: none !important;
        }

        /* 관리자 전용 섹션 스타일 */
        .admin-only-box {
            background-color: #f8faff; /* 연한 파란색 배경으로 일반 영역과 차별화 */
            border: 2px dashed #4d7cff; /* 대시 테두리로 '관리용' 느낌 강조 */
            border-radius: 20px;
            padding: 25px;
            margin: 30px 0;
            position: relative;
        }

        .admin-badge {
            position: absolute;
            top: -12px;
            left: 20px;
            background: #4d7cff;
            color: white;
            padding: 4px 12px;
            border-radius: 50px;
            font-size: 12px;
            font-weight: bold;
        }

        .admin-info-item {
            display: flex;
            justify-content: space-between;
            border-bottom: 1px solid #e1e8f5;
            padding: 10px 0;
        }

        .admin-receipt-title {
            font-size: 16px;
            font-weight: 700;
            color: #333;
            margin-bottom: 15px;
        }
        /* 전체 카드 컨테이너 */
        .info-card-container {
            background-color: #fff;
            margin-bottom: 30px;
            border: 1.5px solid #ffd6e0 !important;
            border-radius: 20px;
        }

        /* 왼쪽 정보 아이템 간격 줄이기 */
        .info-item {
            font-size: 0.95rem;
            color: #333;
            display: flex;
            align-items: center;
        }

        /* 상세 평가 박스 내부 스타일 */
        .evaluation-card {
            flex: 1;
            border: 1px solid #dee2e6 !important;
            font-size: 0.85rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        .eval-label {
            color: #666;
        }

        .eval-val {
            color: #333;
        }

        .evaluation-box-wrapper {
            flex: 0 0 300px;
            max-width: 300px;
            display: flex;
            flex-direction: column;
        }


        /* 반응형 처리: 화면이 작아지면 위아래로 배치 */
        @media (max-width: 768px) {
            .info-card-container { flex-direction: column; }
            .evaluation-box-wrapper {
                width: 100%;
                max-width: 100%;
                flex: 0 0 100%;
                margin-top: 20px;
            }
        }
        .nickname-link {
            text-decoration: none; /* 밑줄 제거 */
            color: inherit;       /* 기존 글자색 유지 */
            cursor: pointer;
        }

        .nickname-link:hover {
            text-decoration: underline; /* 호버 시 밑줄 효과 */
            color: #555;                /* 살짝 다른 색상으로 강조 */
        }

        /* 목록으로 버튼 */
        .btn-list {
            background: #fff;
            border: 1.5px solid #ffd6e0;
            border-radius: 30px;
            color: #f4a096;
            font-weight: 600;
            padding: 8px 24px;
            transition: all 0.2s;
        }
        .btn-list:hover {
            background: #fff0f3;
            border-color: #f4a096;
            color: #f4a096;
        }

        /* 좋아요 버튼 */
        .btn-like {
            background-color: #f4a096;
            border: none;
            border-radius: 30px;
            color: #fff;
            font-weight: 700;
            padding: 8px 32px;
            transition: all 0.2s;
            box-shadow: 1px 1px 2px #ffb3c1;
        }
        .btn-like:hover { background-color: #e0354f; color: #fff; }

        /* 좋아요 취소 상태 */
        .btn-like-cancel {
            background: #fff;
            border: 1.5px solid #f4a096;
            border-radius: 30px;
            color: #f4a096;
            font-weight: 700;
            padding: 8px 32px;
            transition: all 0.2s;
        }
        .btn-like-cancel:hover { background: #fff0f3; }

        /* 제목 */
        .review-title { font-weight: 700; color: #444; }

        /* 작성자/날짜, 조회수/좋아요 구분자 */
        .review-meta-divider { color: #ffd6e0; margin: 0 6px; }

        /* 정보 카드 컨테이너 배경 */
        .info-card-container { background-color: #fff; }

        /* AI 요약 박스 */
        .ai-summary-box {
            background-color: #fff5f7;
            border: 1.5px solid #ffd6e0 !important;
            border-radius: 12px;
        }
        .info-left-section { 
            flex: 1; 
            min-width: 0;  /* 추가 - 텍스트 overflow 방지 */
        }

        /* AI 요약 제목 색상 */
        .ai-summary-title { color: #f4a096; }

        /* AI 요약 본문 */
        .ai-summary-content { line-height: 1.6; white-space: pre-line; }

        /* 서비스 상세 평가 라벨 */
        .evaluation-header-label { font-size: 0.9rem; color: #495057; }

        /* 섹션 헤더 아이콘 핑크로 */
        .evaluation-header .fa-check-circle { color: #f4a096; }

        /* 평가 카드 배경 */
        .evaluation-card-bg { background-color: #fcfcfc; }

        /* 관리자 삭제/삭제된 댓글 텍스트 크기 */
        .comment-del-text { font-size: 0.9em; }

        /* 글 없을 때 nav-arrow 색상 */
        .nav-arrow-none { color: #eee; }

        /* 좋아요 버튼 탈퇴회원 비활성화 */
        .btn-disabled { cursor: default; opacity: 0.5; }

        /* 업체 정보 박스 */
        .info-left-box {
            background-color: #fcfcfc;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 12px 16px;
            font-size: 0.85rem;
        } 

        /* 섹션 헤더 통일 */
        .section-header-label {
            font-size: 0.9rem;
            color: #495057;
            font-weight: 700;
        }

        .info-left-box .info-item b {
            color: #333;
            font-weight: 600;
        }

        .info-left-box .info-item i {
            font-size: 0.85rem;
            width: 16px;
        }

        .info-left-box .info-item {
            font-size: 0.85rem;
            color: #666;
        }

        .info-top-row {
            gap: 12px;
            align-items: stretch; /* 추가 - 양쪽 높이 동일하게 */
        }

        /* 유료/무료 뱃지 - 핑크 계열로 통일 */
        .badge-paid-detail {
            background: #fff0f3;
            color: #f4a096;
            border: 1.5px solid #ffd6e0;
            padding: 5px 12px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 0.8rem;
        }
        .badge-free-detail {
            background: #e7f5ff;
            color: #4fc3f7;
            border: 1.5px solid #a5d8ff;
            padding: 5px 12px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 0.8rem;
        }

        .icon-pink { color: #f4a096; }

        .btn-cancel {
            background: #fff;
            border: 1.5px solid #ffd6e0;
            border-radius: 20px;
            color: #f4a096;
            font-weight: 600;
            padding: 4px 16px;
            transition: all 0.2s;
        }
        .btn-cancel:hover {
            background: #fff0f3;
            border-color: #f4a096;
        }

        .btn-summary-toggle {
            color: #f4a096;
            font-weight: 600;
            font-size: 0.85rem;
            background: none;
            border: none;
            padding: 0;
        }

        .btn-summary-toggle:hover {
            color: #e0354f;
        }

        .comment-heart { color: #ffd6e0; }
        .comment-heart.liked { color: #f4a096; }
        .comment-like-btn small {color: #ffd6e0;}
        .comment-like-btn small.like-active {color: #f4a096;}
        .review-meta-right { gap: 10px; }

        /* 닉네임 영역 */
        .nickname-container{
            position:relative;
            display:inline-block;
        }

        /* 프로필 카드 */
        .profile-hover-modal{
            position:absolute;
            left:50%;
            bottom:calc(100% + 12px);

            transform:translateX(-50%);
            

            width:230px;
            padding:18px;

            background:rgba(255,255,255,.95);
            backdrop-filter:blur(15px);

            border:1px solid rgba(255,255,255,.8);
            border-radius:22px;

            box-shadow:
                0 20px 50px rgba(255,92,138,.18),
                0 5px 15px rgba(0,0,0,.06);

            z-index:99999;

            animation:profilePopup .28s cubic-bezier(.22,1,.36,1);

            pointer-events:none;
        }

        /* 꼬리 */
        .profile-hover-modal::after{
            content:"";
            position:absolute;
            left:0px;
            bottom:-8px;

            width:16px;
            height:16px;

            background:white;

            transform:
                translateX(-50%)
                rotate(45deg);

            border-right:1px solid rgba(255,255,255,.8);
            border-bottom:1px solid rgba(255,255,255,.8);
        }

        .profile-hover-modal img{
            width:64px;
            height:64px;
            border-radius:50%;
            object-fit:cover;
            display:block;
            margin:0 auto 10px;

            border:3px solid #ffe4ec;
        }

        @keyframes profilePopup{
            0%{
                opacity:0;
                transform:
                    translateX(-50%)
                    translateY(12px)
                    scale(.92);
            }

            100%{
                opacity:1;
                transform:
                    translateX(-50%)
                    translateY(0)
                    scale(1);
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
    <div id="app">
        

        <div class="detail-container" v-if="info">
            <div class="border-bottom pb-3 mb-4">
                <div class="d-flex justify-content-between align-items-start">
                    <span :class="info.isPaid == 1 ? 'badge-paid-detail' : 'badge-free-detail'">
                        {{ info.isPaid == 1 ? '유료리뷰' : '무료리뷰' }}
                    </span>
                    
                    <div v-if="info.userId !== sessionId && info.nickname !== '탈퇴회원'">
                        <button class="btn btn-sm btn-outline-secondary border-0" @click="openReportModal('REVIEW', reviewNo, info.userId)">
                            <i class="fas fa-bullhorn icon-pink mr-1"></i> <span class="small text-muted">신고</span>
                        </button>
                    </div>
                </div>
                <h2 class="mt-3 review-title">{{ info.title }}</h2>
                <div class="d-flex justify-content-between align-items-center flex-wrap">
                    <small class="text-muted">
                        작성자:
                        <a v-if="info.nickname !== '탈퇴회원'"
                            :href="'/userProfile.do?userId=' + info.userId" class="text-decoration-none text-dark">
                            <b :class="{'text-danger': info.nickname === '탈퇴회원'}">{{ info.nickname }}</b>
                        </a>
                        <b v-else class="text-danger">{{ info.nickname }}</b>
                        <span class="review-meta-divider">|</span> {{ info.regDate }}
                    </small>
                    <small class="text-muted">
                        <small class="text-muted d-flex align-items-center review-meta-right">
                            <span><i class="far fa-eye"></i> {{ info.viewCnt }}</span>
                            <span><i class="far fa-heart icon-pink"></i> {{ info.likeCnt }}</span>
                        </small>
                    </small>
                </div>
            </div>

            <div class="info-card-container p-4">
                <div class="d-flex justify-content-between mb-3 info-top-row">

                    <!-- 업체 정보 -->
                    <div class="info-left-section">
                        <div class="evaluation-header mb-2">
                            <i class="fas fa-check-circle text-secondary"></i>
                            <span class="ml-1 section-header-label">업체 정보</span>
                        </div>
                        <div class="info-left-box">
                            <div class="row no-gutters">
                                <div class="col-6 mb-2">
                                    <span class="eval-label"><i class="fas fa-store mr-1 icon-pink"></i> 업체 :</span>
                                    <span class="eval-val font-weight-bold ml-1">{{info.comName || info.externalName}}</span>
                                </div>
                                <div class="col-6 mb-2" v-if="info.productName">
                                    <span class="eval-label"><i class="fas fa-box-open mr-1 icon-pink"></i> 이용 상품 :</span>
                                    <span class="text-primary font-weight-bold ml-1">{{ info.productName }}</span>
                                </div>
                                <div class="col-6 mb-2">
                                    <span class="eval-label"><i class="fas fa-won-sign mr-1 icon-pink"></i> 비용 :</span>
                                    <span class="eval-val font-weight-bold ml-1">{{ Number(info.totalCost || 0).toLocaleString() }}원</span>
                                </div>
                                <div class="col-6 mb-2">
                                    <span class="eval-label"><i class="fas fa-star mr-1 text-warning"></i> 작성자 평점 :</span>
                                    <span class="eval-val font-weight-bold ml-1">{{ info.rating }} / 5</span>
                                </div>
                                <div class="col-6" v-if="info.avgCompanyRating > 0">
                                    <span class="eval-label"><i class="fas fa-star mr-1 text-primary"></i> 업체 평균 평점 :</span>
                                    <span class="font-weight-bold text-primary ml-1">{{ parseFloat(info.avgCompanyRating).toFixed(1) }} / 5</span>
                                </div>
                                <div class="col-6">
                                    <span class="eval-label"><i class="fas fa-link mr-1 icon-pink"></i> 경로 :</span>
                                    <span class="eval-val font-weight-bold ml-1">{{ info.bookingSource }}</span>
                                </div>
                            </div>
                        </div>
                    </div> 

                    <!-- 서비스 상세 평가 -->
                    <div class="evaluation-box-wrapper">
                        <div class="evaluation-header mb-2">
                            <i class="fas fa-check-circle text-secondary"></i>
                            <span class="ml-1 section-header-label">서비스 상세 평가</span>
                        </div>
                        <div class="evaluation-card p-3 border rounded evaluation-card-bg">
                            <div class="row no-gutters">
                                <div class="col-6 mb-2">
                                    <span class="eval-label"><i class="fas fa-tshirt mr-1"></i> 상품 상태 :</span>
                                    <span class="eval-val font-weight-bold ml-1">{{ info.dressCondition }}</span>
                                </div>
                                <div class="col-6 mb-2">
                                    <span class="eval-label"><i class="fas fa-user-tie mr-1"></i> 전문성 :</span>
                                    <span class="eval-val font-weight-bold ml-1">{{ info.professionalism }}</span>
                                </div>
                                <div class="col-6">
                                    <span class="eval-label"><i class="fas fa-hourglass-half mr-1"></i> 대기 시간 :</span>
                                    <span class="eval-val font-weight-bold ml-1" :class="info.waitingTimeStatus === 'Y' ? 'text-danger' : ''">
                                        {{ info.waitingTimeStatus === 'Y' ? info.waitingDuration : '없음' }}
                                    </span>
                                </div>
                                <div class="col-6">
                                    <span class="eval-label"><i class="fas fa-money-bill-wave mr-1"></i> 추가금 강요 :</span>
                                    <span class="eval-val font-weight-bold ml-1" :class="info.extraChargeForce === 'Y' ? 'text-danger' : ''">
                                        {{ info.extraChargeForce === 'Y' ? '있음' : '없음' }}
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

                <!-- 하단: AI 요약 전체 너비 -->
                <div id="ai-summary-box" class="p-4 border rounded shadow-sm ai-summary-box" v-if="aiSummary">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <div class="font-weight-bold ai-summary-title">
                            <i class="fas fa-magic mr-1"></i> ✨ AI 요약
                        </div>
                        <button class="btn-summary-toggle" @click="isSummaryOpen = !isSummaryOpen">
                            {{ isSummaryOpen ? '접기 ▲' : '펼치기 ▼' }}
                        </button>
                    </div>
                    <div v-show="isSummaryOpen" class="mt-2 text-muted ai-summary-content">
                        {{ aiSummary }}
                    </div>
                </div>
                <div id="ai-loading-box" class="p-4 border rounded shadow-sm text-center ai-summary-box" v-else-if="!aiSummary && !errorOccurred">
                    <div class="spinner-border spinner-border-sm text-primary mr-2" role="status"></div>
                    <span>AI가 리뷰를 요약하고 있습니다...</span>
                </div>

            </div>
            

            <!-- 관리자 전용 정보 박스 (영수증 및 관리 데이터) -->
            <div v-if="sessionRole === 'ADMIN'" class="admin-only-box">
                <span class="admin-badge"><i class="fas fa-user-shield"></i> 관리자 전용 확인란</span>
                
                <div class="row">
                    <!-- 왼쪽: 영수증 이미지 -->
                    <div class="col-md-6 border-right">
                        <h6 class="admin-receipt-title"><i class="fas fa-receipt mr-2"></i>첨부 영수증 내역</h6>
                        <div v-if="imgList.length > 0" class="img-wrapper text-center">
                            <img v-for="(src, index) in imgList" 
                                :key="index" 
                                :src="src" 
                                class="review-img single-img shadow-sm mb-2" 
                                style="max-height: 300px; width: auto; cursor: pointer;"
                                @click="fnOpenImage(src)">
                            <p class="small text-muted mt-2">이미지를 클릭하면 크게 볼 수 있습니다.</p>
                        </div>
                        <div v-else class="text-center py-4 text-muted">
                            첨부된 영수증 이미지가 없습니다.
                        </div>
                    </div>

                    <!-- 오른쪽: 관리용 세부 정보 -->
                    <div class="col-md-6">
                        <h6 class="admin-receipt-title"><i class="fas fa-database mr-2"></i>시스템 관리 정보</h6>
                        <div class="admin-info-item">
                            <span class="text-muted small">작성자 고유 ID</span>
                            <span class="font-weight-bold">{{ info.userId }}</span>
                        </div>
                        <div class="admin-info-item">
                            <span class="text-muted small">리뷰 번호</span>
                            <span># {{ reviewNo }}</span>
                        </div>
                        
                        <!-- 추가적으로 관리자가 알아야 할 DB 정보가 있다면 여기에 배치 -->
                    </div>
                </div>
            </div>

            <div class="review-content" v-html="info.content"></div>

            <div class="text-center">
                <button class="btn btn-list mr-2 px-4" @click="fnBack">
                    <i class="fas fa-list mr-1"></i>목록으로
                </button>
        
                <button :class="info.isLiked > 0 ? 'btn-like-cancel' : 'btn-like'"
                        class="btn px-5 shadow-sm"
                        @click="info.nickname !== '탈퇴회원' ? fnLike() : null"
                        :style="info.nickname === '탈퇴회원' ? 'cursor: default; opacity: 0.5;' : ''">
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
                                <span class="comment-user">
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
                                </span>
                                <span class="comment-date">{{ item.regDate }}</span>
                                
                                <span v-if="item.isDeleted == 0 && item.nickname !== '탈퇴회원' && info.nickname !== '탈퇴회원'" 
                                    class="comment-like-btn ml-3" @click="fnCommentLike(item)">
                                    <i :class="item.isLiked > 0 ? 'fas fa-heart icon-pink' : 'far fa-heart comment-heart'"></i>
                                    <small :class="{'like-active': item.isLiked > 0}">{{ item.likeCnt }}</small>
                                </span>
                            </div>

                            <div v-if="item.isDeleted == 0" class="comment-action-btns">
                                <template v-if="item.nickname !== '탈퇴회원' && info.nickname !== '탈퇴회원'">
                                    <span v-if="!item.parentNo" @click="fnShowReply(item.commentNo)">
                                        <i class="far fa-comment-dots"></i> {{ replyTo === item.commentNo ? '취소' : '답글' }}
                                    </span>

                                    <span v-if="item.userId !== sessionId && sessionRole !== 'ADMIN'" 
                                        @click="openReportModal('COMMENT', item.commentNo, item.userId)" 
                                        class="report-link icon-pink">
                                        <i class="fas fa-exclamation-triangle"></i> 신고
                                    </span>
                                </template>

                                <span v-if="item.userId === sessionId && !item.isEdit" @click="fnEditMode(item)">
                                    <i class="far fa-edit"></i> 수정
                                </span>
                                <span v-if="(item.userId === sessionId || sessionRole === 'ADMIN') && !item.isEdit" 
                                    @click="fnDeleteComment(item.commentNo)">
                                    <i class="far fa-trash-alt"></i> 삭제
                                </span>
                            </div>
                        </div>

                        <div v-if="item.isDeleted == 0">
                            <div v-if="!item.isEdit" class="comment-content">
                                <template v-if="item.nickname === '탈퇴회원'">
                                    <span class="text-muted font-italic">탈퇴한 사용자의 댓글입니다.</span>
                                </template>
                                <template v-else>
                                    {{ item.content }}
                                </template>
                            </div>
                            
                            <div v-else class="mt-2">
                                <textarea class="form-control edit-textarea" v-model="item.content" rows="2"></textarea>
                                <div class="text-right mt-2">
                                    <button class="btn btn-sm btn-cancel mr-1" @click="fnCancelEdit(item)">취소</button>
                                    <button class="btn btn-sm btn-comment" @click="fnUpdateComment(item)">수정완료</button>
                                </div>
                            </div>
                        </div>

                        <div v-else class="comment-content mt-2">
                            <template v-if="item.delRole === 'ADMIN'">
                                <span class="text-danger font-italic">
                                    <i class="fas fa-ban"></i> 관리자에 의해 삭제된 댓글입니다.
                                </span>
                            </template>
                            <template v-else>
                                <span class="text-muted">삭제된 댓글입니다.</span>
                            </template>
                        </div>

                        <div v-if="item.isDeleted == 0 && replyTo === item.commentNo && item.nickname !== '탈퇴회원' && info.nickname !== '탈퇴회원'" 
                            class="mt-3 p-3 bg-white border rounded shadow-sm">
                            <textarea class="form-control" v-model="replyContent" rows="2" :placeholder="item.userId + '님께 답글 남기기...'"></textarea>
                            <div class="text-right mt-2">
                                <button class="btn btn-sm btn-comment" @click="fnSaveReply(item.commentNo)">답글 등록</button>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="comment-input-box shadow-sm mt-4" v-if="info.nickname !== '탈퇴회원'">
                    <textarea class="form-control mb-2" v-model="newComment" rows="3" placeholder="댓글을 입력해 주세요."></textarea>
                    <div class="text-right">
                        <button class="btn btn-comment px-4 py-2" @click="fnAddComment">댓글 등록</button>
                    </div>
                </div>
                
                <div v-else class="alert alert-light text-center mt-4 border">
                    <i class="fas fa-info-circle text-muted"></i> 탈퇴한 사용자의 리뷰에는 댓글을 남길 수 없습니다.
                </div>
            </div>

             <ul class="post-navigation">
                <!-- 다음글 (위쪽) -->
                <li v-if="reviewDetail && reviewDetail.nextNo" @click="fnGoDetail(reviewDetail.nextNo)">
                    <span class="nav-label">Next</span>
                    <span class="nav-arrow nav-arrow-none">▲</span>
                    <span class="nav-title">{{ reviewDetail.nextTitle }}</span>
                </li>
                <li v-else class="nav-none">
                    <span class="nav-label">Next</span>
                    <span class="nav-arrow nav-arrow-none">▲</span>
                    <span class="nav-title">다음 글이 없습니다.</span>
                </li>

                <!-- 이전글 (아래쪽) -->
                <li v-if="reviewDetail && reviewDetail.prevNo" @click="fnGoDetail(reviewDetail.prevNo)">
                    <span class="nav-label">Prev</span>
                    <span class="nav-arrow nav-arrow-none">▼</span>
                    <span class="nav-title">{{ reviewDetail.prevTitle }}</span>
                </li>
                <li v-else class="nav-none">
                    <span class="nav-label">Prev</span>
                    <span class="nav-arrow nav-arrow-none">▼</span>
                    <span class="nav-title">이전 글이 없습니다.</span>
                </li>
            </ul>
        </div>

       

        <div class="modal fade" id="reportModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-exclamation-circle mr-1"></i> 신고하기
                        </h5>
                        <button type="button" class="close text-white" data-dismiss="modal"><span>&times;</span></button>
                    </div>
                    <div class="modal-body">
                        <p class="small text-muted">허위 신고 시 서비스 이용에 제한을 받을 수 있습니다.</p>
                        
                        <div class="form-group">
                            <label><b>신고 제목</b></label>
                            <input type="text" class="form-control" v-model="reportData.title" placeholder="신고 제목을 입력해 주세요.">
                        </div>

                        <div class="form-group">
                            <label><b>신고 사유 선택</b></label>
                            <select class="form-control" v-model="reportData.reason" @change="fnHandleReasonChange">
                                <option value="">사유를 선택해 주세요</option>
                                <option v-for="opt in reportOptions" :key="opt" :value="opt">{{ opt }}</option>
                                <option value="직접 입력">직접 입력</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label><b>상세 신고 내용</b></label>
                            <textarea class="form-control" v-model="reportData.customReason" rows="3" 
                                      :disabled="reportData.reason === ''" 
                                      placeholder="상세 사유를 입력해 주세요."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-light border" data-dismiss="modal">취소</button>
                        <button type="button" class="btn btn-report-submit" @click="fnSubmitReport">신고 제출</button>
                    </div>
                </div>
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
                    sessionRole: "${sessionRole}",
                    info: null,
                    imgList: [],
                    reviewDetail: null, // 이전/다음글 정보를 담을 변수 추가
                    commentList: [],
                    newComment: "",
                    replyTo: null,
                    replyContent: "",
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
                    if (!this.newComment.trim()) return alert("내용을 입력해주세요.");
                    if (!this.sessionId || this.sessionId === 'null') return alert("로그인이 필요합니다.");
                    $.ajax({
                        url: "/api/comment/review-add.dox",
                        type: "POST",
                        data: JSON.stringify({ reviewNo: this.reviewNo, userId: this.sessionId, content: this.newComment }),
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
                    if (!this.sessionId || this.sessionId === 'null') return alert("로그인이 필요합니다.");
                    if(this.replyContent.trim() === "") return alert("답글 내용을 입력해주세요.");
                    $.ajax({
                        url: "/api/comment/review-add.dox",
                        type: "POST",
                        data: JSON.stringify({ reviewNo: this.reviewNo, content: this.replyContent, parentNo: parentNo, userId: this.sessionId }),
                        contentType: "application/json",
                        success: () => { this.replyTo = null; this.fnGetComments(); }
                    });
                },
                fnOpenImage(url) {
                    if (url) {
                        window.open(url, '_blank');
                    }
                }
            },
            mounted() { 
                this.fnGetDetail(); 
            }
        }).mount('#app');
    </script>
</body>
</html>