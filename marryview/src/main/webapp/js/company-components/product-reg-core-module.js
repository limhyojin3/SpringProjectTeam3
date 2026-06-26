/**
 * ==========================================================================
 * [ProductRegCoreModule] 상품 기본 정보 필드 및 물리 파일 서버 전송 본진 모듈
 * ==========================================================================
 */
const productRegCoreModule = {
    // 상품 정보 필드 및 파일 바이너리 그릇 일체 보존
    data() {
        return {
            initializedOneProductDetails: {
                productName: '',
                largeCategory: '',
                mediumCategory: '',
                productDetails: '',
                originalPrice: '', 
                deposit: ''       
            },
            imgPreviewUrl: '',    
            uploadFile: null      
        };
    },

    // 금액 가공, 파일 변경 핸들러 및 서버 통신 인서트 API 메서드 일체 보존
    methods: {
        /**
         * 입력창 천단위 콤마 실시간 변환 필터 매커니즘
         */
        fnInputComma(field) {
            let value = this.initializedOneProductDetails[field];
            value = value.replace(/[^0-9]/g, '');
            value = value.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
            this.initializedOneProductDetails[field] = value;
        },

        /**
         * 바이너리 사진 선택 제어 및 자립형 로컬 미리보기 URL 추출 매커니즘
         */
        fnFileChange(event) {
            const file = event.target.files[0];
            if (file) {
                this.uploadFile = file;
                this.imgPreviewUrl = URL.createObjectURL(file);
                this.$emit('file-change', event);
            }
        },

        /**
         * [AJAX] 최종 [상품 등록] 버튼 클릭 시 백엔드 /upload2.dox 관로 결합 전송 집행
         */
        fnInsertProduct() {
            if (!this.initializedOneProductDetails.productName) {
                alert("상품 이름을 적어주세요."); return;
            }
            if (!this.initializedOneProductDetails.largeCategory) {
                alert("대분류 카테고리를 칩으로 선택해 주세요."); return;
            }
            if (!this.initializedOneProductDetails.mediumCategory) {
                alert("중분류 카테고리를 칩으로 선택해 주세요."); return;
            }

            let self = this;
            let formData = new FormData();

            if (this.uploadFile) {
                formData.append("file", this.uploadFile);
            }
            
            let pureOriginalPrice = String(this.initializedOneProductDetails.originalPrice).replace(/,/g, '');
            let pureDeposit = String(this.initializedOneProductDetails.deposit).replace(/,/g, '');

            formData.append("productName", this.initializedOneProductDetails.productName);
            formData.append("productDetails", this.initializedOneProductDetails.productDetails);
            formData.append("originalPrice", pureOriginalPrice ? Number(pureOriginalPrice) : 0);
            formData.append("deposit", pureDeposit ? Number(pureDeposit) : 0);
            formData.append("largeCategory", this.initializedOneProductDetails.largeCategory);
            formData.append("mediumCategory", this.initializedOneProductDetails.mediumCategory);
            formData.append("isActive", 1); 
            formData.append("userId", window.SESSION_ID); 

            if (this.selectedTags.length > 0) {
                this.selectedTags.forEach(tag => {
                    formData.append("uniqueNewTagsOnly", tag);
                });
            }

            $.ajax({
                url: "/upload2.dox",
                type: "POST",
                data: formData,
                processData: false, 
                contentType: false, 
                success: function(data) {
                    let res = (typeof data === 'string') ? JSON.parse(data) : data;
                    if (res.result === "success") {
                        alert("🎉 상품 등록이 성공적으로 완료되었습니다!");
                        self.fnBackToList(); 
                    } else {
                        alert("서버 응답 오류: " + res.message);
                    }
                },
                error: function() {
                    alert("서버 통신 중 장애가 발생했습니다.");
                }
            });
        },

        /**
         * 돌아가기 버튼 시그널 부모 위임 및 누적 메모리 초기화 리셋
         */
        fnBackToList() {
            this.selectedTags = [];
            this.availableMediums = [];
            this.availableTags = [];
            this.uploadFile = null;
            this.imgPreviewUrl = ''; 
            
            this.initializedOneProductDetails = {
                productName: '',
                largeCategory: '',
                mediumCategory: '',
                productDetails: '',
                originalPrice: '',
                deposit: ''
            };
            this.$emit('back');
        }
    }
};