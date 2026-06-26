// 2️⃣ 나의 예약 리스트 컴포넌트 객체 (자체 목록 조회 통신 및 4단 dynamic 필터/정렬 탑재)
const myReservationListComponent = {
    template: '#my-reservation-list-template',
    data() {
        return {
            // 부모창 주머니 대신, 리스트 데이터를 자식이 직접 소유합니다.
            reservationList: [],
            // 💡 탭 상태 변수 신설: 기본값 'ALL' (ALL: 전체, ING: 진행중, DONE: 이용완료, CANCEL: 취소됨)
            currentTab: 'ALL'
        };
    },
    computed: {
        // 💡 하이엔드 UI/UX 코어 엔진: 백엔드 재호출 없이 프론트엔드 단에서 실시간 필터링 및 복합 정렬 집행
        filteredAndSortedList() {
            let list = [...this.reservationList];

            // [Step 1] 현재 유저가 선택한 상단 탭 기준에 맞게 상태값(resStatus) 필터링
            if (this.currentTab === 'ING') {
                // 진행중: WAIT(대기) 또는 CONFIRM(확정) 상태만 추출
                list = list.filter(p => p.resStatus === 'WAIT' || p.resStatus === 'CONFIRM');
            } else if (this.currentTab === 'DONE') {
                // 이용완료: DONE 상태만 추출
                list = list.filter(p => p.resStatus === 'DONE');
            } else if (this.currentTab === 'CANCEL') {
                // 취소된 예약: CANCEL 상태만 추출
                list = list.filter(p => p.resStatus === 'CANCEL');
            }

            // [Step 2] 컬럼 증설 없는 useDate + useTime 문자열 결합 실시간 타임라인 정렬 작동
            list.sort((a, b) => {
                let dateTimeA = (a.useDate || '') + ' ' + (a.useTime || '');
                let dateTimeB = (b.useDate || '') + ' ' + (b.useTime || '');

                if (this.currentTab === 'ING') {
                    // 예약 진행중 탭만 유저가 급박하게 인지해야 하므로 방문일이 가장 가까운 일정 순인 [임박순 - 오름차순] 배정
                    return dateTimeA.localeCompare(dateTimeB);
                } else {
                    // 🎯 유저님 가이드 반영 리팩토링 완결: 
                    // [전체(ALL)] 탭을 포함하여 이용완료 및 취소 내역은 가장 먼 미래/가장 나중 날짜가 무조건 상단에 꽂히는 [내림차순] 통합 소팅
                    return dateTimeB.localeCompare(dateTimeA);
                }
            });

            return list;
        }
    },
    methods: {
        fnGetMyReservationList() {
            let loginId = window.SESSION_ID;
            if (!loginId || loginId === "") {
                return;
            }
            let self = this;
            let param = { userId: loginId };
            // 부모 함수 내부에 가둬져 있던 예약 조회 AJAX를 완벽히 이사했습니다.
            $.ajax({
                url: "/getMyReservationList.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    // 예외 완화 방어벽: 백엔드 트랜잭션 사고로 인해 list가 빈 주머니(null)로 올 때의 전면 크래시 강제 차단
                    if (!data || !data.list) {
                        self.reservationList = [];
                        return;
                    }
                    
                    self.reservationList = data.list.map(p => {
                        // 유연한 태그 문자열 디코딩 안전망: 콤마 나열 텍스트 형식을 진짜 자바스크립트 정규 배열 객체로 동적 가공
                        let parsedTag = [];
                        if (p.tag) {
                            if (typeof p.tag === 'string') {
                                try {
                                    parsedTag = JSON.parse(p.tag);
                                } catch (e) {
                                    parsedTag = p.tag.split(',').map(t => t.trim()).filter(t => t !== '');
                                }
                            } else if (Array.isArray(p.tag)) {
                                parsedTag = p.tag;
                            }
                        }

                        // 제거된 유령 컬럼 예외 완충 레일: DB 스펙 아웃된 proType 바인딩 예외 유연 자동 방어
                        let parsedProType = p.proType;
                        if (typeof p.proType === 'string' && p.proType.trim() !== '') {
                            try { parsedProType = JSON.parse(p.proType); } catch(e) { parsedProType = p.proType; }
                        }

                        return {
                            companyNo: p.companyNo,
                            deposit: p.deposit,       
                            imgUrl: p.imgUrl,
                            isActive: p.isActive,
                            originalPrice: p.originalPrice,
                            payDate: p.payDate,
                            payNo: p.payNo,
                            proType: parsedProType,
                            productDetails: p.productDetails,
                            productName: p.productName,
                            resContent: (p.resContent && p.resContent !== "") ? p.resContent : "요청사항 없음",
                            resNo: p.resNo,
                            resStatus: p.resStatus,
                            resDate: p.resDate,
                            resTime: p.resTime,
                            tag: parsedTag,
                            useDate: p.useDate,
                            useTime: p.useTime,
                            userId: p.userId,
                            amount: p.amount,
                            payStatus: p.payStatus,
                            refund: p.refund,
                            refundDate: p.refundDate,
                            comName: p.comName,
                            tel: p.tel
                        }
                    });
                }
            });
        }
    },
    mounted() {
        // 화면이 켜지자마자 자식이 주도적으로 서버 리스트를 당겨옵니다.
        this.fnGetMyReservationList();
    }
};