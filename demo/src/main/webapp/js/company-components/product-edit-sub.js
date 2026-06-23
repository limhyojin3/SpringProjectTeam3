/**
 * ==========================================================================
 * [ProductEditSub] 기등록 상품 수정 - 100% 완전 자립형 독립 서브 컴포넌트 객체
 * ==========================================================================
 */
const ProductEditSub = {
    template: '#product-edit-sub-template',
    
    // 부모 관제소로부터 정밀 타격할 상품 일련번호 딱 하나만 무역 창구로 수급받음
    props: ['productNo'],

    // 등록 폼과 100% 호환되도록 설계된 독립 독점 데이터 주머니 완공
    data() {
        return {
            categoryTree: {},      // /getCategoryTree.dox 가 반환할 대/중/태그 마스터 사전 객체
            availableMediums: [],  // 현재 선택된 대분류 하위의 중분류 리스트 배열
            availableTags: [],     // 현재 선택된 중분류 하위의 리얼 마스터 태그 리스트 배열
            selectedTags: [],      // 사용자가 마우스 클릭으로 활성화한 최종 선택 태그 리스트 배열 (최대 3개 제한)
            previewUrl: null,      // 새로 선택한 이미지의 로컬 미리보기 경로 그릇
            uploadFile: null,      // 사진 선택 시 바이너리가 머무를 내부 local 그릇
            originalSnapshot: '',  // 🎯 [신규] 최초 로드 시점의 순수 데이터 뼈대를 박제할 스냅샷 보관소
            oneProductDetails: {
                productNo: '',
                productName: '',
                largeCategory: '',
                mediumCategory: '',
                productDetails: '',
                originalPrice: '',  // 실시간 문자열 콤마 핸들링을 위해 공백 문자열로 세팅
                deposit: '',        // 실시간 문자열 콤마 핸들링을 위해 공백 문자열로 세팅
                imgUrl: '',
                isActive: 1         // 🎯 [디버깅] 백엔드 NOT NULL 에러 방어용 상태 그릇 기본값 개통
            }
        };
    },

    // 🎯 [신규] 실시간 상태 변화 감지 엔진 레이더 가동
    computed: {
        /**
         * 화면의 폼 데이터가 최초 상태에서 단 한 글자 혹은 단 한 개의 칩이라도 바뀌었는지 감시
         * @returns {Boolean} 변경 사항이 있다면 true, 토씨 하나 안 틀리고 똑같다면 false 반환
         */
        isModified() {
            // 1. 새로운 사진 파일이 등록되었다면 무조건 변경된 것으로 간주
            if (this.uploadFile !== null) {
                return true;
            }

            // 2. 현재 상태의 폼 입력 데이터들을 스냅샷 규격과 동일하게 패키징 수행
            // (태그는 순서 변경으로 인한 오작동을 막기 위해 정렬 후 문자열화)
            const currentSnapshot = JSON.stringify({
                name: this.oneProductDetails.productName || '',
                large: this.oneProductDetails.largeCategory || '',
                medium: this.oneProductDetails.mediumCategory || '',
                details: this.oneProductDetails.productDetails || '',
                price: this.oneProductDetails.originalPrice || '',
                deposit: this.oneProductDetails.deposit || '',
                tags: [...this.selectedTags].sort()
            });

            // 3. 최초 박제했던 원본 스냅샷 스트링과 정밀 대조 연산 처리
            return currentSnapshot !== this.originalSnapshot;
        }
    },

    methods: {
        /**
         * 입력창 천단위 콤마 실시간 변환 필터 매커니즘 (초기 로드 및 실시간 입력 공용)
         * @param {String} field - 'originalPrice' 또는 'deposit'
         */
        fnInputComma(field) {
            let value = String(this.oneProductDetails[field] || '');
            
            // 숫자만 제외하고 모든 문자 우선 제거
            value = value.replace(/[^0-9]/g, '');
            
            // 3자리마다 정규식을 통해 콤마(,) 추가 구문 사출
            value = value.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
            
            // 변환된 예쁜 콤마 문자열을 화면 데이터에 즉시 피드백
            this.oneProductDetails[field] = value;
        },

        /**
         * [AJAX] 컴포넌트 기동 시 백엔드의 카테고리 트리 사전을 독립 수급하는 파이프라인
         */
        loadCategoryTree() {
            let self = this;
            $.ajax({
                url: "/getCategoryTree.dox",
                dataType: "json",
                type: "POST",
                success: function(data) {
                    self.categoryTree = data;
                    console.log("📂 [Phase 1] 수정 폼 내부 카테고리 사전 수급 성공");
                    
                    // 사전 수급이 안전하게 완료된 후, 기존 데이터 상세조회를 체이닝 트리거합니다.
                    self.fnFetchDetail();
                }
            });
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
                    console.log("📂 [Phase 2] 기존 상품 상세 데이터 로드:", data);
                    self.oneProductDetails = data.info;

                    // 1. 금액 초기 콤마 주입 엔진 전격 가동
                    self.fnInputComma('originalPrice');
                    self.fnInputComma('deposit');

                    // 2. 백엔드가 준 대분류/중분류 정보를 기반으로 하위 칩 레이아웃 다이내믹 강제 개통
                    let large = self.oneProductDetails.largeCategory;
                    let medium = self.oneProductDetails.mediumCategory;

                    if (large && self.categoryTree[large] && self.categoryTree[large].mediums) {
                        self.availableMediums = self.categoryTree[large].mediums;
                    }
                    
                    if (large === '결혼' && medium && self.categoryTree['결혼'] && self.categoryTree['결혼'].tags && self.categoryTree['결혼'].tags[medium]) {
                        self.availableTags = self.categoryTree['결혼'].tags[medium];
                    }

                    // 3. 기존에 등록되어 있던 태그 배열 리스트를 selectedTags 그릇에 이식하여 활성화 불빛 점등
                    if (data.tagList && Array.isArray(data.tagList)) {
                        self.selectedTags = [...data.tagList];
                    } else if (typeof self.oneProductDetails.tag === 'string') {
                        try {
                            self.selectedTags = JSON.parse(self.oneProductDetails.tag);
                        } catch (e) {
                            self.selectedTags = [];
                        }
                    }

                    // 🎯 [신규 장착] 모든 초기 데이터 바인딩 및 불빛 점등이 끝난 '태초의 완벽한 상태'를 스냅샷으로 영구 박제
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
         * 대분류 칩 클릭 처리 단자
         * @param {String} largeName - '결혼', '가족행사', '친구와함께'
         */
        selectLargeCategory(largeName) {
            this.oneProductDetails.largeCategory = largeName;
            
            // 데이터 무결성을 위해 하위 서랍 정보 전면 초기화 소멸
            this.oneProductDetails.mediumCategory = '';
            this.availableTags = [];
            this.selectedTags = [];

            if (this.categoryTree[largeName] && this.categoryTree[largeName].mediums) {
                this.availableMediums = this.categoryTree[largeName].mediums;
            } else {
                this.availableMediums = [];
            }
        },

        /**
         * 중분류 칩 클릭 처리 단자
         * @param {String} mediumName - '스튜디오', '드레스', '메이크업' 등
         */
        selectMediumCategory(mediumName) {
            this.oneProductDetails.mediumCategory = mediumName;
            
            // 중분류 스위칭 시 기존 선택 태그 내역 초기화
            this.selectedTags = [];

            if (this.oneProductDetails.largeCategory === '결혼') {
                if (this.categoryTree['결혼'] && this.categoryTree['결혼'].tags && this.categoryTree['결혼'].tags[mediumName]) {
                    this.availableTags = this.categoryTree['결혼'].tags[mediumName];
                } else {
                    this.availableTags = [];
                }
            } else {
                this.availableTags = [];
            }
        },

        /**
         * 태그 칩 활성화 및 최대 3개 상한 강제 차단막 제어 매커니즘
         * @param {String} tagName - 선택되거나 해제될 태그 키워드 문자열
         */
        toggleTagSelection(tagName) {
            let index = this.selectedTags.indexOf(tagName);
            if (index > -1) {
                this.selectedTags.splice(index, 1);
            } else {
                if (this.selectedTags.length >= 3) {
                    return;
                }
                this.selectedTags.push(tagName);
            }
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
         * [AJAX] 등록 폼 스펙과 100% 동기화된 수정한 상품 정보 전송 매커니즘
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

            // 🎯 [조건 충족] 새 이미지 파일이 명시적으로 첨부되었을 때만 전송 객체에 탑재 (미첨부 시 기존 사진 원형 보존)
            if (this.uploadFile) {
                formData.append("file", this.uploadFile);
            }
            
            // 콤마(,)가 섞여있는 문자열에서 모든 콤마를 제거하여 완벽한 정수형 데이터로 정제
            let pureOriginalPrice = String(this.oneProductDetails.originalPrice).replace(/,/g, '');
            let pureDeposit = String(this.oneProductDetails.deposit).replace(/,/g, '');

            // 등록 폼 스펙 규격 명세에 1:1 결합 매핑
            formData.append("productNo", this.oneProductDetails.productNo);
            formData.append("productName", this.oneProductDetails.productName);
            formData.append("productDetails", this.oneProductDetails.productDetails);
            
            formData.append("originalPrice", pureOriginalPrice ? Number(pureOriginalPrice) : 0);
            formData.append("deposit", pureDeposit ? Number(pureDeposit) : 0);
            
            formData.append("largeCategory", this.oneProductDetails.largeCategory);
            formData.append("mediumCategory", this.oneProductDetails.mediumCategory);

			// 🎯 [이 위치에 딱 한 줄 추가] 백엔드 upload 메서드 규격 정렬을 위한 userId 적재
			formData.append("userId", window.SESSION_ID);
						
            // 🎯 [디버깅 추가 안전장치 1] 기존 로드된 isActive 값 유실 차단 (값이 없을 시 1로 백업 부동 처리)
            let activeStatus = this.oneProductDetails.isActive !== undefined ? this.oneProductDetails.isActive : 1;
            formData.append("isActive", activeStatus);

            // 🎯 [디버깅 추가 안전장치 2] 새 사진을 안 올렸을 때 기존 이미지 URL이 널로 덮어써져 폭파되는 현상 원천 차단
            formData.append("imgUrl", this.oneProductDetails.imgUrl || '');

            // 유저님이 최종적으로 칩 버튼을 눌러 확정한 태그 배열 수급 포장 (uniqueNewTagsOnly 키로 다중 적재)
            if (this.selectedTags.length > 0) {
                this.selectedTags.forEach(tag => {
                    formData.append("uniqueNewTagsOnly", tag);
                });
            }

            // AJAX 업데이트 통신선 개통
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
            this.originalSnapshot = ''; // 스냅샷 백업 주머니 해제
            this.oneProductDetails = {
                productNo: '', productName: '', largeCategory: '', mediumCategory: '',
                productDetails: '', originalPrice: '', deposit: '', imgUrl: '', isActive: 1
            };
            this.$emit('back');
        }
    },

    // 폼이 무대에 활성화되는 최초의 찰나 마스터 사전 수급을 기점으로 비동기 동기화 톱니바퀴 구동
    mounted() {
        this.loadCategoryTree();
    }
};