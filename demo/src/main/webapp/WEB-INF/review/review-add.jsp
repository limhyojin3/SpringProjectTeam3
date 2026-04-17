<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>리뷰 작성 - 영수증 인증 필수</title>
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.js"></script>

    <style>
        .container { max-width: 800px; margin-top: 50px; margin-bottom: 50px; }
        .form-group label { font-weight: bold; }
        .btn-submit { background-color: #ffb6c1; color: white; width: 100%; padding: 10px; font-weight: bold; }
        .btn-submit:hover { background-color: #ff8c94; }
        .note-editor { border-radius: 5px; }
    </style>
</head>
<body>

<div id="app" class="container">
    <div class="card shadow">
        <div class="card-header bg-white text-center">
            <h3>리뷰 등록 (인증 필수)</h3>
        </div>
        <div class="card-body">
            
            <div class="form-group">
                <label>리뷰 형태</label>
                <div class="btn-group btn-group-toggle d-block">
                    <label class="btn btn-outline-secondary" :class="{active: reviewInfo.isPaid == 0}">
                        <input type="radio" v-model="reviewInfo.isPaid" value="0"> 무료 간단리뷰
                    </label>
                    <label class="btn btn-outline-secondary" :class="{active: reviewInfo.isPaid == 1}">
                        <input type="radio" v-model="reviewInfo.isPaid" value="1"> 유료 상세리뷰
                    </label>
                </div>
            </div>

            <div class="row">
                <div class="col-md-4">
                    <div class="form-group">
                        <label>카테고리</label>
                        <select v-model="reviewInfo.category" class="form-control">
                            <option value="">선택</option>
                            <option value="S">스튜디오</option>
                            <option value="D">드레스</option>
                            <option value="M">메이크업</option>
                        </select>
                    </div>
                </div>
                <div class="col-md-8">
                    <div class="form-group">
                        <label>업체명</label>
                        <input type="text" v-model="reviewInfo.targetName" class="form-control" placeholder="업체명을 입력하세요">
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label>예약 경로</label>
                        <select v-model="reviewInfo.bookingSource" class="form-control">
                            <option value="">선택하세요</option>
                            <option value="app">자사 앱</option>
                            <option value="visit">현장 방문</option>
                            <option value="call">전화 예약</option>
                            <option value="etc">기타</option>
                        </select>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label>총 결제 금액 (원)</label>
                        <input type="number" v-model="reviewInfo.totalCost" class="form-control" placeholder="숫자만 입력">
                        <small class="text-primary" v-if="reviewInfo.totalCost > 0">
                            실제 금액: {{ Number(reviewInfo.totalCost).toLocaleString() }} 원
                        </small>
                    </div>
                </div>
            </div>

            <div class="form-group" v-if="reviewInfo.isPaid == 1">
                <label>리뷰 제목</label>
                <input type="text" v-model="reviewInfo.title" class="form-control" placeholder="상세 리뷰 제목을 입력하세요">
            </div>

            <div class="form-group">
                <label>평점: {{reviewInfo.rating}}점</label>
                <input type="range" v-model="reviewInfo.rating" class="custom-range" min="1" max="5" step="0.5">
            </div>

            <div class="form-group">
                <label>리뷰 내용</label>
                <div id="summernote"></div>
            </div>

            <div class="form-group">
                <label>영수증 인증파일 (이미지 필수)</label>
                <div class="custom-file">
                    <input type="file" class="custom-file-input" id="receiptFile" ref="fileInput" @change="fnFileChange">
                    <label class="custom-file-label" for="receiptFile">{{ fileName || '파일을 선택하세요' }}</label>
                </div>
            </div>

            <button type="button" class="btn btn-submit" @click="fnSubmit">리뷰 등록하기</button>
        </div>
    </div>
</div>

<script>
    const app = Vue.createApp({
        data() {
            return {
                reviewInfo: {
                    isPaid: 0,
                    category: "",
                    targetName: "",
                    title: "",
                    content: "",
                    rating: 5.0,
                    companyNo: 0,
                    bookingSource: "", // 추가됨
                    totalCost: 0       // 추가됨
                },
                selectedFile: null,
                fileName: ""
            };
        },
        methods: {
            fnFileChange(event) {
                const file = event.target.files[0];
                if (file) {
                    this.selectedFile = file;
                    this.fileName = file.name;
                }
            },
            // 금액 포맷 함수
            fnFormatCurrency(value) {
                if (!value) return '0원';
                return new Intl.NumberFormat('ko-KR', { style: 'currency', currency: 'KRW' }).format(value);
                // 또는 간단하게: return Number(value).toLocaleString() + '원';
            },
            
            fnSubmit() {
                // 에디터 내용 수집
                this.reviewInfo.content = $('#summernote').summernote('code');

                // 유효성 검사
                if(!this.selectedFile) {
                    alert("영수증 인증은 필수입니다!");
                    return;
                }
                if(!this.reviewInfo.targetName) {
                    alert("업체명을 입력해주세요.");
                    return;
                }
                if(!this.reviewInfo.content || this.reviewInfo.content === "<p><br></p>") {
                    alert("리뷰 내용을 입력해주세요.");
                    return;
                }

                let formData = new FormData();
                formData.append("file", this.selectedFile);
                formData.append("reviewData", JSON.stringify(this.reviewInfo));

                $.ajax({
                    url: "/api/review/add.dox",
                    type: "POST",
                    data: formData,
                    processData: false, 
                    contentType: false, 
                    success: (res) => {
                        let data = typeof res === 'string' ? JSON.parse(res) : res;
                        
                        if (data.result === "success") {
                            alert(data.message);
                            location.href = "/api/review/list.do";
                        } else {
                            alert("등록 실패 : " + data.message);
                        }
                    },
                    error: () => {
                        alert("서버 통신 중 오류가 발생했습니다.");
                    }
                });
            }
        },
        mounted() {
            $('#summernote').summernote({
                placeholder: '영수증 인증 리뷰는 다른 예비 부부들에게 큰 도움이 됩니다.',
                height: 300,
                lang: 'ko-KR',
                toolbar: [
                    ['style', ['bold', 'italic', 'underline', 'clear']],
                    ['font', ['strikethrough']],
                    ['para', ['ul', 'ol', 'paragraph']],
                    ['insert', ['link', 'picture']],
                    ['view', ['fullscreen', 'codeview']]
                ]
            });
        }
    }).mount('#app');
</script>

</body>
</html>