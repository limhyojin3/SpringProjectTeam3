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

// 2️⃣ 나의 문의 리스트 컴포넌트 객체 (자체 목록 조회 통신 및 3칸 유동 슬라이딩 페이징 엔진)
const myInquiryListComponent = {
    template: '#my-inquiry-list-template',
    data() {
        return {
            // 부모 데이터 주머니를 빌리지 않고, 리스트 데이터를 자식이 직접 소유
            inquiryList: [],
            // 페이징 컨트롤 타워 신설: 현재 페이지(기본값 1) 및 한 페이지당 노출 규격(5개)
            currentPage: 1,
            itemsPerPage: 5
        };
    },
    computed: {
        // 페이징 엔진 A: 전체 문의 글 수를 기반으로 도출 가능한 최종 한계 페이지 수 실시간 연산
        totalPages() {
            return Math.ceil(this.inquiryList.length / this.itemsPerPage);
        },
        
        // 페이징 엔진 B: 원본 리스트에서 현재 활성화된 페이지 범위의 딱 5개 카드만 무중력 슬라이싱 방출
        paginatedInquiryList() {
            const start = (this.currentPage - 1) * this.itemsPerPage;
            const end = start + this.itemsPerPage;
            return this.inquiryList.slice(start, end);
        },
        
        // 페이징 엔진 C (핵심): 유저님이 정밀 조율해주신 '3칸 제한 정중앙 고정 슬라이딩 윈도우 알고리즘'
        visiblePages() {
            const total = this.totalPages;
            const current = this.currentPage;
            
            // 1. 전체 페이지 수가 제약 규격(3개) 이하일 때는 존재하는 만큼만 리턴
            if (total <= 3) {
                let pages = [];
                for (let i = 1; i <= total; i++) {
                    pages.push(i);
                }
                return pages;
            }
            
            // 2. 전체 페이지 수가 3개를 초과할 때 임계점 한계 방어 및 실시간 중앙 수감 작동
            if (current <= 1) {
                // 시작 한계점 방어: 1페이지 혹은 그 이하 정체 시 무조건 초기 스케일 고정
                return [1, 2, 3];
            } else if (current >= total) {
                // 종료 한계점 방어: 마지막 끝자락 페이지 도달 시 이전 2개 번호 포함 백포지셔닝 고정
                return [total - 2, total - 1, total];
            } else {
                // 일반 비행 궤도: 유저님 지침대로 현재 보고 있는 페이지 번호를 무조건 정중앙에 강제 수감
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
            
            // 부모창에 있던 목록 조회 AJAX 로직
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
                        
                        // 💡 타입 불일치 버그 파쇄 코어 레일: 
                        // 자바 DTO 캐스팅 간섭으로 인해 정수형(1, 0)으로 도착하는 값을 자바스크립트 수신 즉시
                        // 강제 텍스트 디코딩 처리(String)하여 JSP의 strict형 조건식(=== '1')과 100% 연동 동기화 집행
                        self.inquiryList = data.list.map(p => {
                            return {
                                ...p,
                                inquiryAns: p.inquiryAns != null ? String(p.inquiryAns) : '0'
                            };
                        });
                        
                        // 데이터 갱신 시 안전을 위해 페이지 포인터를 1페이지로 자동 리셋
                        self.currentPage = 1;
                    } else {
                        alert("문의 내역을 불러오지 못했습니다.");
                    }
                }
            });
        },
        
        // 인터랙션 라우터: 특정 숫자 버튼 터치 시 부드러운 스크롤 탑 모션과 함께 페이지 포인팅 변경
        fnChangePage(page) {
            this.currentPage = page;
            window.scrollTo({ top: 0, behavior: 'smooth' });
        },
        
        // 인터랙션 라우터: 이전 화살표 (<) 제어 단자
        fnPrevPage() {
            if (this.currentPage > 1) {
                this.currentPage--;
                window.scrollTo({ top: 0, behavior: 'smooth' });
            }
        },
        
        // 인터랙션 라우터: 다음 화살표 (>) 제어 단자
        fnNextPage() {
            if (this.currentPage < this.totalPages) {
                this.currentPage++;
                window.scrollTo({ top: 0, behavior: 'smooth' });
            }
        }
    },
    mounted() {
        // 컴포넌트 무대가 활성화되는 순간 스스로 리스트 조회를 수행합니다.
        this.fnGetMyInquiryList();
    }
};

// 3️⃣ 문의 상세 보기 컴포넌트 객체 (자체 답변 조회 통신)
const inquiryDetailComponent = {
    template: '#inquiry-detail-template',
    props: ['inquiry'],
    data() {
        return {
            // 단방향 데이터 흐름을 준수하기 위해 props를 복사하여 안전하게 내부 상태로 다룹니다.
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
            
            // 부모창에 얽혀있던 답변 세부조회 AJAX 로직을 이쪽으로 이사했습니다.
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
        // 상세창이 열리는 즉시 답변 조회를 트리거합니다.
        this.fnGetInquiryAnswer();
    }
};