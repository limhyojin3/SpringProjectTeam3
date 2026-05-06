<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>리뷰 작성 - MarryView</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    
    <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
    <script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">

    <style>
        :root { --primary-color: #ff4d6d; }
        body { background-color: #f8f9fa; }
        .write-container { max-width: 800px; margin: 40px auto; padding: 30px; background: #fff; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); }
        
        /* 타입 탭 스타일 */
        .type-tabs { display: flex; margin-bottom: 30px; border: 1px solid #ddd; border-radius: 8px; overflow: hidden; }
        .type-tab { flex: 1; padding: 15px; text-align: center; cursor: pointer; font-weight: bold; background: #f8f9fa; color: #666; transition: 0.3s; }
        .type-tab.active { background: var(--primary-color); color: #fff; }
        
        /* 에디터 스타일 */
        #editor { height: 400px; background-color: #fff; border-radius: 0 0 8px 8px; }
        .ql-toolbar { border-radius: 8px 8px 0 0; background-color: #f9f9f9; border-color: #ced4da !important; }
        .ql-container { border-color: #ced4da !important; font-size: 15px; }
        
        /* 파일 및 프리뷰 스타일 */
        .file-box { background: #fdfdfd; border: 1px dashed #ced4da; padding: 20px; border-radius: 8px; margin-bottom: 20px; }
        .essential { color: var(--primary-color); }
        .preview-wrapper { display: flex; gap: 10px; margin-top: 15px; overflow-x: auto; padding-bottom: 10px; }
        .preview-item { position: relative; width: 100px; height: 100px; flex-shrink: 0; }
        .preview-item img { width: 100%; height: 100%; object-fit: cover; border-radius: 8px; border: 1px solid #eee; }
        
        /* 개선된 필독 사항 스타일 */
        .notice-card { background-color: #fff9fa; border: 1px solid #ffccd5; border-radius: 10px; padding: 20px; margin-top: 30px; }
        .notice-card .notice-title { color: #ff4d6d; font-weight: bold; font-size: 1.1rem; margin-bottom: 10px; display: flex; align-items: center; }
        .notice-card ul { margin: 0; padding-left: 20px; color: #666; font-size: 0.95rem; }
        .notice-card li { margin-bottom: 5px; }
        .notice-card li strong { color: #333; }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
    <div id="app">
        
        
        <div class="write-container">
            <h3 class="text-center font-weight-bold mb-4">리뷰 작성</h3>

            <div class="type-tabs">
                <div class="type-tab" :class="{active: isPaid === 0}" @click="fnChangeType(0)">🎁 무료 리뷰</div>
                <div class="type-tab" :class="{active: isPaid === 1}" @click="fnChangeType(1)">💎 유료(상세) 리뷰</div>
            </div>

            <div class="guide-box alert" :class="isPaid === 1 ? 'alert-danger' : 'alert-primary'">
                <div v-if="isPaid === 0"><strong>무료 리뷰:</strong> 텍스트 200자 이내 / 사진 최대 2장 (선택)</div>
                <div v-else><strong>유료 리뷰:</strong> 에디터 활용 500자 이상 / 사진 3장 이상 필수</div>
            </div>

            <div class="form-group">
                <label class="font-weight-bold">리뷰 제목 <span class="essential">*</span></label>
                <input type="text" class="form-control" v-model="title" placeholder="리뷰 내용을 한 줄로 요약해주세요.">
            </div>

            <div class="file-box">
                <label class="font-weight-bold">🧾 영수증 인증 <span class="essential">*</span></label>
                <input type="file" class="form-control-file" ref="receiptFile" accept="image/*">
            </div>

            <div class="form-group company-select-area p-3 rounded bg-light border">
                <label class="font-weight-bold d-block">방문 정보 <span class="essential">*</span></label>
                <div class="mb-3">
                    <div class="custom-control custom-radio custom-control-inline">
                        <input type="radio" id="internal" v-model="companyType" value="internal" class="custom-control-input">
                        <label class="custom-control-label" for="internal" style="cursor:pointer">우리 사이트 등록 업체</label>
                    </div>
                    <div class="custom-control custom-radio custom-control-inline">
                        <input type="radio" id="external" v-model="companyType" value="external" class="custom-control-input">
                        <label class="custom-control-label" for="external" style="cursor:pointer">외부 업체 (직접 입력)</label>
                    </div>
                </div>

                <div class="form-row" v-if="companyType === 'internal'">
                    <div class="col-md-4 mb-2">
                        <select class="form-control" v-model="selectedCategory" @change="fnResetSelection">
                            <option value="">카테고리 선택</option>
                            <option v-for="cat in categoryList" :key="cat" :value="cat">{{cat}}</option>
                        </select>
                    </div>
                    <div class="col-md-4 mb-2">
                        <select class="form-control" v-model="companyNo" :disabled="!selectedCategory" @change="fnGetProductList">
                            <option value="">업체 선택</option>
                            <option v-for="com in filteredCompanyList" :key="com.companyNo" :value="com.companyNo">{{com.comName}}</option>
                        </select>
                    </div>
                    <div class="col-md-4 mb-2">
                        <select class="form-control" v-model="productNo" :disabled="!companyNo">
                            <option value="">상품 선택</option>
                            <option v-for="item in productList" :key="item.productNo" :value="item.productNo">{{item.productName}}</option>
                        </select>
                    </div>
                </div>
                
                <div v-else class="col-md-12 mb-2 p-0">
                    <input type="text" class="form-control" v-model="externalName" placeholder="업체명을 직접 입력하세요.">
                </div>

                <div class="form-row mt-2">
                    <div class="col-md-4">
                        <label class="small font-weight-bold">예약 경로 <span class="essential">*</span></label>
                        <select class="form-control" v-model="bookingSource" ref="bookingSource">
                            <option value="">경로 선택</option>
                            <option value="네이버 예약">네이버 예약</option>
                            <option value="카카오 예약">카카오 예약</option>
                            <option value="전화 예약">전화 예약</option>
                            <option value="방문 예약">방문 예약</option>
                            <option value="기타">기타</option>
                        </select>
                    </div>
                    <div class="col-md-5">
                        <label class="small font-weight-bold">총 지불 비용 (원) <span class="essential">*</span></label>
                        <input type="text" class="form-control" :value="formattedCost" @input="fnInputCost" placeholder="예: 1,500,000">
                    </div>
                    <div class="col-md-3">
                        <label class="small font-weight-bold">별점 <span class="essential">*</span> </label>
                        <select class="form-control" v-model="rating">
                            <option v-for="i in [5,4,3,2,1]" :value="i">{{ '★'.repeat(i) + '☆'.repeat(5-i) }}</option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label class="font-weight-bold">
                    리뷰 내용 <span class="essential">*</span>
                    <span v-if="isPaid === 1" class="small text-danger ml-2">(사진 3장 이상 본문에 삽입 필수)</span>
                </label>
                <div id="editor"></div>
                <div class="d-flex justify-content-between small mt-1 text-muted">
                    <span>이미지는 에디터 상단의 이미지 아이콘을 클릭해 본문에 삽입해주세요.</span>
                    <span>순수 텍스트 글자 수: {{ textLength }} / {{ isPaid === 1 ? '최소 500' : '최대 200' }}자</span>
                </div>
            </div>

            <div class="notice-card shadow-sm">
                <div class="notice-title">
                    <span>⚠️ 등록 전 꼭 확인해 주세요!</span>
                </div>
                <ul>
                    <li>MarryView는 투명한 리뷰 문화를 위해 <strong>등록 후 수정 및 삭제가 불가능</strong>합니다.</li>
                    <li>영수증과 방문 정보가 일치하지 않을 경우 리뷰 승인이 거절될 수 있습니다.</li>
                    <li>허위 사실 유포나 비속어 포함 시 운영 정책에 따라 비공개 처리됩니다.</li>
                </ul>
            </div>

            <div class="text-center mt-5">
                <button class="btn btn-light border btn-lg mr-2" @click="fnBack">취소</button>
                <button class="btn btn-danger btn-lg px-5" @click="fnSave">리뷰 등록하기</button>
            </div>
        </div>
        <jsp:include page="/WEB-INF/common/footer.jsp" />
    </div>

    <script>
        const { createApp } = Vue;
        createApp({
            data() {
                return {
                    sessionId: "${sessionId}",
                    isPaid: 0,
                    companyType: 'internal',
                    title: '',
                    bookingSource: '',
                    totalCost: 0,
                    selectedCategory: '',
                    companyNo: '',
                    productNo: '',
                    externalName: '',
                    rating: 5,
                    quill: null,
                    textLength: 0,
                    companyList: [],
                    categoryList: [],
                    productList: [],
                    previews: [] 
                };
            },
            computed: {
                filteredCompanyList() {
                    if(!this.selectedCategory) return [];
                    return this.companyList.filter(com => com.comType === this.selectedCategory);
                },
                formattedCost() {
                    if (!this.totalCost) return "";
                    return this.totalCost.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                }
            },
            methods: {
                initEditor() {
                    this.quill = new Quill('#editor', {
                        theme: 'snow',
                        modules: {
                           toolbar: [
                                    ['bold', 'italic', 'underline'],
                                    [{ 'color': [] }, { 'background': [] }],
                                    [{ 'list': 'ordered'}, { 'list': 'bullet' }],
                                    ['image'], // 이미지 버튼 추가
                                    ['clean']
                                ]
                            },
                        placeholder: '따뜻한 후기를 남겨주세요.'
                    });
                    this.quill.on('text-change', () => {
                        this.textLength = this.quill.getText().trim().length;
                    });
                },

                fnResetSelection() {
                    this.companyNo = '';
                    this.productNo = '';
                    this.productList = [];
                },

                fnGetProductList() {
                    if(!this.companyNo) {
                        this.productList = [];
                        return;
                    }
                    $.ajax({
                        url: "/api/review/productList.dox",
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify({ companyNo: this.companyNo }),
                        success: (res) => {
                            const data = typeof res === 'string' ? JSON.parse(res) : res;
                            if(data.result === "success") {
                                this.productList = data.list;
                                this.productNo = '';
                            }
                        }
                    });
                },

                fnGetCompanyList() {
                    $.ajax({
                        url: "/api/review/company-list.dox",
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify({}),
                        success: (res) => {
                            const data = typeof res === 'string' ? JSON.parse(res) : res;
                            if(data.result === "success") {
                                this.companyList = data.list;
                                this.categoryList = [...new Set(data.list.map(com => com.comType))];
                            }
                        }
                    });
                },

                fnSave() {
                    if(!confirm("리뷰를 등록하시겠습니까? 등록 후에는 수정 및 삭제가 불가능합니다.")) return;

                    const contentHtml = this.quill.root.innerHTML;
                    const imgCount = (contentHtml.match(/<img/g) || []).length;

                    // 유효성 체크
                    if(!this.title.trim()) return alert("제목을 입력해주세요.");
                    if(!this.$refs.receiptFile.files[0]) return alert("영수증 인증 사진을 업로드해주세요.");
                    
                    if(this.companyType === 'internal') {
                        if(!this.companyNo) return alert("업체를 선택해주세요.");
                        if(!this.productNo) return alert("상품을 선택해주세요.");
                    } else {
                        if(!this.externalName.trim()) return alert("업체명을 직접 입력해주세요.");
                    }
                    /// 1. 예약 경로 검사
                    if (!this.bookingSource || this.bookingSource.trim() === "") {
                        alert("예약 경로를 입력해 주세요.");
                        this.$refs.bookingSource.focus();
                        return;
                    }

                    // 2. 지불 비용 검사 (숫자가 0이거나 비어있는지 확인)
                    // totalCost가 0원일 수도 있다면 !this.totalCost && this.totalCost !== 0 로 체크
                    if (!this.totalCost || this.totalCost <= 0) {
                        alert("정확한 비용을 입력해 주세요.");
                        this.$refs.totalCost.focus();
                        return;
                    }

                    // 3. 별점 검사 (필수)
                    if (!this.rating) {
                        alert("별점을 선택해 주세요.");
                        this.$refs.rating.focus();
                        return;
                    }

                    if(this.isPaid === 1) 
                        {
                            if(this.textLength < 500) return alert("유료 리뷰는 500자 이상 작성해야 합니다.");
                            if(imgCount < 3) return alert("유료 리뷰는 본문에 사진을 3장 이상 삽입해야 합니다.");
                        } 
                        else {
                            if(imgCount > 2) return alert("무료 리뷰는 사진을 2장까지만 등록 가능합니다.");
                    }

                    const formData = new FormData();
                    const receipt = this.$refs.receiptFile.files[0];
                    

                    formData.append("receiptFile", receipt);
                   
                    
                    const reviewData = {
                        userId: this.sessionId,
                        companyNo: this.companyType === 'internal' ? this.companyNo : null,
                        productNo: this.companyType === 'internal' ? this.productNo : null,
                        externalName: this.companyType === 'external' ? this.externalName : null,
                        rating: this.rating,
                        content: contentHtml,
                        isPaid: this.isPaid,
                        title: this.title,
                        bookingSource: this.bookingSource,
                        totalCost: this.totalCost
                    };
                    formData.append("reviewData", JSON.stringify(reviewData));

                    $.ajax({
                        url: "/api/review/save.dox",
                        type: "POST",
                        processData: false,
                        contentType: false,
                        data: formData,
                        success: (res) => {
                            const data = typeof res === 'string' ? JSON.parse(res) : res;
                            if(data.result === "success") {
                                alert("리뷰가 성공적으로 등록되었습니다.");
                                location.href = "/api/review/list.do";
                            } else {
                                alert("등록에 실패했습니다.");
                            }
                        }
                    });
                },

                fnInputCost(e) {
                    const value = e.target.value.replace(/[^0-9]/g, "");
                    this.totalCost = value ? parseInt(value) : 0;
                },
                fnChangeType(type) {
                    if (this.title.trim() || this.textLength > 0) {
                        if (!confirm("유형 변경 시 내용이 초기화됩니다. 변경하시겠습니까?")) return;
                    }
                    this.isPaid = type;
                    this.title = ""; this.totalCost = 0; this.quill.root.innerHTML = ""; this.previews = [];
                },
                fnFileCheck() {
                    const files = this.$refs.reviewFiles.files;
                    this.previews = [];
                    Array.from(files).forEach(file => {
                        const reader = new FileReader();
                        reader.onload = (e) => this.previews.push(e.target.result);
                        reader.readAsDataURL(file);
                    });
                },
                fnBack() { if(confirm("작성 중인 내용이 사라집니다. 돌아가시겠습니까?")) history.back(); }
            },
            mounted() {
                this.initEditor();
                this.fnGetCompanyList();
            }
        }).mount('#app');
    </script>
</body>
</html>