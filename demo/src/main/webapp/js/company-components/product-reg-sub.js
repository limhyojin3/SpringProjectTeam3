/**
 * ==========================================================================
 * [ProductRegSub] 신규 상품 등록 - 100% 완전 자립형 독립 서브 컴포넌트 명세 객체
 * ==========================================================================
 */
const ProductRegSub = {
    template: '#product-reg-sub-template',
    
    // 🎯 부모가 데이터를 주지 않으며, 내부적으로도 쓰이지 않는 모든 props 라인 영구 제거
    props: [],
    
    // 🎯 속 시원한 완전 자립 캡슐화: 이 등록 화면 내에서만 자율 기동할 독점 칩 데이터 그릇 구성
    data() {
        return {
            // 💡 부모의 결합을 끊고 자식 고유의 독립 자산으로 원형 이식 수행
            initializedOneProductDetails: {
                productName: '',
                largeCategory: '',
                mediumCategory: '',
                productDetails: '',
                originalPrice: '', // 💡 실시간 문자열 콤마 핸들링을 위해 공백 문자열로 초기화
                deposit: ''       // 💡 실시간 문자열 콤마 핸들링을 위해 공백 문자열로 초기화
            },
            imgPreviewUrl: '',    // 💡 [추가] 부모를 거치지 않고 자식 스스로 제어하는 로컬 미리보기 이미지 주소 그릇
            categoryTree: {},     // /getCategoryTree.dox 가 반환할 대/중/태그 마스터 사전 객체
            availableMediums: [], // 현재 선택된 대분류 하위의 중분류 리스트 배열
            availableTags: [],    // 현재 선택된 중분류 하위의 리얼 마스터 태그 리스트 배열
            selectedTags: [],     // 사용자가 마우스 클릭으로 활성화한 최종 선택 태그 리스트 배열 (최대 3개 제한)
            uploadFile: null      // 사진 선택 시 바이너리가 머무를 내부 local 그릇
        };
    },

    methods: {
        /**
         * 💡 입력창 천단위 콤마 실시간 변환 필터 매커니즘
         * @param {String} field - 'originalPrice' 또는 'deposit'
         */
        fnInputComma(field) {
            let value = this.initializedOneProductDetails[field];
            
            // 1. 숫자만 제외하고 모든 문자(한글, 영문 등) 우선 제거
            value = value.replace(/[^0-9]/g, '');
            
            // 2. 3자리마다 정규식을 통해 콤마(,) 추가 구문 사출
            value = value.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
            
            // 3. 변환된 예쁜 콤마 문자열을 화면 데이터에 즉시 피드백
            this.initializedOneProductDetails[field] = value;
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
                    console.log("📂 [Phase 18] 등록 폼 내부 카테고리 사전 수급 성공:", self.categoryTree);
                }
            });
        },

        /**
         * 대분류 칩 클릭 처리 단자
         * @param {String} largeName - '결혼', '가족행사', '친구와함께'
         */
        selectLargeCategory(largeName) {
            // 유저님이 쓰시는 오리지널 상위 바인딩 주머니에 1:1 대입 사출
            this.initializedOneProductDetails.largeCategory = largeName;
            
            // 데이터 무결성을 위해 하위 서랍 정보 전면 초기화 소멸
            this.initializedOneProductDetails.mediumCategory = '';
            this.availableTags = [];
            this.selectedTags = [];

            // 트리 사전에서 해당하는 중분류 리스트를 색출하여 칩으로 노출
            if (this.categoryTree[largeName] && this.categoryTree[largeName].mediums) {
                this.availableMediums = this.categoryTree[largeName].mediums;
            } else {
                this.availableMediums = [];
            }
        },

        /**
         * 중분류 칩 클릭 처리 단자 (고려사항 축소를 위해 무조건 1개만 단일 토글)
         * @param {String} mediumName - '스튜디오', '드레스', '메이크업' 등
         */
        selectMediumCategory(mediumName) {
            this.initializedOneProductDetails.mediumCategory = mediumName;
            
            // 중분류 스위칭 시 기존 선택 태그 내역 초기화
            this.selectedTags = [];

            // [결혼] 대분류 상태일 때만 중분류 매핑 하위 태그들을 칩으로 개통 노출
            if (this.initializedOneProductDetails.largeCategory === '결혼') {
                if (this.categoryTree['결혼'] && this.categoryTree['결혼'].tags && this.categoryTree['결혼'].tags[mediumName]) {
                    this.availableTags = this.categoryTree['결혼'].tags[mediumName];
                } else {
                    this.availableTags = [];
                }
            } else {
                // 가족행사나 친구와함께 구역은 기획 규칙에 의거 태그 라인 원천 폐쇄 차단
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
                // 이미 담겨있다면 리스트에서 제외 (토글 해제)
                this.selectedTags.splice(index, 1);
            } else {
                // 새로 담으려 할 때 3개 가득 찬 상태면 물리 진입 차단 (UI 락 스킨과 연동)
                if (this.selectedTags.length >= 3) {
                    return;
                }
                this.selectedTags.push(tagName);
            }
        },

        /**
         * 💡 바이너리 사진 선택 제어 및 자립형 로컬 미리보기 URL 추출 매커니즘
         */
        fnFileChange(event) {
            const file = event.target.files[0];
            if (file) {
                this.uploadFile = file;
                // 브라우저의 내부 local 메모리 가상 주소를 추출하여 데이터 그릇에 바인딩 (서버 통신 없이 즉시 미리보기 가능)
                this.imgPreviewUrl = URL.createObjectURL(file);
                
                // 혹시 부모 관제소에서 감지해야 할 경우를 대비해 시그널 사출선은 원형 유지 보존
                this.$emit('file-change', event);
            }
        },

        /**
         * [AJAX] 최종 [상품 등록] 버튼 클릭 시 백엔드 /upload2.dox 관로 결합 전송 집행
         */
        fnInsertProduct() {
            // 정밀 유효성 선행 검사
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

            // 1. 이미지 물리 파일 바이너리 탑재
            if (this.uploadFile) {
                formData.append("file", this.uploadFile);
            }
            
            // 🎯 콤마(,)가 섞여있는 문자열에서 모든 콤마를 제거
            let pureOriginalPrice = String(this.initializedOneProductDetails.originalPrice).replace(/,/g, '');
            let pureDeposit = String(this.initializedOneProductDetails.deposit).replace(/,/g, '');

            // 2. 백엔드 Product.java 및 컨트롤러 파라미터 규격에 맞춰 1:1 문자열 정밀 필드 수급 포장
            formData.append("productName", this.initializedOneProductDetails.productName);
            formData.append("productDetails", this.initializedOneProductDetails.productDetails);
            
            // 정제된 문자열을 안전하게 정수형(Number)으로 캐스팅하여 탑재 (비어있을 시 0원 처리)
            formData.append("originalPrice", pureOriginalPrice ? Number(pureOriginalPrice) : 0);
            formData.append("deposit", pureDeposit ? Number(pureDeposit) : 0);
            
            formData.append("largeCategory", this.initializedOneProductDetails.largeCategory);
            formData.append("mediumCategory", this.initializedOneProductDetails.mediumCategory);
            formData.append("isActive", 1); // 즉시 노출 상태 고정 주입
            formData.append("userId", window.SESSION_ID); // 글로벌 세션키 이식

            // 3. 사용자가 칩으로 찍은 최대 3개 태그를 백엔드 규격 명세에 맞춰 이식
            if (this.selectedTags.length > 0) {
                this.selectedTags.forEach(tag => {
                    formData.append("uniqueNewTagsOnly", tag);
                });
            }

            // AJAX 독립 인서트 통신선 개통
            $.ajax({
                url: "/upload2.dox",
                type: "POST",
                data: formData,
                processData: false, // FormData 전송 필수
                contentType: false, // FormData 전송 필수
                success: function(data) {
                    let res = (typeof data === 'string') ? JSON.parse(data) : data;
                    if (res.result === "success") {
                        // 🎯 [문구 교정 완료] 장황한 칩 태그 언급을 걷어내고 유저님이 선택한 심플하고 세련된 멘트 탑재
                        alert("🎉 상품 등록이 성공적으로 완료되었습니다!");
                        self.fnBackToList(); // 성공 시 리스트 화면으로 안전 리턴 라우팅
                    } else {
                        alert("서버 응답 오류: " + res.message);
                    }
                },
                error: function() {
                    alert("서버 통신 중 장애가 발생했습니다.");
                }
            });
        },

        // 돌아가기 버튼 시그널 부모에게 에밋 위임
        fnBackToList() {
            // 내부 누적 버퍼 클리어
            this.selectedTags = [];
            this.availableMediums = [];
            this.availableTags = [];
            this.uploadFile = null;
            this.imgPreviewUrl = ''; // 미리보기 경로도 초기화
            
            // 독립 전환에 맞춰 폼에 적혀있던 데이터도 깔끔하게 초기화 후 복귀 (공백 문자열 초기화 무드 유지)
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
    },

    // 등록 폼 컴포넌트가 활성화되는 최초의 마운트 찰나 카테고리 트리 사전 자동 조회 트리거 점화
    mounted() {
        this.loadCategoryTree();
    }
};

// 상위 Vue 엔진에 로컬 수급용 객체로 공식 확정 바인딩
if (typeof app !== 'undefined') {
    // 부모 스크립트인 product-section-component.js 의 components 속성에서 매핑하여 사용하도록 유도
}