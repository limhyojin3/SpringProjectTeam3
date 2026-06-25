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
					loginUserId: self.userid
				},
				dataType: 'json',
				success: function(data) {
					if (data.result === 'success' && data.list && data.list.length > 0) {
						// 1. 순수 상위 업체 프로필 세팅 (JOIN 쿼리의 첫 번째 인덱스 맵에서 추출)
						const firstItem = data.list[0];
						self.companyInfo = {
							comName: firstItem.comName,
							comAddress: firstItem.comAddress,
							comIntro: firstItem.comIntro
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
								companyNo: p.companyNo
							};
						});
					} else {
						self.companyProducts = [];
						self.companyInfo = { comName: '미등록 제휴업체', comAddress: '', comIntro: '' };
					}
				},
				error: function(xhr, status, error) {
					console.error("독립형 업체 상세 데이터베이스 수혈 실패:", error);
				}
			});
		},
		
		/* 💡 [대수술 완공] 1번 트랙: 포켓몬 카드 각각의 '상품 고유 번호(productNo)'를 겨냥한 개별 찜 엔진 */
		fnToggleProductLike(item) {
			var self = this;
			if (!self.userid) {
				alert("로그인 후 이용 가능합니다.");
				return;
			}
			$.ajax({
				url: '/productLikeToggle.dox', /* 👈 신규 product_like 연동 엔드포인트 조준 */
				type: 'POST',
				data: {
					productNo: item.productNo,   /* 👈 업체 번호가 아닌 진짜 상품 고유의 주민번호 사출 */
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
		
		/* 💡 미래 자산 확보: 2번 트랙: 추후 추가될 상단 대장 프로필 전용 '업체 즐겨찾기' 선행 마중물 메서드 */
		fnToggleCompanyLike() {
			var self = this;
			if (!self.userid) {
				alert("로그인 후 이용 가능합니다.");
				return;
			}
			$.ajax({
				url: '/companyLikeToggle.dox', /* 👈 기존 업체 전용 테이블 엔드포인트 보존 */
				type: 'POST',
				data: {
					companyNo: self.companyNo,   /* 👈 부모가 쥐고 있는 마스터 업체 번호 투사 */
					loginUserId: self.userid
				},
				dataType: 'json',
				success: function(data) {
					if (data.result === 'success') {
						// TODO: 나중에 상단 업체 프로필 우측에 하트 UI 만드실 때 이 구역 안에서 
						// self.companyInfo.isLiked 상태를 스위칭하도록 살만 채우시면 끝납니다!
						alert("업체 즐겨찾기 토글 성공 (상태: " + data.status + ")");
					}
				},
				error: function(xhr, status, error) {
					console.error("미래 자산용 업체 마스터 즐겨찾기 통신 예외:", error);
				}
			});
		}
	}
};