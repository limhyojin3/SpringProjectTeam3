/**
 * ==========================================================================
 * [ProductEditCoreModule] 수정 대상 상세조회, 스냅샷 감지 및 멀티파트 수정 전송 모듈
 * ==========================================================================
 */
const productEditCoreModule = {
    // 1. 핵심 상품 정보 수정 양식 및 데이터 스냅샷 보관용 그릇 원형 보존
    data() {
        return {
            previewUrl: null,      
            uploadFile: null,      
            originalSnapshot: '',  
            oneProductDetails: {
                productNo: '',
                productName: '',
                largeCategory: '',
                mediumCategory: '',
                productDetails: '',
                originalPrice: '',  
                deposit: '',        
                imgUrl: '',
                isActive: 1         
            }
        };
    },

    // 2. 🎯 데이터 실시간 스냅샷 비교 엔진 연산부 원형 보존
    computed: {
        isModified() {
            if (this.uploadFile !== null) {
                return true;
            }
            const currentSnapshot = JSON.stringify({
                name: this.oneProductDetails.productName || '',
                large: this.oneProductDetails.largeCategory || '',
                medium: this.oneProductDetails.mediumCategory || '',
                details: this.oneProductDetails.productDetails || '',
                price: this.oneProductDetails.originalPrice || '',
                deposit: this.oneProductDetails.deposit || '',
                tags: [...this.selectedTags].sort()
            });
            return currentSnapshot !== this.originalSnapshot;
        }
    },

    // 3. 비즈니스 코어 상세 가공 처리 함수 파이프라인 일체 보존
    methods: {
        /**
         * 입력창 천단위 콤마 실시간 변환 필터 매커니즘
         */
        fnInputComma(field) {
            let value = String(this.oneProductDetails[field] || '');
            value = value.replace(/[^0-9]/g, '');
            value = value.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
            this.oneProductDetails[field] = value;
        },

        /**
         * [AJAX] 수정 페이지 진입 시 자식 스스로 백엔드 직통 단건 상세 데이터 파싱 로드
         */
        fnFetchDetail() {
            let self = this;
            let param = {
                userid: window.SESSION_ID,
                productNo: this.productNo
            };
            $.ajax({
                url: "http://localhost:8080/productDetail.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    console.log("📂 [Module] 기존 상품 상세 데이터 로드 완료");
                    self.oneProductDetails = data.info;

                    self.fnInputComma('originalPrice');
                    self.fnInputComma('deposit');

                    let large = self.oneProductDetails.largeCategory;
                    let medium = self.oneProductDetails.mediumCategory;

                    if (large && self.categoryTree[large] && self.categoryTree[large].mediums) {
                        self.availableMediums = self.categoryTree[large].mediums;
                    }
                    
                    if (large === '결혼' && medium && self.categoryTree['결혼'] && self.categoryTree['결혼'].tags && self.categoryTree['결혼'].tags[medium]) {
                        self.availableTags = self.categoryTree['결혼'].tags[medium];
                    }

                    if (data.tagList && Array.isArray(data.tagList)) {
                        self.selectedTags = [...data.tagList];
                    } else if (typeof self.oneProductDetails.tag === 'string') {
                        try {
                            self.selectedTags = JSON.parse(self.oneProductDetails.tag);
                        } catch (e) {
                            self.selectedTags = [];
                        }
                    }

                    self.originalSnapshot = JSON.stringify({
                        name: self.oneProductDetails.productName || '',
                        large: self.oneProductDetails.largeCategory || '',
                        medium: self.oneProductDetails.mediumCategory || '',
                        details: self.oneProductDetails.productDetails || '',
                        price: self.oneProductDetails.originalPrice || '',
                        deposit: self.oneProductDetails.deposit || '',
                        tags: [...self.selectedTags].sort()
                    });
                }
            });
        },

        /**
         * 수정할 이미지 파일 핸들링 미리보기 URL 기동
         */
        fnFileChange(event) {
            const file = event.target.files[0];
            if (file) {
                this.uploadFile = file;
                this.previewUrl = URL.createObjectURL(file);
            }
        },

        /**
         * [AJAX] 수정한 상품 정보 전송 매커니즘
         */
        fnUpdateProduct() {
            if (!this.oneProductDetails.productName) {
                alert("상품 이름을 적어주세요."); return;
            }
            if (!this.oneProductDetails.largeCategory) {
                alert("대분류 카테고리를 선택해 주세요."); return;
            }
            if (!this.oneProductDetails.mediumCategory) {
                alert("중분류 카테고리를 선택해 주세요."); return;
            }

            let self = this;
            let formData = new FormData();

            if (this.uploadFile) {
                formData.append("file", this.uploadFile);
            }
            
            let pureOriginalPrice = String(this.oneProductDetails.originalPrice).replace(/,/g, '');
            let pureDeposit = String(this.oneProductDetails.deposit).replace(/,/g, '');

            formData.append("productNo", this.oneProductDetails.productNo);
            formData.append("productName", this.oneProductDetails.productName);
            formData.append("productDetails", this.oneProductDetails.productDetails);
            formData.append("originalPrice", pureOriginalPrice ? Number(pureOriginalPrice) : 0);
            formData.append("deposit", pureDeposit ? Number(pureDeposit) : 0);
            formData.append("largeCategory", this.oneProductDetails.largeCategory);
            formData.append("mediumCategory", this.oneProductDetails.mediumCategory);
            formData.append("userId", window.SESSION_ID);

            let activeStatus = this.oneProductDetails.isActive !== undefined ? this.oneProductDetails.isActive : 1;
            formData.append("isActive", activeStatus);
            formData.append("imgUrl", this.oneProductDetails.imgUrl || '');

            if (this.selectedTags.length > 0) {
                this.selectedTags.forEach(tag => {
                    formData.append("uniqueNewTagsOnly", tag);
                });
            }

            $.ajax({
                url: "/upload.dox",
                type: "POST",
                data: formData,
                processData: false,
                contentType: false,
                success: function(data) {
                    let res = (typeof data === 'string') ? JSON.parse(data) : data;
                    if (res.result === "success") {
                        alert("🎉 상품 정보가 성공적으로 수정되었습니다!");
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
         * 돌아가기 및 폼 버퍼 전면 클리어
         */
        fnBackToList() {
            this.selectedTags = [];
            this.availableMediums = [];
            this.availableTags = [];
            this.uploadFile = null;
            this.previewUrl = null;
            this.originalSnapshot = ''; 
            this.oneProductDetails = {
                productNo: '', productName: '', largeCategory: '', mediumCategory: '',
                productDetails: '', originalPrice: '', deposit: '', imgUrl: '', isActive: 1
            };
            this.$emit('back');
        }
    }
};