/**
 * ==========================================================================
 * [InquirySectionComponent] 문의 관리 전용 독립 서브 컴포넌트 객체
 * ==========================================================================
 */
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

    // 2. 메인에 있던 문의 페이징 연산부 고도화 및 최대 3개 동적 슬라이더 계산식 증설
    computed: {
        fnPaginatedInquiry() {
            if (!this.inquiryList) return [];
            let start = this.currentPage - 1;
            let end = start + 1; // 1개 스케일 루프 유지
            return this.inquiryList.slice(start, end);
        },
        // 토탈 문의 페이지 수 정밀 연산 동기화
        totalInquiryPages() {
            return this.inquiryList ? this.inquiryList.length : 0;
        },
        /**
         * 🎯 현재 문의 페이지 번호를 기점으로 상시 최대 3개의 번호 블록만 유연하게 다스리는 슬라이딩 수식
         * @returns {Array} [1, 2, 3] 구조의 유동 인덱스 주머니
         */
        visibleInquiryPageNumbers() {
            const total = this.totalInquiryPages;
            const current = this.currentPage;
            
            if (!total) return [];
            
            // 만약 총 페이지 수가 3개 이하로 작다면 전체 페이지 번호를 그대로 리턴
            if (total <= 3) {
                let pages = [];
                for (let i = 1; i <= total; i++) {
                    pages.push(i);
                }
                return pages;
            }
            
            // 현재 보고 있는 번호를 중심으로 좌우 스코프 전개
            let start = current - 1;
            let end = current + 1;
            
            // 양 끝점 포지셔닝 이탈 방지 가드 레일
            if (start < 1) {
                start = 1;
                end = 3;
            } else if (end > total) {
                end = total;
                start = total - 2;
            }
            
            let pages = [];
            for (let i = start; i <= end; i++) {
                pages.push(i);
            }
            return pages;
        }
    },

    // 3. 문의 관련 함수 및 신규 화살표 핸들러 단자 증설
    methods: {
        fnThumbnail(i) {
            if (!this.inquiryList || this.inquiryList.length === 0) return '';
            let found = this.inquiryList.find(p => p.productName === i.productName);
            return found ? found.imgUrl : '';
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
                    // 백엔드가 null이나 누락 필드를 던지더라도 강제로 빈 배열([])을 보존케 마킹!
                    self.inquiryList = data.list || [];
                },
                error: function() {
                    self.inquiryList = [];
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
                        self.inquiryAnswer.answerNo = data.info.answerNo || '';
                        self.inquiryAnswer.answerContents = data.info.answerContents || '';
                        
                        // 시스템 숫자 혹은 문자 '0'이 빈칸('')으로 날아가지 않도록 안전핀 장착!
                        self.inquiryAnswer.inquiryAns = (data.info.inquiryAns !== undefined && data.info.inquiryAns !== null) ? data.info.inquiryAns : '';
                        
                        // 💡 [세션 ID 연동 가동] 답변자 기본 명세에 가짜 문자대신 로그인한 진짜 업체 세션 ID(sunsu09)가 뜨도록 사전 매립
                        self.inquiryAnswer.ansUserId = data.info.ansUserId || window.SESSION_ID;
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
                inquiryAns: self.inquiryAnswer.inquiryAns,
                
                // 💡 [외래키 원천 제로 박멸 구간] 유저가 입력창에 장난으로 3을 적었든 홍길동을 적었든 상관없이,
                // 실제 DB 알림 원격 시스템으로 쏴줄 값은 무조건 세션 로그인 대장 ID인 window.SESSION_ID(sunsu09)로 강제 복사 치환 전송!
                ansUserId: window.SESSION_ID
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
        },
        // 왼쪽 화살표(◀) 단자 무빙 처리 액션
        fnPrevPage() {
            if (this.currentPage > 1) {
                this.currentPage--;
            }
        },
        // 오른쪽 화살표(▶) 단자 무빙 처리 액션
        fnNextPage() {
            if (this.currentPage < this.totalInquiryPages) {
                this.currentPage++;
            }
        }
    },

    // 4. 문의 관리 탭이 딱 클릭되어 화면에 그려지는 순간 스스로 목록 조회!
    mounted() {
        this.fnInquiryProduct();
    }
};