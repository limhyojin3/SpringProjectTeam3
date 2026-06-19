// 1️⃣ 상품 문의 작성 컴포넌트 객체 (자체 검증 및 저장 통신)
const productInquiryWriteComponent = {
    template: '#product-inquiry-write-template',
    props: ['product', 'sessionId'],
    data() {
        return {
            title: '',
            contents: ''
        };
    },
    methods: {
        submitInquiry() {
            if (!this.title.trim()) return alert("문의 제목을 입력해주세요!");
            if (!this.contents.trim()) return alert("문의 내용을 입력해주세요!");
            
            let loginId = this.sessionId;
            if (!loginId || loginId === "") {
                alert("로그인 해주세요!");
                return;
            }
            
            let self = this;
            let param = {
                userId: loginId,
                productNo: self.product.id,
                companyNo: self.product.companyNo,
                inquiryTitle: self.title,
                inquiryContents: self.contents
            };
            
            // 💡 부모창 소스코드에 있던 저장 AJAX 로직을 자식 내부로 완벽히 이사했습니다.
            $.ajax({
                url: "/addInquiryProduct.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    if (data.result == 'success') {
                        alert('문의가 등록되었습니다!');
                        self.title = '';    // 입력 폼 초기화
                        self.contents = ''; // 입력 폼 초기화
                        // 💡 부모에게 성공 신호를 보내어 목록 화면으로 복귀하도록 통제합니다.
                        self.$emit('success');
                    } else {
                        alert("문의 등록 실패! 서버 오류입니다");
                    }
                }
            });
        }
    }
};

// 2️⃣ 나의 문의 리스트 컴포넌트 객체 (자체 목록 조회 통신)
const myInquiryListComponent = {
    template: '#my-inquiry-list-template',
    data() {
        return {
            // 💡 부모 데이터 주머니를 빌리지 않고, 리스트 데이터를 자식이 직접 소유(응집도 최상)
            inquiryList: []
        };
    },
    methods: {
        fnGetMyInquiryList() {
            let loginId = window.SESSION_ID;
            if (!loginId || loginId === "") {
                return;
            }
            let self = this;
            let param = { userId: loginId };
            
            // 💡 부모창에 있던 목록 조회 AJAX 로직을 이쪽으로 이사했습니다.
            $.ajax({
                url: "/getMyInquiryList.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    if (data.result == 'success') {
                        self.inquiryList = data.list;
                    } else {
                        alert("문의 내역을 불러오지 못했습니다.");
                    }
                }
            });
        }
    },
    mounted() {
        // 💡 컴포넌트 무대가 활성화되는 순간 스스로 리스트 조회를 수행합니다.
        this.fnGetMyInquiryList();
    }
};

// 3️⃣ 문의 상세 보기 컴포넌트 객체 (자체 답변 조회 통신)
const inquiryDetailComponent = {
    template: '#inquiry-detail-template',
    props: ['inquiry'],
    data() {
        return {
            // 💡 단방향 데이터 흐름을 준수하기 위해 props를 복사하여 안전하게 내부 상태로 다룹니다.
            localInquiry: {}
        };
    },
    created() {
        // 컴포넌트 초기화 시점에 안전하게 얕은 복사본을 만듭니다.
        this.localInquiry = { ...this.inquiry };
    },
    methods: {
        fnGetInquiryAnswer() {
            // 답변 완료('1') 상태인 경우에만 추가로 답변 세부 데이터 AJAX 조회를 진행합니다.
            if (this.localInquiry.inquiryAns !== '1') return;
            
            let self = this;
            let param = { inquiryNo: self.localInquiry.inquiryNo };
            
            // 💡 부모창에 얽혀있던 답변 세부조회 AJAX 로직을 이쪽으로 이사했습니다.
            $.ajax({
                url: "/getInquiry1Answer.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    if (data.result === "success") {
                        // 자식 고유 상태 객체에 서버에서 가져온 내용을 결합하여 화면을 리렌더링합니다.
                        self.localInquiry.answerContents = data.info.answerContents;
                        self.localInquiry.ansCompany = data.info.userId;
                    } else {
                        alert("답변 세부 정보를 가져오지 못했습니다.");
                    }
                }
            });
        }
    },
    mounted() {
        // 💡 상세창이 열리는 즉시 답변 조회를 트리거합니다.
        this.fnGetInquiryAnswer();
    }
};