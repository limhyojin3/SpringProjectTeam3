const ProductSectionComponent = {
    template: '#product-section-template',

    // 1. 오직 상품 관리에서만 쓰는 독립된 변수(살림살이)들로 구성
    data() {
        return {
            productPage: 'list',
            productCurrentPage: 1,
            productPageSize: 5,
            registeredProductList: [], // 이제 리뷰 데이터와 섞이지 않는 내 손님 목록!
            oneProductDetails: {},
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

    // 2. 메인에 있던 상품 페이징 computed를 그대로 이사
    computed: {
        tagMapToList() {
            return Object.values(this.tagMap).filter(tag => tag.trim() !== "");
        },
        newTagsOnly() {
            if (!this.serverTagList) return this.tagMapToList;
            return this.tagMapToList.filter(t => !this.serverTagList.includes(t));
        },
        fnPaginatedProductList() {
            const start = (this.productCurrentPage - 1) * this.productPageSize;
            const end = start + this.productPageSize;
            return this.registeredProductList.slice(start, end);
        },
        totalProductPages() {
            return Math.ceil(this.registeredProductList.length / this.productPageSize);
        }
    },

    // 3. 메인 app에서 상품을 제어하던 AJAX 메서드들을 통째로 이사 (코드 수정 거의 없음!)
    methods: {
        fnProductList() {
            this.productCurrentPage = 1;
            let self = this;
            $.ajax({
                url: "http://localhost:8080/productList.dox",
                dataType: "json",
                type: "POST",
                data: { userid: window.SESSION_ID }, // 전역 세션ID 사용
                success: function(data) {
                    self.registeredProductList = data.list; // 이제 내 방의 변수에 저장!
                }
            });
        },
        fnEditPage(item) {
            let self = this;
            self.productPage = 'edit';

            let param = {
                userid: window.SESSION_ID,
                productNo: item.productNo //파라미터로 보내주면되는구나~
            };
            $.ajax({
                url: "http://localhost:8080/productDetail.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    console.log(data);
                    // 1. 일단 전체 데이터를 담습니다.
                    self.oneProductDetails = data.info;//덮어씌우기
                    self.serverTagList = data.tagList;

                    // 2. 문자열로 들어온 proType을 실제 배열로 변환합니다.
                    // 만약 데이터가 '["MAKEUP"]' 형태라면 JSON.parse를 써서 ["MAKEUP"] 배열로 만듭니다.
                    if (typeof self.oneProductDetails.proType === 'string') {
                        try {
                            let rawArray = JSON.parse(self.oneProductDetails.proType);//["MAKEUP" , "STUDIO"]

                            self.oneProductDetails.proType = rawArray.map(val => {
                                if (val === 'MAKEUP') {
                                    return '메이크업';
                                } else if (val === 'DRESS') {
                                    return '드레스';
                                } else if (val === 'STUDIO') {
                                    return '스튜디오';
                                } else {
                                    return val; // 혹시 모르는 값이 들어올 경우 원래 값을 유지
                                } //self.oneProductDetails.proType = ["메이크업", "스튜디오"]
                            })
                        } catch (e) {
                            // 혹시 JSON 형식이 아닐 경우를 대비해 빈 배열로 초기화하거나 예외 처리
                            self.oneProductDetails.proType = [];
                        }
                    }
                    if (typeof self.oneProductDetails.tag === 'string') {
                        try {
                            let rawArry = JSON.parse(self.oneProductDetails.tag);

                            self.oneProductDetails.tag = rawArry;

                            for (let i = 0;i < 5;i++) {
                                self.tagMap[`input${i + 1}`] = self.oneProductDetails.tag[i] || "";
                            }
                        } catch (e) {
                            self.oneProductDetails.tag = [];
                        }
                    }

                }
            });
        },
        fnRegPage() {
            this.oneProductDetails = {
                productNo: '',
                proType: [],
                productName: '',
                productDetails: '',
                originalPrice: '',
                imgUrl: '',
                deposit: 0,
                tag: []
            }
            for (let i = 0;i < 5;i++) {
                this.tagMap[`input${i + 1}`] = '';
            }
            this.initializedOneProductDetails = {
                ...this.initializedOneProductDetails,
                productName: '',
                proType: [],
                productDetails: '',
                originalPrice: '',
                deposit: 0
            }
            this.productPage = 'reg';

            let self = this;
            let param = {};
            $.ajax({
                url: "/getTagList.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    console.log(data);
                    self.serverTagList = data.tagList;
                }
            });
        },
        fnFileChange(event) {
            // 1. 이벤트가 일어난 대상(input)에서 선택된 파일들 중 첫 번째[0]를 가져와요.
            const file = event.target.files[0];

            if (file) {
                // 2. 진짜 파일 덩어리를 우리 변수에 쏙 넣어둡니다.
                this.uploadFile = file;

                // 3. 브라우저가 "이 파일 내가 잠깐 보여줄 수 있게 가짜 주소 만들어줄게!" 하는 기능이에요.
                this.previewUrl = URL.createObjectURL(file);

            }
        },
        fnUpdateProduct() {
            // 1. 택배 박스(FormData)를 하나 만듭니다.
            // 파일은 일반 텍스트가 아니라서 반드시 이 'FormData'라는 박스에 담아야 해요.
            let self = this;
            let formData = new FormData();

            // 1. 사진 파일 담기(선택했을 때만)
            if (this.uploadFile) {
                formData.append("file", this.uploadFile);
            }

            // 2. 다른 모든 정보들 싹 다 담기(자바의 변수명과 똑같이!)
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
                    console.log("서버가 보낸 데이터:", data); // [체크!] 이 데이터가 어떻게 생겼는지 확인

                    // 만약 data가 JSON 문자열로 넘어왔다면 파싱이 필요할 수도 있어요
                    let res = (typeof data === 'string') ? JSON.parse(data) : data;
                    //data가 string으로 넘어왓다면? 자바스크립트가 읽을수있게 객체로 바꿔주기(parse해주기)
                    if (res.result === "success") {
                        alert("상품 정보가 모두 수정되었습니다!");
                        console.log(res.message1);
                        window.location.href = "/partnerManagement.do";  //
                    } else {
                        alert("서버 응답은 성공했지만, result가 success가 아닙니다.");
                    }

                }
            })
        },
        fnInsertProduct() {
            // 1. 택배 박스(FormData)를 하나 만듭니다.
            // 파일은 일반 텍스트가 아니라서 반드시 이 'FormData'라는 박스에 담아야 해요.
            let self = this;
            let formData = new FormData();

            // 1. 사진 파일 담기(선택했을 때만)
            if (this.uploadFile) {
                formData.append("file", this.uploadFile);
            }

            // 2. 다른 모든 정보들 싹 다 담기(자바의 변수명과 똑같이!)
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
                    console.log("서버가 보낸 데이터:", data); // [체크!] 이 데이터가 어떻게 생겼는지 확인

                    // 만약 data가 JSON 문자열로 넘어왔다면 파싱이 필요할 수도 있어요
                    let res = (typeof data === 'string') ? JSON.parse(data) : data;
                    //data가 string으로 넘어왓다면? 자바스크립트가 읽을수있게 객체로 바꿔주기(parse해주기)
                    if (res.result === "success") {
                        alert("상품 정보가 모두 등록되었습니다!");
                        console.log(res.message1);
                        window.location.href = "/partnerManagement.do"; //
                    } else {
                        alert("서버 응답은 성공했지만, result가 success가 아닙니다.");
                    }

                }
            })
        },
        fnRemoveProduct(item) {  //item in productList
            if (confirm("정말 삭제하시겠습니까?")) {

                let self = this;
                let param = {
                    productNo: item.productNo
                };
                console.log(item);
                $.ajax({
                    url: "/productRemove.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function(data) {

                        alert(data.message);
                        location.href = "/partnerManagement.do"
                    }
                });
            } else {
                alert("삭제가 취소되었습니다.");
            }
        },
        fnBackToList() {
            this.tagMap = {};
            this.productPage = 'list'
            this.initializedOneProductDetails.deposit = 0;
            this.previewUrl = null;
        },
        uniqueNewTagsOnly() { return [...new Set(this.newTagsOnly)]; }
    },

    // 4. ⭐ 핵심: 상품 관리 화면이 딱 켜지는 순간, 스스로 첫 목록을 받아옴!
    mounted() {
        this.fnProductList();
    }
};