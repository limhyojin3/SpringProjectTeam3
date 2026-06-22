const productListComponent = {
    template: '#product-list-template',
    // 부모 컴포넌트가 DB 조회를 거쳐 던져주는 결과 목록을 수신합니다.
    props: ['productList', 'productTag'], 
    data() {
        return {
            selectLargeCategory: '결婚', // 초기 대분류 선택 기본값 ('결혼')
            selectLargeCategory: '결혼', // 한글 깨짐 및 인지 방어용 명확한 초기값
            selectCategory: '',         // 중분류 단일 선택 상태값 (라디오 버튼 연동)
            selectTags: [],             // 선택된 소분류 태그 배열 (최대 2개 제한)
            
            // 💡 하드코딩 척결: 복잡하던 카테고리 맵 구조를 지우고 빈 객체로 초기화하여 DB 수혈을 대기합니다.
            categoriesData: {}
        };
    },
    created() {
        // Vue 인스턴스의 스코프를 자바스크립트 콜백 내부로 안전하게 전달하기 위해 변수 지정
        var self = this;
        
        // 💡 고도화 핵심: 익숙하신 jQuery $.ajax 문법을 통해 페이지 로드 즉시 백엔드 동적 트리 단자를 노크합니다.
        $.ajax({
            url: '/getCategoryTree.dox',
            type: 'POST',
            dataType: 'json',
            success: function(data) {
                // 백엔드 컨트롤러가 리턴한 JSON 구조가 자바스크립트 객체로 자동 파싱되어 안전하게 바인딩됩니다.
                if (typeof data === 'string') {
                    self.categoriesData = JSON.parse(data);
                } else {
                    self.categoriesData = data;
                }
            },
            error: function(xhr, status, error) {
                console.error("AJAX 기반 카테고리 트리 데이터베이스 수혈 실패:", error);
            }
        });
            
        // 최초 컴포넌트 렌더링 시 기본 조건으로 첫 조회가 트리거되도록 파이프라인 작동
        this.triggerFilterReload();
    },
    watch: {
        // 대분류, 중분류 라디오, 소분류 체크박스가 클릭될 때마다 실시간 감시(Watch)하여 동적재조회를 유도합니다.
        selectLargeCategory(newVal) {
            this.triggerFilterReload();
        },
        selectCategory(newVal) {
            this.triggerFilterReload();
        },
        selectTags(newVal) {
            this.triggerFilterReload();
        }
    },
    methods: {
        // 대분류 상단 분홍색 탭 메뉴 교체 시 하위 카테고리 바인딩 상태들을 깔끔히 초기화합니다.
        changeLargeCategory(largeCat) {
            this.selectLargeCategory = largeCat;
            this.selectCategory = ''; 
            this.selectTags = [];      
        },
        // 💡 실시간 필터 가교: 유저가 화면에서 무언가 누를 때마다 부모 창의 jQuery AJAX 메인 조회 함수를 자동 호출하게 유도
        triggerFilterReload() {
            this.$emit('update-filter-list', {
                largeCategory: this.selectLargeCategory,
                mediumCategory: this.selectCategory,
                tags: this.selectTags.join(',') // 배열 데이터를 콤마 구분자 문자열("화려한,가성비")로 포장
            });
        }
    },
    computed: {
        // 현재 선택된 대분류('결혼', '가족행사' 등)에 정확히 매칭되는 중분류 리스트를 dynamic하게 반환
        currentMediums() {
            return this.categoriesData[this.selectLargeCategory]?.mediums || [];
        },
        // 💡 예외 방어 핵심: DB가 맵핑해준 중분류별 소분류 태그 리스트를 추출합니다. 
        // 태그가 존재하지 않는 카테고리는 빈 배열([])이 반환되므로 Vue 템플릿의 v-if 조건문이 알아서 UI를 은닉합니다.
        currentTags() {
            if (!this.selectLargeCategory || !this.selectCategory) return [];
            return this.categoriesData[this.selectLargeCategory]?.tags?.[this.selectCategory] || [];
        },
        // 백엔드 데이터베이스 레벨(MyBatis JOIN + HAVING COUNT)에서 이미 완벽하게 필터링이 종결된 정답 데이터셋을 화면 리스트에 다이렉트 바인딩
        // 💡 회귀 디버깅 완결 조치: 부모나 백엔드 쿼리가 태그 정보를 어떤 규격(String/Array)으로 주든 
        // 자식 필터 연산 구역에서 즉시 가로채어 진짜 자바스크립트 배열 객체로 완벽 재포장 바인딩을 보장합니다.
        filteredList() {
            if (!this.productList) return [];
            return this.productList.map(item => {
                let parsedTag = [];
                if (item.tag) {
                    if (typeof item.tag === 'string') {
                        try {
                            parsedTag = JSON.parse(item.tag);
                        } catch (e) {
                            // 만약 일반 콤마로 나열된 문자열일 경우 split 처리 및 공백 제거 방어막 가동
                            parsedTag = item.tag.split(',').map(t => t.trim()).filter(t => t !== '');
                        }
                    } else if (Array.isArray(item.tag)) {
                        parsedTag = item.tag;
                    }
                }
                return {
                    ...item,
                    tag: parsedTag
                };
            });
        }
    }
};