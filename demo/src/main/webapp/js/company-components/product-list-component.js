const productListComponent = {
	template: '#product-list-template',
	// 부모가 기억한 탭 상태(initSearchMode)를 상시 수신하는 단자선
	props: ['productList', 'productTag', 'initSearchMode'], 
	data() {
		return {
			// 부모에게 받은 기억값으로 초기 탭을 설정하여 뒤로가기 시 보던 탭이 완벽 복원되도록 조치
			searchMode: this.initSearchMode || 'product', 
			selectLargeCategory: '결혼', // 초기 기본 활성화 대분류값
			selectCategory: '',         // 중분류 단일 선택 라디오 버튼 값
			selectTags: [],             // 선택된 소분류 태그 배열
			categoriesData: {}          // DB에서 수혈받을 카테고리 트리 저장소
		};
	},
	created() {
		var self = this;
		
		// jQuery $.ajax를 통해 페이지 로드 즉시 백엔드 동적 트리 정보를 가져옵니다.
		$.ajax({
			url: '/getCategoryTree.dox',
			type: 'POST',
			dataType: 'json',
			success: function(data) {
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
		// 상품 찾기 ↔ 업체 찾기 탭이 스위칭되는 순간을 정밀 포착합니다.
		searchMode(newVal) {
			// 새로고침된 것처럼 대분류를 무조건 '결혼'으로 강제 고정하고, 남아있던 하위 값들을 깨끗하게 지웁니다.
			this.selectLargeCategory = '결혼';
			this.selectCategory = ''; 
			this.selectTags = [];      
			
			// 부모 메모리 방에도 유저가 변경한 탭 상태를 실시간 보고합니다.
			this.$emit('search-mode-change', newVal);
		},
		// 대분류, 중분류, 소분류가 변경될 때마다 실시간으로 백엔드 데이터를 필터 재조회합니다.
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
		// 대분류 탭 메뉴 수동 변경 시 하위 카테고리 선택값 초기화
		changeLargeCategory(largeCat) {
			this.selectLargeCategory = largeCat;
			this.selectCategory = ''; 
			this.selectTags = [];      
		},
		// 실시간 필터 가교: 부모 창의 jQuery AJAX 메인 조회 함수를 자동 호출하도록 유도
		triggerFilterReload() {
			this.$emit('update-filter-list', {
				largeCategory: this.selectLargeCategory,
				mediumCategory: this.selectCategory,
				tags: this.selectTags.join(',')
			});
		}
	},
	computed: {
		// 현재 선택된 대분류에 매칭되는 중분류 리스트 반환
		currentMediums() {
			return this.categoriesData[this.selectLargeCategory]?.mediums || [];
		},
		// 중분류별 소분류 태그 리스트 추출
		currentTags() {
			if (!this.selectLargeCategory || !this.selectCategory) return [];
			return this.categoriesData[this.selectLargeCategory]?.tags?.[this.selectCategory] || [];
		},
		// 백엔드에서 받아온 상품 리스트의 태그 문자열을 안전하게 자바스크립트 배열로 정제
		filteredList() {
			if (!this.productList) return [];
			return this.productList.map(item => {
				let parsedTag = [];
				if (item.tag) {
					if (typeof item.tag === 'string') {
						try {
							parsedTag = JSON.parse(item.tag);
						} catch (e) {
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
		},
		// 혼합 데이터에서 중복 없는 고유 업체 마스터 유닛만 추출하는 정제식
		uniqueCompanies() {
			if (!this.filteredList) return [];
			const storeMap = new Map();
			this.filteredList.forEach(item => {
				if (item.companyNo && !storeMap.has(item.companyNo)) {
					storeMap.set(item.companyNo, {
						companyNo: item.companyNo,
						comName: item.comName,
						comIntro: item.comIntro,
						comAddress: item.comAddress,
						// 💡 [2교시 요구사항 완결] 백엔드가 매퍼 XML을 통해 새로 개통해준 진짜 회사 이미지(comImgUrl)를 정밀 매핑선에 도킹!
						// 데이터베이스에 등록된 회사 이미지가 만약 없을 경우를 대비해 기존 상품 썸네일을 안전 자산 백업(Fallback)으로 지정
						thumbnail: item.comImgUrl || item.thumbnail,
						isLiked: item.isLiked,
						likeCnt: item.likeCnt
					}); 
				}
			});
			return Array.from(storeMap.values());
		}
	}
};