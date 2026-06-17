const InquirySectionComponent = {
    template: '#inquiry-section-template',
    
    // 1. 오직 문의 관리방에서만 쓰는 독립된 변수들
    data() {
        return {
            viewPage: 'main',
            currentPage: 1,
            inquiryList: [],
            inquiryDetails: {},
            inquiryAnswer: {
                inquiryNo: '',
                ansUserId: '',
                answerNo: '',
                answerContents: '',
                inquiryAns: ''
            }
        };
    },

    // 2. 메인에 있던 문의 페이징 computed 그대로 이사
    computed: {
        fnPaginatedInquiry() {
            let start = this.currentPage - 1;
            let end = start + 1;
            return this.inquiryList.slice(start, end);
        }
    },

    // 3. 메인에 있던 문의 관련 함수(Methods)들 그대로 이사
    methods: {
        fnThumbnail(i) {
            return this.inquiryList.find(p => p.productName === i.productName).imgUrl;
        },
        fnInquiryProduct() {
            let self = this;
            let param = {
                userId: window.SESSION_ID
            };
            $.ajax({
                url: "/getInquiryProductList.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    self.inquiryList = data.list;
                }
            });
        },
        fnAnswerToProductInquiry(i) {
            this.viewPage = 'answer';
            this.inquiryDetails = i;

            let self = this;
            let param = {
                inquiryNo: self.inquiryDetails.inquiryNo
            };
            $.ajax({
                url: "/getInquiryAnsYn.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    if (data.result === 'success') {
                        self.inquiryAnswer.inquiryNo = data.info.inquiryNo || '';
                        self.inquiryAnswer.ansUserId = data.info.ansUserId || '';
                        self.inquiryAnswer.answerNo = data.info.answerNo || '';
                        self.inquiryAnswer.answerContents = data.info.answerContents || '';
                        self.inquiryAnswer.inquiryAns = data.info.inquiryAns || '';
                    }
                }
            });
        },
        fnBacktoInquiry() {
            this.viewPage = 'main';
        },
        fnSaveAnswer() {
            if (!this.inquiryAnswer.ansUserId || this.inquiryAnswer.ansUserId.trim() === '') {
                alert("답변자를 작성해주세요!");
                return;
            }
            if (!this.inquiryAnswer.answerContents || this.inquiryAnswer.answerContents.trim() === '') {
                alert("답변내용을 작성해주세요!");
                return;
            }
            let self = this;
            let param = {
                inquiryNo: self.inquiryAnswer.inquiryNo,
                answerContents: self.inquiryAnswer.answerContents,
                ansUserId: self.inquiryAnswer.ansUserId,
                inquiryAns: self.inquiryAnswer.inquiryAns
            };
            $.ajax({
                url: "/addProductInquiryAnswer.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    if (data.result === 'success') {
                        alert("답변 등록/수정 완료!");
                        self.viewPage = 'main';
                        self.fnInquiryProduct(); // 답변 등록 후 목록 새로고침
                    } else {
                        alert("서버 오류!");
                    }
                }
            });
        }
    },

    // 4. 문의 관리 탭이 딱 클릭되어 화면에 그려지는 순간 스스로 목록 조회!
    mounted() {
        this.fnInquiryProduct();
    }
};