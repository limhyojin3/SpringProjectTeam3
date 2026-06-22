/**
 * ==========================================================================
 * [ProductMutateService] 상품 관리 - 상세 파싱, 입력 폼 제어 및 FormData 파일 업로드
 * ==========================================================================
 */
const ProductMutateService = {
    // 수정 페이지 진입 시 복합 데이터 복원 디코딩 레일
    fnEditPage(item) {
        let self = this;
        self.productPage = 'edit';
        let param = {
            userid: window.SESSION_ID,
            productNo: item.productNo
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

                // 문자열로 유입된 카테고리(proType)를 프론트엔드 한글 뷰 배열로 안전 정화
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
                
                // 문자열 태그 데이터를 개별 인풋 단자에 1:1 디매핑 바인딩
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

    // 신규 등록 폼 클리어 및 초기화 레일
    fnRegPage() {
        this.oneProductDetails = {
            productNo: '', proType: [], productName: '', productDetails: '',
            originalPrice: '', imgUrl: '', deposit: 0, tag: []
        };
        for (let i = 0; i < 5; i++) {
            this.tagMap[`input${i + 1}`] = '';
        }
        this.initializedOneProductDetails = {
            ...this.initializedOneProductDetails,
            productName: '', proType: [], productDetails: '', originalPrice: '', deposit: 0
        };
        this.productPage = 'reg';

        let self = this;
        $.ajax({
            url: "/getTagList.dox",
            dataType: "json",
            type: "POST",
            data: {},
            success: function(data) {
                console.log(data);
                self.serverTagList = data.tagList;
            }
        });
    },

    // 썸네일 파일 업로드 시 브라우저 가짜 휘발성 미리보기 URL 생성기
    fnFileChange(event) {
        const file = event.target.files[0];
        if (file) {
            this.uploadFile = file;
            this.previewUrl = URL.createObjectURL(file);
        }
    },

    // 기존 상품 정보 및 썸네일 이미지 수정 FormData 패키지 업로드 통신
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
        formData.append("uniqueNewTagsOnly", this.uniqueNewTagsOnly());

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
                    window.location.href = "/partnerManagement.do";
                } else {
                    alert("서버 응답은 성공했지만, result가 success가 아닙니다.");
                }
            }
        });
    },

    // 신규 상품 정보 및 썸네일 이미지 등록 FormData 패키지 업로드 통신
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
        formData.append("uniqueNewTagsOnly", this.uniqueNewTagsOnly());

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
                    window.location.href = "/partnerManagement.do";
                } else {
                    alert("서버 응답은 성공했지만, result가 success가 아닙니다.");
                }
            }
        });
    },

    uniqueNewTagsOnly() { return [...new Set(this.newTagsOnly)]; }
};