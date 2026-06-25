const companyDetailComponent = {
	template: '#company-detail-template',
	// 부모 라우터로부터 전달받는 유일한 식별용 열쇠 식별자 변수
	props: ['companyNo'],
	data() {
		return {
			companyInfo: {},      // 자체 API 연동을 통해 격납될 순수 업체 프로필 바구니
			companyProducts: [],  // 해당 업체가 소유한 단독 상품 패키지 배열 리스트
			userid: window.SESSION_ID || '' // 로그인 연동 전용 세션 ID 수혈선
		};
	},
	created() {
		this.fnLoadCompanyDetail();
	},
	watch: {
		// 부모 센서 방의 업체 일련번호 변동을 실시간으로 추적 감시하여 데이터 싱크 정밀 제어
		companyNo(newVal) {
			if (newVal) {
				this.fnLoadCompanyDetail();
			}
		}
	},
	methods: {
		/* 💡 백엔드 단자를 직접 두드려 해당 업체 상세 데이터와 하위 상품 목록을 파싱해 오는 비즈니스 쿼리 */
		fnLoadCompanyDetail() {
			var self = this;
			if (!self.companyNo) return;
			
			$.ajax({
				url: '/productList.dox',
				type: 'POST',
				data: {
					companyNo: self.companyNo,
					largeCategory: window.CURRENT_LARGE_CATEGORY || '', // [기능적 독립 개통] 메인에서 보던 대분류 탭 컨텍스트를 주머니에 담아 저격 사출!
					loginUserId: self.userid
				},
				dataType: 'json',
				success: function(data) {
					if (data.result === 'success' && data.list && data.list.length > 0) {
						// 1. 순수 상위 업체 프로필 세팅 (JOIN 쿼리의 첫 번째 인덱스 맵에서 추출)
						const firstItem = data.list[0];
						
						// [전역 하트 공유선 순방향 싱크] 진입 시 전역 레지스트리에 저장된 최신 상태가 있다면 DB 결과보다 우선 수혈하여 증발 차단!
						window.LIVE_COMPANY_LIKE = window.LIVE_COMPANY_LIKE || {};
						let currentLikeState = firstItem.isCompanyLiked;
						if (window.LIVE_COMPANY_LIKE[self.companyNo] !== undefined) {
							currentLikeState = window.LIVE_COMPANY_LIKE[self.companyNo];
						} else {
							// 레지스트리에 흔적이 없으면 최초 DB 데이터를 캐싱 저장소에 보관
							window.LIVE_COMPANY_LIKE[self.companyNo] = firstItem.isCompanyLiked;
						}

						self.companyInfo = {
							comName: firstItem.comName,
							comAddress: firstItem.comAddress,
							comIntro: firstItem.comIntro,
							isCompanyLiked: currentLikeState // 전역 조율선 통과 버전 매핑 완료
						};
						
						// 2. 해당 업체 고유의 하위 패키지 리스트 포맷 가공 대입
						self.companyProducts = data.list.map(p => {
							return {
								productNo: p.productNo,
								productName: p.name,
								productContent: p.content,
								productPrice: p.price,
								imgUrl: p.thumbnail,
								isLiked: p.isLiked,
								likeCnt: p.likeCnt,
								companyNo: p.companyNo,
								/* 💡 [데이터선 추가] 예약금 정산 컴포넌트가 낙하산으로 요구하는 보증금 알맹이 수혈 통로 개통 */
								deposit: p.deposit 
							};
						});
					} else {
						self.companyProducts = [];
						self.companyInfo = { comName: '미등록 제휴업체', comAddress: '', comIntro: '', isCompanyLiked: 0 };
					}
				},
				error: function(xhr, status, error) {
					console.error("독립형 업체 상세 데이터베이스 수혈 실패:", error);
				}
			});
		},
		
		/* 💡 [다차원 라우팅 완공] 추천 상품 카드를 눌렀을 때 메인 상품 상세방 규격으로 데이터 포맷을 정렬 포장하여 발송하는 단자 */
		fnGoProductDetail(item) {
			var self = this;
			
			// 메인 리스트 및 productDetailTemplate이 상시 탐독하는 표준 프로덕트 VO 아키텍처 포맷으로 완벽 리팩토링 변환
			const standardProductPayload = {
				productNo: item.productNo,
				id: item.productNo,
				companyNo: item.companyNo,
				name: item.productName,
				content: item.productContent,
				price: item.productPrice,
				thumbnail: item.imgUrl,
				isLiked: item.isLiked,
				likeCnt: item.likeCnt,
				comName: self.companyInfo.comName, // 마스터 상단 바구니에 고여있는 진짜 업체명을 수혈!
				deposit: item.deposit
			};
			
			// 부모 창(productCategoryTag.jsp)의 전용 우회 단축선으로 패키지 상자 투척 무전 발사!
			this.$emit('go-product-detail', standardProductPayload);
		},
		
		/* 1번 트랙: 포켓몬 카드 각각의 '상품 고유 번호(productNo)'를 겨냥한 개별 찜 엔진 */
		fnToggleProductLike(item) {
			var self = this;
			if (!self.userid) {
				alert("로그인 후 이용 가능합니다.");
				return;
			}
			$.ajax({
				url: '/productLikeToggle.dox', 
				type: 'POST',
				data: {
					productNo: item.productNo,   
					loginUserId: self.userid
				},
				dataType: 'json',
				success: function(data) {
					if (data.result === 'success') {
						// 이제 독립 테이블 구조이므로 클릭한 해당 수직 포켓몬 카드의 알맹이만 단독 제어!
						if (data.status === 'liked') {
							item.isLiked = 1;
							item.likeCnt = (item.likeCnt || 0) + 1;
						} else {
							item.isLiked = 0;
							item.likeCnt = Math.max(0, (item.likeCnt || 0) - 1);
						}
					}
				},
				error: function(xhr, status, error) {
					console.error("상품 패키지 개별 실시간 하트 토글 통신 예외:", error);
				}
			});
		},
		
		/* 2번 트랙: 상단 대장 프로필 전용 '업체 즐겨찾기' 실시간 타격 통신 엔진 완공 */
		fnToggleCompanyLike() {
			var self = this;
			if (!self.userid) {
				alert("로그인 후 이용 가능합니다.");
				return;
			}
			if (!self.companyNo) return;
			
			window.LIVE_COMPANY_LIKE = window.LIVE_COMPANY_LIKE || {};
			
			// [선제 UI 스위칭] 통신 딜레이 버그 브레이커 발동 -> 누르는 즉시 상세방 상단 헤더 하트 반전 및 메모리 기록소에 각인
			const currentStatus = self.companyInfo.isCompanyLiked === 1;
			const newStatus = currentStatus ? 0 : 1;

			self.companyInfo.isCompanyLiked = newStatus;
			window.LIVE_COMPANY_LIKE[self.companyNo] = newStatus;
			
			$.ajax({
				url: '/companyLikeToggle.dox',
				type: 'POST',
				data: {
					companyNo: self.companyNo,   
					loginUserId: self.userid
				},
				dataType: 'json',
				success: function(data) {
					if (data.result === 'success') {
						const finalStatus = data.status === 'liked' ? 1 : 0;
						self.companyInfo.isCompanyLiked = finalStatus;
						window.LIVE_COMPANY_LIKE[self.companyNo] = finalStatus;
					}
				},
				error: function(xhr, status, error) {
					console.error("업체 마스터 즐겨찾기 실시간 동기화 통신 예외:", error);
					// 네트워크 이상 시 예전 상태 원복 및 공유선 복구
					self.companyInfo.isCompanyLiked = currentStatus ? 1 : 0;
					window.LIVE_COMPANY_LIKE[self.companyNo] = currentStatus ? 1 : 0;
				}
			});
		}
	}
};