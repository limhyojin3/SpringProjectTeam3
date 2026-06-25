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
			categoriesData: {},          // DB에서 수혈받을 카테고리 트리 저장소
			userid: window.SESSION_ID || '' , // 전역 세션선 직통 연결
			localProductList: []         // [개인 지갑] 부모 간섭을 차단하기 위한 자체 독립 반응형 자산
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
		// 부모의 지갑(productList)에 돈이 들어오면 내 지갑(localProductList)에 깊은 복사로 즉시 이사 보관
		productList: {
			handler(newVal) {
				if (newVal) {
					this.localProductList = JSON.parse(JSON.stringify(newVal));
					
					// 💡 [전역 하트 공유선 역정렬 싱크] 상세방에서 바꾸고 뒤로가기 눌렀을 때, 메모리 저장소 값을 가져와 강제 동기화 수행!
					if (window.LIVE_COMPANY_LIKE) {
						this.localProductList.forEach(p => {
							if (window.LIVE_COMPANY_LIKE[p.companyNo] !== undefined) {
								p.isCompanyLiked = window.LIVE_COMPANY_LIKE[p.companyNo];
							}
						});
					}
				} else {
					this.localProductList = [];
				}
			},
			deep: true,
			immediate: true
		},
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
			// 자식 고유의 비즈니스 메서드 내부에서 안전하게 전역 카테고리 컨텍스트 기록!
			window.CURRENT_LARGE_CATEGORY = this.selectLargeCategory;
			
			this.$emit('update-filter-list', {
				largeCategory: this.selectLargeCategory,
				mediumCategory: this.selectCategory,
				tags: this.selectTags.join(',')
			});
		},
		
		// 1번 트랙: 가짜 인형 분신 대신 진짜 지갑 속 알맹이를 찾아내 직접 수정하는 하트 통신 엔진
		fnToggleProductLike(item) {
			var self = this;
			if (!self.userid) {
				alert("로그인 후 이용 가능합니다.");
				return;
			}
			
			const targetId = item.productNo || item.id;
			
			$.ajax({
				url: '/productLikeToggle.dox',
				type: 'POST',
				data: {
					productNo: targetId,
					loginUserId: self.userid
				},
				dataType: 'json',
				success: function(data) {
					if (data.result === 'success') {
						const realItem = self.localProductList.find(p => (p.productNo || p.id) === targetId);
						if (realItem) {
							if (data.status === 'liked') {
								realItem.isLiked = 1;
								realItem.likeCnt = (realItem.likeCnt || 0) + 1;
							} else {
								realItem.isLiked = 0;
								realItem.likeCnt = Math.max(0, (realItem.likeCnt || 0) - 1);
							}
						}
					}
				},
				error: function(xhr, status, error) {
					console.error("독립형 상품 찾기 내 실시간 하트 토글 실패:", error);
				}
			});
		},
		
		// 2번 트랙: 🎯 [업체 좋아요 정밀 타격 완공] 메인 화면 등록 업체 탭 하트 실시간 온오프 처리 스위치선
		fnToggleCompanyLike(comp) {
			var self = this;
			if (!self.userid) {
				alert("로그인 후 이용 가능합니다.");
				return;
			}
			const targetCompanyNo = comp.companyNo;
			window.LIVE_COMPANY_LIKE = window.LIVE_COMPANY_LIKE || {};

			// 💡 [선제 UI 스위칭] 통신 딜레이 버그 브레이커 발동 -> 누르는 즉시 UI를 강제 반전 및 메모리 주입
			const currentStatus = comp.isCompanyLiked === 1;
			const newStatus = currentStatus ? 0 : 1;

			window.LIVE_COMPANY_LIKE[targetCompanyNo] = newStatus;
			self.localProductList.forEach(p => {
				if (p.companyNo === targetCompanyNo) {
					p.isCompanyLiked = newStatus;
				}
			});

			$.ajax({
				url: '/companyLikeToggle.dox',
				type: 'POST',
				data: {
					companyNo: targetCompanyNo,
					loginUserId: self.userid
				},
				dataType: 'json',
				success: function(data) {
					if (data.result === 'success') {
						const finalStatus = data.status === 'liked' ? 1 : 0;
						window.LIVE_COMPANY_LIKE[targetCompanyNo] = finalStatus;
						self.localProductList.forEach(p => {
							if (p.companyNo === targetCompanyNo) {
								p.isCompanyLiked = finalStatus;
							}
						});
					}
				},
				error: function(xhr, status, error) {
					console.error("독립형 업체 찾기 내 실시간 하트 토글 실패:", error);
					// 네트워크 에러 시 안전하게 예전 상태로 롤백 복구
					window.LIVE_COMPANY_LIKE[targetCompanyNo] = currentStatus ? 1 : 0;
					self.localProductList.forEach(p => {
						if (p.companyNo === targetCompanyNo) {
							p.isCompanyLiked = currentStatus ? 1 : 0;
						}
					});
				}
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
		// 부모의 props 대신 자식 내 자체 지갑(localProductList) 자산을 기반으로 복사본 정제 수행
		filteredList() {
			if (!this.localProductList) return [];
			return this.localProductList.map(item => {
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
						thumbnail: item.comImgUrl || item.thumbnail,
						isCompanyLiked: item.isCompanyLiked // 진짜 업체 좋아요 연동선 바인딩 완료
					});
				}
			});
			return Array.from(storeMap.values());
		}
	}
};