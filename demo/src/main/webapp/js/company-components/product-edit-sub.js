/**
 * ==========================================================================
 * [ProductEditSub] 기등록 상품 수정 - 100% 완전 자립형 독립 서브 컴포넌트 객체
 * ==========================================================================
 */
const ProductEditSub = {
    template: '#product-edit-sub-template',
    
    // 부모 라우터관제소에게는 오직 정밀 타격할 상품 일련번호 딱 하나만 무역 창구로 수급받음
    props: ['productNo'],

    // 오직 상품 수정 폼에만 귀속 봉인되는 독립 독점 데이터 주머니 완공
    data() {
        return {
            category: ["스튜디오", "드레스", "메이크업"],
            previewUrl: null,
            uploadFile: null,
            oneProductDetails: {
                productNo: '', proType: [], productName: '', productDetails: '',
                originalPrice: '', imgUrl: '', deposit: 0, tag: []
            },
            tagMap: { input1: '', input2: '', input3: '', input4: '', input5: '' },
            serverTagList: []
        };
    },

    computed: {
        tagMapToList() {
            return Object.values(this.tagMap).filter(tag => tag.trim() !== "");
        },
        newTagsOnly() {
            if (!this.serverTagList) return this.tagMapToList;
            return this.tagMapToList.filter(t => !this.serverTagList.includes(t));
        }
    },

    methods: {
        // [AJAX] 수정 페이지 진입 시 자식 스스로 백엔드 직통 단건 상세 데이터 파싱 로드
        fnFetchDetail() {
            let self = this;
            let param = {
                userid: window.SESSION_ID,
                productNo: this.productNo // props로 수급된 번호 매핑
            };
            $.ajax({
                url: "http://localhost:8080/productDetail.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    console.log(data);
                    self.oneProductDetails = data.info;
                    self.serverTagList = data.tagList;

                    // 한글 카테고리 뷰 정화 배열 복원 디코딩
                    if (typeof self.oneProductDetails.proType === 'string') {
                        try {
                            let rawArray = JSON.parse(self.oneProductDetails.proType);
                            self.oneProductDetails.proType = rawArray.map(val => {
                                if (val === 'MAKEUP') return '메이크업';
                                if (val === 'DRESS') return '드레스';
                                if (val === 'STUDIO') return '스튜디오';
                                return val;
                            });
                        } catch (e) {
                            self.oneProductDetails.proType = [];
                        }
                    }
                    
                    // 문자열 태그 데이터를 개별 인풋 단자에 1:1 디매핑 분할 바인딩
                    if (typeof self.oneProductDetails.tag === 'string') {
                        try {
                            let rawArry = JSON.parse(self.oneProductDetails.tag);
                            self.oneProductDetails.tag = rawArry;
                            for (let i = 0; i < 5; i++) {
                                self.tagMap[`input${i + 1}`] = self.oneProductDetails.tag[i] || "";
                            }
                        } catch (e) {
                            self.oneProductDetails.tag = [];
                        }
                    }
                }
            });
        },

        // 수정할 이미지 파일 핸들링 미리보기 URL 기동
        fnFileChange(event) {
            const file = event.target.files[0];
            if (file) {
                this.uploadFile = file;
                this.previewUrl = URL.createObjectURL(file);
            }
        },

        // [AJAX] 수정한 상품 정보 및 신규 썸네일 FormData 패키지 수정 전송 통신 전체 내장 완료
        fnUpdateProduct() {
            let self = this;
            let formData = new FormData();

            if (this.uploadFile) {
                formData.append("file", this.uploadFile);
            }
            formData.append("productNo", this.oneProductDetails.productNo);
            formData.append("productName", this.oneProductDetails.productName);
            formData.append("productDetails", this.oneProductDetails.productDetails);
            formData.append("originalPrice", this.oneProductDetails.originalPrice);
            formData.append("deposit", this.oneProductDetails.deposit);
            formData.append("tag", JSON.stringify([...new Set(this.tagMapToList)]));
            formData.append("proType", JSON.stringify(this.oneProductDetails.proType));
            formData.append("uniqueNewTagsOnly", JSON.stringify([...new Set(this.newTagsOnly)]));

            $.ajax({
                url: "/upload.dox",
                type: "POST",
                data: formData,
                processData: false,
                contentType: false,
                success: function(data) {
                    console.log("서버가 보낸 데이터:", data);
                    let res = (typeof data === 'string') ? JSON.parse(data) : data;
                    if (res.result === "success") {
                        alert("상품 정보가 모두 수정되었습니다!");
                        self.$emit('back'); // 부모 관제소에게 완료 신호 사출
                    } else {
                        alert("서버 응답은 성공했지만, result가 success가 아닙니다.");
                    }
                }
            });
        },

        fnBackToList() {
            this.$emit('back');
        }
    },

    // 폼이 무대에 활성화되는 최초의 찰나 즉시 백엔드 단건 정보 정밀 파싱 구동
    mounted() {
        this.fnFetchDetail();
    }
};