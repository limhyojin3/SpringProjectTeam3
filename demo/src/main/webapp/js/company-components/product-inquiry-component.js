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
            
            $.ajax({
                url: "/addInquiryProduct.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    if (data.result == 'success') {
                        alert('문의가 등록되었습니다!');
                        self.title = '';
                        self.contents = '';
                        self.$emit('success');
                    } else {
                        alert("문의 등록 실패! 서버 오류입니다");
                    }
                }
            });
        }
    }
};

// 2️⃣ 나의 문의 리스트 컴포넌트 객체 (자체 목록 조회 통신 및 3칸 유동 슬라이딩 페이징 엔진)
const myInquiryListComponent = {
    template: '#my-inquiry-list-template',
    data() {
        return {
            inquiryList: [],
            currentPage: 1,
            itemsPerPage: 5
        };
    },
    computed: {
        totalPages() {
            return Math.ceil(this.inquiryList.length / this.itemsPerPage);
        },
        paginatedInquiryList() {
            const start = (this.currentPage - 1) * this.itemsPerPage;
            const end = start + this.itemsPerPage;
            return this.inquiryList.slice(start, end);
        },
        visiblePages() {
            const total = this.totalPages;
            const current = this.currentPage;
            
            if (total <= 3) {
                let pages = [];
                for (let i = 1; i <= total; i++) {
                    pages.push(i);
                }
                return pages;
            }
            
            if (current <= 1) {
                return [1, 2, 3];
            } else if (current >= total) {
                return [total - 2, total - 1, total];
            } else {
                return [current - 1, current, current + 1];
            }
        }
    },
    methods: {
        fnGetMyInquiryList() {
            let loginId = window.SESSION_ID;
            if (!loginId || loginId === "") {
                return;
            }
            let self = this;
            let param = { userId: loginId };
            
            $.ajax({
                url: "/getMyInquiryList.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    if (data.result == 'success') {
                        if (!data.list) {
                            self.inquiryList = [];
                            return;
                        }
                        
                        self.inquiryList = data.list.map(p => {
                            return {
                                ...p,
                                inquiryAns: p.inquiryAns != null ? String(p.inquiryAns) : '0'
                            };
                        });
                        
                        self.currentPage = 1;
                    } else {
                        alert("문의 내역을 불러오지 못했습니다.");
                    }
                }
            });
        },
        fnChangePage(page) {
            this.currentPage = page;
            window.scrollTo({ top: 0, behavior: 'smooth' });
        },
        fnPrevPage() {
            if (this.currentPage > 1) {
                this.currentPage--;
                window.scrollTo({ top: 0, behavior: 'smooth' });
            }
        },
        fnNextPage() {
            if (this.currentPage < this.totalPages) {
                this.currentPage++;
                window.scrollTo({ top: 0, behavior: 'smooth' });
            }
        }
    },
    mounted() {
        this.fnGetMyInquiryList();
    }
};

// 3️⃣ 문의 상세 보기 컴포넌트 객체 (자체 답변 조회 통신)
const inquiryDetailComponent = {
    template: '#inquiry-detail-template',
    props: ['inquiry'],
    data() {
        return {
            localInquiry: {}
        };
    },
    created() {
        this.localInquiry = { ...this.inquiry };
    },
    methods: {
        fnGetInquiryAnswer() {
            if (this.localInquiry.inquiryAns !== '1') return;
            
            let self = this;
            let param = { inquiryNo: self.localInquiry.inquiryNo };
            
            $.ajax({
                url: "/getInquiry1Answer.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    if (data.result === "success") {
                        self.localInquiry.answerContents = data.info.answerContents;
                        self.localInquiry.ansCompany = data.info.userId;
                        // 💡 버그 척결 핵심: 누락되었던 답변 날짜(answerDate) 바인딩선을 복구하여 정상 주머니에 이식 완료
                        self.localInquiry.answerDate = data.info.answerDate;
                        // Vue의 반응형 렌더링을 확실하게 보장하기 위한 강제 오브젝트 갱신 트리거
                        self.localInquiry = { ...self.localInquiry };
                    } else {
                        alert("답변 세부 정보를 가져오지 못했습니다.");
                    }
                }
            });
        }
    },
    mounted() {
        this.fnGetInquiryAnswer();
    }
};