<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>리뷰 작성 - MerryView</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    
    
    <style>
        :root { --primary-color: #ff4d6d; }
        .write-container { max-width: 800px; margin: 40px auto; padding: 30px; background: #fff; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); }
        
        /* 유료/무료 선택 탭 */
        .type-tabs { display: flex; margin-bottom: 30px; border: 1px solid #ddd; border-radius: 8px; overflow: hidden; }
        .type-tab { flex: 1; padding: 15px; text-align: center; cursor: pointer; font-weight: bold; background: #f8f9fa; color: #666; transition: 0.3s; }
        .type-tab.active { background: var(--primary-color); color: #fff; }
        
        .file-box { background: #fdfdfd; border: 1px dashed #ced4da; padding: 20px; border-radius: 8px; margin-bottom: 20px; }
        .essential { color: var(--primary-color); }
        .guide-box { font-size: 0.85rem; padding: 10px; border-radius: 5px; margin-bottom: 15px; }
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

            <div class="guide-box" :class="isPaid === 1 ? 'alert-danger' : 'alert-primary'">
                <div v-if="isPaid === 0">
                    <strong>무료 리뷰 안내:</strong> 텍스트 200자 이내 / 사진 최대 2장 (선택사항)
                </div>
                <div v-else>
                    <strong>유료 리뷰 안내:</strong> 텍스트 500자 이상 필히 작성 / 사진 3장 이상 첨부 필수
                </div>
            </div>

            <div class="file-box">
                <label class="font-weight-bold">🧾 영수증 인증 <span class="essential">*</span></label>
                <input type="file" class="form-control-file" ref="receiptFile">
                <small class="text-muted">무료/유료 관계없이 실제 이용 증빙은 필수입니다.</small>
            </div>

            <div class="form-row">
                <div class="form-group col-md-8">
                    <label class="font-weight-bold">방문 업체 <span class="essential">*</span></label>
                    <select class="form-control" v-model="companyNo">
                        <option value="">업체를 선택해주세요</option>
                        <option v-for="com in companyList" :value="com.companyNo">{{com.comName}}</option>
                    </select>
                </div>
                <div class="form-group col-md-4">
                    <label class="font-weight-bold">별점</label>
                    <select class="form-control" v-model="rating">
                        <option v-for="i in [5,4,3,2,1]" :value="i">{{ '★'.repeat(i) + '☆'.repeat(5-i) }}</option>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label class="font-weight-bold">리뷰 내용 <span class="essential">*</span></label>
                <textarea class="form-control" rows="10" v-model="content" 
                          :placeholder="isPaid === 1 ? '상세한 후기를 500자 이상 남겨주세요.' : '후기를 남겨주세요.'"></textarea>
                <div class="text-right small mt-1" :class="contentError ? 'text-danger' : 'text-muted'">
                    {{ content.length }} / {{ isPaid === 1 ? '최소 500' : '최대 200' }}자
                </div>
            </div>

            <div class="file-box">
                <label class="font-weight-bold">📸 리뷰 사진 <span v-if="isPaid === 1" class="essential">(3장 이상 필수)</span></label>
                <input type="file" class="form-control-file" ref="reviewFiles" multiple @change="fnFileCheck">
                <small class="text-muted">{{ isPaid === 1 ? '유료 리뷰는 3장 이상 업로드해야 합니다.' : '무료 리뷰는 최대 2장까지만 가능합니다.' }}</small>
            </div>

            <div class="text-center mt-5">
                <button class="btn btn-light border btn-lg mr-2" @click="fnBack">취소</button>
                <button class="btn btn-danger btn-lg px-5" @click="fnSave">리뷰 등록하기</button>
            </div>
        </div>
    </div>

    <script>
        const { createApp } = Vue;
        createApp({
            data() {
                return {
                    isPaid: 0,
                    companyNo: '',
                    rating: 5,
                    content: '',
                    companyList: [], 
                    contentError: false
                };
            },
            methods: {
                fnChangeType(type) {
                    if(confirm("유형 변경 시 작성 내용이 초기화될 수 있습니다. 변경하시겠습니까?")) {
                        this.isPaid = type;
                        this.content = ""; // 유형 바뀔 때 내용 초기화 (글자수 제한이 다르므로)
                    }
                },
                fnFileCheck() {
                    const files = this.$refs.reviewFiles.files;
                    if(this.isPaid === 0 && files.length > 2) {
                        alert("무료 리뷰는 사진을 최대 2장까지만 등록할 수 있습니다.");
                        this.$refs.reviewFiles.value = "";
                    }
                },
                fnSave() {
                    const receipt = this.$refs.receiptFile.files[0];
                    const reviewFiles = this.$refs.reviewFiles.files;

                    // 공통 검증
                    if(!receipt) return alert("영수증 인증은 필수입니다!");
                    if(!this.companyNo) return alert("업체를 선택해주세요.");

                    // 무료 리뷰 검증 (200자 이하)
                    if(this.isPaid === 0) {
                        if(this.content.length > 200) return alert("무료 리뷰는 200자 이하로 작성해주세요.");
                    }
                    
                    // 유료 리뷰 검증 (500자 이상, 사진 3장 이상)
                    if(this.isPaid === 1) {
                        if(this.content.length < 500) return alert("상세 리뷰는 500자 이상 작성해야 합니다.");
                        if(reviewFiles.length < 3) return alert("상세 리뷰는 사진을 3장 이상 첨부해야 합니다.");
                    }

                    // 서버 전송 로직 (FormData 사용)
                    const formData = new FormData();
                    formData.append("receiptFile", receipt);
                    for(let i=0; i<reviewFiles.length; i++) {
                        formData.append("reviewFiles", reviewFiles[i]);
                    }
                    
                    const reviewData = {
                        companyNo: this.companyNo,
                        rating: this.rating,
                        content: this.content,
                        isPaid: this.isPaid
                    };
                    formData.append("reviewData", JSON.stringify(reviewData));

                    // $.ajax 호출... (이하 생략)
                    alert("검증 완료! 서버로 전송합니다.");
                },
                fnBack() { history.back(); }
            }
        }).mount('#app');
    </script>
</body>
</html>