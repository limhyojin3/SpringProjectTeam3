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
		/* 💡 기능적 독립: 부모의 간섭 없이 본인이 백엔드 단자를 직접 두드려 데이터를 파싱해 오는 비즈니스 쿼리 */
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
		
		/* 💡 기능적 독립: 외부 목록 화면의 간섭 없이 본인 상세 방 안에서 실시간 하트 숫자를 가감 및 반전 연산 */
		fnToggleLike(item) {
			var self = this;
			if (!self.userid) {
				alert("로그인 후 이용 가능합니다.");
				return;
			}
			$.ajax({
				url: '/companyLikeToggle.dox',
				type: 'POST',
				data: {
					companyNo: item.companyNo,
					loginUserId: self.userid
				},
				dataType: 'json',
				success: function(data) {
					if (data.result === 'success') {
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
					console.error("업체 상세 내부 실시간 하트 토글 통신 예외:", error);
				}
			});
		}
	}
};