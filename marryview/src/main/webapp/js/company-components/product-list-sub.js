/**
 * ==========================================================================
 * [ProductListSub] 상품 목록 전용 - 100% 완전 자립형 독립 서브 컴포넌트 객체
 * ==========================================================================
 */
const ProductListSub = {
    template: '#product-list-sub-template',
    
    // 🎯 속 시원한 완전 자립 격리: 목록 전용의 데이터 그릇을 자식 내부 고유 영역으로 봉인
    data() {
        return {
            registeredProductList: [],
            productCurrentPage: 1,
            productPageSize: 4 // 프리미엄 카드 크기를 완벽 보존한 채 4개 스케일 다운 피팅 규격 확정
        };
    },

    // 🎯 4단 페이지네이션 슬라이싱 연산 수식 자식 전독점 탑재 완료
    computed: {
        // 정확히 4개 단위씩 실시간 분할 컷팅하여 화면 카드를 사출하는 동적 리스트
        fnPaginatedProductList() {
            const start = (this.productCurrentPage - 1) * this.productPageSize;
            const end = start + this.productPageSize;
            return this.registeredProductList.slice(start, end);
        },
        // 토탈 상품 개수를 4로 나누어 인덱스 넘버를 정밀 연산 동기화하는 식
        totalProductPages() {
            return Math.ceil(this.registeredProductList.length / this.productPageSize);
        },
        /**
         * 🎯 [신규 추가 고도화] 현재 페이지를 기점으로 상시 최대 3개의 번호만 유연하게 계산해 뿜어내는 슬라이더 엔진
         * @returns {Array} [1, 2, 3] 또는 [2, 3, 4] 형태의 정수형 넘버링 주머니
         */
        visiblePageNumbers() {
            const total = this.totalProductPages;
            const current = this.productCurrentPage;
            
            // 만약 총 페이지 수가 3개 이하로 작다면 전체 페이지 번호를 그대로 리턴 안전 처리
            if (total <= 3) {
                let pages = [];
                for (let i = 1; i <= total; i++) {
                    pages.push(i);
                }
                return pages;
            }
            
            // 현재 활성화된 페이지를 중심으로 앞뒤 구역 설정 연산 기동
            let start = current - 1;
            let end = current + 1;
            
            // 극단적인 포지션(첫 페이지 구역 또는 끝 페이지 구역) 도달 시 좌우 밸런스 강제 조정 쉴드
            if (start < 1) {
                start = 1;
                end = 3;
            } else if (end > total) {
                end = total;
                start = total - 2;
            }
            
            // 확정된 바운더리 범위를 기반으로 3개 배열 순수 인출
            let pages = [];
            for (let i = start; i <= end; i++) {
                pages.push(i);
            }
            return pages;
        }
    },

    methods: {
        // [AJAX] 상품 전체 목록 로드 파이프라인 (파트너 전역 세션ID 매핑 직통 가동)
        fnProductList() {
            let self = this;
            $.ajax({
                url: "http://localhost:8080/productList.dox",
                dataType: "json",
                type: "POST",
                data: { userid: window.SESSION_ID },
                success: function(data) {
                    self.registeredProductList = data.list;
                }
            });
        },

        // [AJAX] 선택 상품 목록 내부 즉시 영구 삭제 파이프라인
        fnRemoveProduct(item) {
            if (confirm("정말 삭제하시겠습니까?")) {
                let self = this;
                let param = {
                    productNo: item.productNo
                };
                $.ajax({
                    url: "/productRemove.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function(data) {
                        alert(data.message);
                        self.productCurrentPage = 1;
                        self.fnProductList(); // 부모 간섭 없이 자식 데이터만 깔끔하게 새로고침!
                    }
                });
            } else {
                alert("삭제가 취소되었습니다.");
            }
        },

        // ◀ 화살표 무빙 제어
        fnPrevPage() {
            if (this.productCurrentPage > 1) {
                this.productCurrentPage--;
            }
        },
        // ▶ 화살표 무빙 제어
        fnNextPage() {
            if (this.productCurrentPage < this.totalProductPages) {
                this.productCurrentPage++;
            }
        },
        // 상위 부모 라우터 관제소로 화면 상태값 변경 액션만 위임 통보하는 에밋 규격
        fnRegPage() {
            this.$emit('go-reg');
        },
        fnEditPage(item) {
            this.$emit('go-edit', item.productNo);
        }
    },

    // 활성화되는 순간 자가 구동 목록 AJAX 트리거 점화
    mounted() {
        this.fnProductList();
    }
};