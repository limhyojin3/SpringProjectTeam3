/**
 * ==========================================================================
 * [ProductRegSub] 신규 상품 등록 - 100% 완전 자립형 독립 서브 컴포넌트 객체
 * ==========================================================================
 */
const ProductRegSub = {
    template: '#product-reg-sub-template',
    
    // 오직 상품 등록 폼에만 귀속 봉인되는 독점 데이터 주머니 완공
    data() {
        return {
            category: ["스튜디오", "드레스", "메이크업"],
            previewUrl: null,
            uploadFile: null,
            initializedOneProductDetails: {
                companyNo: '', productNo: '', proType: [], productName: '',
                productDetails: '', originalPrice: '', imgUrl: '', deposit: 0, tag: []
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
        // 브라우저 썸네일 미리보기 휘발성 주소 생성 단자
        fnFileChange(event) {
            const file = event.target.files[0];
            if (file) {
                this.uploadFile = file;
                this.previewUrl = URL.createObjectURL(file);
            }
        },

        // [AJAX] 신규 상품 정보 및 썸네일 이미지 등록 FormData 패키지 업로드 통신
        fnInsertProduct() {
            let self = this;
            let formData = new FormData();

            if (this.uploadFile) {
                formData.append("file", this.uploadFile);
            }
            formData.append("productNo", this.initializedOneProductDetails.productNo);
            formData.append("productName", this.initializedOneProductDetails.productName);
            formData.append("productDetails", this.initializedOneProductDetails.productDetails);
            formData.append("originalPrice", this.initializedOneProductDetails.originalPrice);
            formData.append("deposit", this.initializedOneProductDetails.deposit);
            formData.append("proType", JSON.stringify(this.initializedOneProductDetails.proType));
            formData.append("userId", window.SESSION_ID);
            formData.append("tag", JSON.stringify([...new Set(this.tagMapToList)]));
            formData.append("uniqueNewTagsOnly", JSON.stringify([...new Set(this.newTagsOnly)]));

            $.ajax({
                url: "/upload2.dox",
                type: "POST",
                data: formData,
                processData: false,
                contentType: false,
                success: function(data) {
                    console.log("서버가 보낸 데이터:", data);
                    let res = (typeof data === 'string') ? JSON.parse(data) : data;
                    if (res.result === "success") {
                        alert("상품 정보가 모두 등록되었습니다!");
                        self.$emit('back'); // 부모에게 리스트 화면으로 이동하라고 신호 전달
                    } else {
                        alert("서버 응답은 성공했지만, result가 success가 아닙니다.");
                    }
                }
            });
        },

        // 돌아가기 버튼
        fnBackToList() {
            this.$emit('back');
        }
    },

    // 등록 폼 기동 시 독자적으로 태그 목록 조회 AJAX 가동
    mounted() {
        let self = this;
        $.ajax({
            url: "/getTagList.dox",
            dataType: "json",
            type: "POST",
            data: {},
            success: function(data) {
                self.serverTagList = data.tagList;
            }
        });
    }
};