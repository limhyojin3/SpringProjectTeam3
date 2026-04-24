<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>리뷰 작성 - MerryView</title>
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
        .type-tabs { display: flex; margin-bottom: 30px; border: 1px solid #ddd; border-radius: 8px; overflow: hidden; }
        .type-tab { flex: 1; padding: 15px; text-align: center; cursor: pointer; font-weight: bold; background: #f8f9fa; color: #666; transition: 0.3s; }
        .type-tab.active { background: var(--primary-color); color: #fff; }
        
        /* 에디터 스타일 커스텀 */
        #editor { height: 400px; background-color: #fff; border-radius: 0 0 8px 8px; }
        .ql-toolbar { border-radius: 8px 8px 0 0; background-color: #f9f9f9; border-color: #ced4da !important; }
        .ql-container { border-color: #ced4da !important; font-size: 15px; }

        .file-box { background: #fdfdfd; border: 1px dashed #ced4da; padding: 20px; border-radius: 8px; margin-bottom: 20px; }
        .essential { color: var(--primary-color); }
        .delete-warning { background-color: #fff3f3; border: 1px solid #ffcccc; color: #d9534f; padding: 15px; border-radius: 8px; font-size: 0.9rem; margin-top: 30px; }
        .preview-wrapper { display: flex; gap: 10px; margin-top: 15px; overflow-x: auto; padding-bottom: 10px; }
        .preview-item { position: relative; width: 100px; height: 100px; flex-shrink: 0; }
        .preview-item img { width: 100%; height: 100%; object-fit: cover; border-radius: 8px; border: 1px solid #eee; }
    </style>
</head>
<body>
    <div id="app">
        <jsp:include page="/WEB-INF/common/header.jsp" />
        
        <div class="write-container">
            <h3 class="text-center font-weight-bold mb-4">리뷰 작성</h3>

            <div class="type-tabs">
                <div class="type-tab" :class="{active: isPaid === 0}" @click="fnChangeType(0)">🎁 무료 리뷰</div>
                <div class="type-tab" :class="{active: isPaid === 1}" @click="fnChangeType(1)">💎 유료(상세) 리뷰</div>
            </div>

            <div class="guide-box alert" :class="isPaid === 1 ? 'alert-danger' : 'alert-primary'">
                <div v-if="isPaid === 0">
                    <strong>무료 리뷰:</strong> 텍스트 200자 이내 / 사진 최대 2장 (선택)
                </div>
                <div v-else>
                    <strong>유료 리뷰:</strong> 에디터 활용 500자 이상 필히 작성 / 사진 3장 이상 필수
                </div>
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

                <div class="form-row">
                    <template v-if="companyType === 'internal'">
                        <div class="col-md-4 mb-2">
                            <select class="form-control" v-model="selectedCategory" @change="companyNo = ''">
                                <option value="">카테고리 선택</option>
                                <option v-for="cat in categoryList" :key="cat" :value="cat">{{cat}}</option>
                            </select>
                        </div>
                        <div class="col-md-8 mb-2">
                            <select class="form-control" v-model="companyNo" :disabled="!selectedCategory">
                                <option value="">업체를 선택해주세요</option>
                                <option v-for="com in filteredCompanyList" :key="com.companyNo" :value="com.companyNo">{{com.comName}}</option>
                            </select>
                        </div>
                    </template>
                    <div v-else class="col-md-12 mb-2">
                        <input type="text" class="form-control" v-model="externalName" placeholder="업체명을 직접 입력하세요.">
                    </div>
                </div>

                <div class="form-row mt-2">
                    <div class="col-md-4">
                        <label class="small font-weight-bold">예약 경로 <span class="essential">*</span></label>
                        <input type="text" class="form-control" v-model="bookingSource" placeholder="예: 네이버예약">
                    </div>
                    <div class="col-md-5">
                        <label class="small font-weight-bold">총 지불 비용 (원) <span class="essential">*</span></label>
                        <input type="text" class="form-control" :value="formattedCost" @input="fnInputCost" placeholder="예: 1,500,000">
                    </div>
                    <div class="col-md-3">
                        <label class="small font-weight-bold">별점</label>
                        <select class="form-control" v-model="rating">
                            <option v-for="i in [5,4,3,2,1]" :value="i">{{ '★'.repeat(i) + '☆'.repeat(5-i) }}</option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label class="font-weight-bold">리뷰 내용 <span class="essential">*</span></label>
                <div id="editor"></div>
                <div class="text-right small mt-1 text-muted">
                    순수 텍스트 글자 수: {{ textLength }} / {{ isPaid === 1 ? '최소 500' : '최대 200' }}자
                </div>
            </div>

            <div class="file-box">
                <label class="font-weight-bold">📸 리뷰 사진 <span v-if="isPaid === 1" class="essential">(3장 이상 필수)</span></label>
                <input type="file" class="form-control-file" ref="reviewFiles" multiple @change="fnFileCheck" accept="image/*">
                
                <div class="preview-wrapper" v-if="previews.length > 0">
                    <div v-for="(src, index) in previews" :key="index" class="preview-item">
                        <img :src="src">
                    </div>
                </div>
            </div>

            <div class="delete-warning shadow-sm">
                <strong>⚠️ 필독 사항</strong><br>
                등록 후 <strong>수정 및 삭제가 불가능</strong>하니 신중히 등록해 주세요.
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
                    externalName: '',
                    rating: 5,
                    quill: null,
                    textLength: 0, // 순수 텍스트 길이 상태
                    companyList: [],
                    categoryList: [],
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
                                ['clean']
                            ]
                        },
                        placeholder: '따뜻한 후기를 남겨주세요.'
                    });

                    // 글자 수 실시간 체크
                    this.quill.on('text-change', () => {
                        this.textLength = this.quill.getText().trim().length;
                    });
                },
                fnInputCost(e) {
                    const value = e.target.value.replace(/[^0-9]/g, "");
                    this.totalCost = value ? parseInt(value) : 0;
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
                fnChangeType(type) {
                    if (this.title.trim() || this.textLength > 0 || this.previews.length > 0) {
                        if (!confirm("유형 변경 시 내용이 초기화됩니다. 변경하시겠습니까?")) return;
                    }
                    this.isPaid = type;
                    this.title = "";
                    this.totalCost = 0;
                    this.quill.root.innerHTML = "";
                    this.previews = [];
                    if(this.$refs.reviewFiles) this.$refs.reviewFiles.value = "";
                },
                fnFileCheck() {
                    const files = this.$refs.reviewFiles.files;
                    this.previews = []; 
                    if(this.isPaid === 0 && files.length > 2) {
                        alert("무료 리뷰는 사진을 최대 2장까지만 첨부할 수 있습니다.");
                        this.$refs.reviewFiles.value = "";
                        return;
                    }
                    Array.from(files).forEach(file => {
                        const reader = new FileReader();
                        reader.onload = (e) => this.previews.push(e.target.result);
                        reader.readAsDataURL(file);
                    });
                },
                fnSave() {
                    const receipt = this.$refs.receiptFile.files[0];
                    const reviewFiles = this.$refs.reviewFiles.files;
                    const contentHtml = this.quill.root.innerHTML;
                    const plainText = this.quill.getText().trim();

                    if(!this.title.trim()) return alert("제목을 입력해주세요.");
                    if(!receipt) return alert("영수증 인증은 필수입니다!");
                    if(this.companyType === 'internal' && !this.companyNo) return alert("업체를 선택해주세요.");
                    if(!this.bookingSource.trim()) return alert("예약 경로를 입력해주세요.");
                    if(this.totalCost <= 0) return alert("금액을 입력해주세요.");
                    
                    // 글자 수 유효성 검사
                    if(plainText.length === 0) return alert("리뷰 내용을 입력해주세요.");
                    
                    if(this.isPaid === 0) {
                        if(plainText.length > 200) return alert("무료 리뷰는 200자 이하로 작성해주세요.");
                    } else {
                        if(plainText.length < 500) return alert("유료 리뷰는 최소 500자 이상 작성해야 합니다.");
                        if(reviewFiles.length < 3) return alert("유료 리뷰는 사진을 최소 3장 이상 첨부해야 합니다.");
                    }

                    if(!confirm("등록 후 수정/삭제가 불가능합니다. 등록하시겠습니까?")) return;

                    const formData = new FormData();
                    formData.append("receiptFile", receipt);
                    for(let i=0; i<reviewFiles.length; i++) {
                        formData.append("reviewFiles", reviewFiles[i]);
                    }
                    
                    const reviewData = {
                        userId: this.sessionId,
                        companyNo: this.companyType === 'internal' ? this.companyNo : null,
                        externalName: this.companyType === 'external' ? this.externalName : null,
                        rating: this.rating,
                        content: contentHtml, // 에디터의 HTML 내용 전송
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
                                alert("리뷰가 등록되었습니다.");
                                location.href = "/api/review/list.do";
                            } else {
                                alert("등록 실패: " + data.message);
                            }
                        }
                    });
                },
                fnBack() {
                    if(confirm("작성 중인 내용은 저장되지 않습니다. 돌아가시겠습니까?")) history.back();
                }
            },
            mounted() {
                this.initEditor();
                this.fnGetCompanyList();
            }
        }).mount('#app');
    </script>
</body>
</html>