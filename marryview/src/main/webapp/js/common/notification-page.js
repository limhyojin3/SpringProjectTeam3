(function () {
    'use strict';

    var root = document.getElementById('app');
    if (!root || typeof Vue === 'undefined') return;

    var productAdTimer;
    var toastTimer;
    var desktopScreen;
    var syncVideoHandler;

    Vue.createApp({
        data: function () {
            return {
                apiBase: root.dataset.apiBase || '',
                contextPath: root.dataset.contextPath || '',
                notifications: [],
                unreadCount: 0,
                currentFilter: 'all',
				currentPage: 1,
				pageSize: 5,
                loading: true,
                refreshing: false,
                errorMessage: '',
                responseText: '아직 응답이 없습니다.',
                responseIsError: false,
                toastMessage: '',
                toastVisible: false,
                celebrationIndex: 0,
                productAdIndex: 0,
                popularType: 'post',
                filters: [
                    { label: '전체', value: 'all' },
                    { label: '읽지 않음', value: 'unread' },
                    { label: '읽음', value: 'read' }
                ],
                weddingNews: [
                    {
                        isMine: true,
                        names: '민준 & 서연',
                        date: '2026. 06. 27 · SAT',
                        dday: 'D-8',
                        kicker: '우리의 결혼식',
                        message: '두 사람이 함께 그려온 소중한 약속이 곧 아름다운 시작을 맞이합니다.',
                        bottom: '메리뷰가 두 분의 결혼을 진심으로 축하해요!'
                    },
                    {
                        isMine: false,
                        names: '지훈 & 하은',
                        date: '2026. 07. 04 · SAT',
                        dday: 'D-15',
                        kicker: '메리뷰 회원의 결혼 소식',
                        message: '두 사람의 새로운 계절이 사랑과 행복으로 오래도록 빛나기를 바랍니다.',
                        bottom: '두 분의 아름다운 시작을 함께 축하해 주세요.'
                    },
                    {
                        isMine: false,
                        names: '도윤 & 수아',
                        date: '2026. 07. 11 · SAT',
                        dday: 'D-22',
                        kicker: '메리뷰 회원의 결혼 소식',
                        message: '서로의 가장 좋은 친구가 된 두 사람이 이제 평생의 동반자가 됩니다.',
                        bottom: '따뜻한 축하의 마음을 함께 전해 주세요.'
                    }
                ],
                popularContent: {
                    post: [
                        { title: '결혼 준비, 예산은 어디서부터 잡아야 할까요?', views: 328, likes: 41 },
                        { title: '웨딩홀 투어 전에 꼭 확인할 체크리스트', views: 246, likes: 35 },
                        { title: '본식 스냅 업체 고를 때 중요했던 세 가지', views: 198, likes: 27 }
                    ],
                    review: [
                        { title: '채광이 정말 예뻤던 야외 웨딩 솔직 후기', views: 412, likes: 58 },
                        { title: '드레스 투어 세 곳 비교하고 결정한 후기', views: 365, likes: 49 },
                        { title: '메이크업 상담부터 본식까지 꼼꼼 리뷰', views: 289, likes: 43 }
                    ]
                },
                productAds: [
                    { company: '로즈브라이드', name: '2026 시그니처 드레스 패키지', discount: '20%', amount: '1,280,000원', symbol: '♕', tone: '' },
                    { company: '아르떼 주얼리', name: '프라이빗 웨딩링 커플 세트', discount: '15%', amount: '890,000원', symbol: '◇', tone: 'gold' },
                    { company: '메종 드 플라워', name: '본식 부케 · 부토니에 세트', discount: '10%', amount: '198,000원', symbol: '✿', tone: 'lilac' }
                ],
				notificationChangedHandler: null,
				sidebarLoading: false,
            };
        },

        computed: {
            filteredNotifications: function () {
                var filter = this.currentFilter;
                return this.notifications.filter(function (item) {
                    if (filter === 'unread') return item.isRead === 'N';
                    if (filter === 'read') return item.isRead === 'Y';
                    return true;
                });
            },
			pagedNotifications: function () {
			    var start = (this.currentPage - 1) * this.pageSize;
			    return this.filteredNotifications.slice(start, start + this.pageSize);
			},

			totalPages: function () {
			    return Math.max(1, Math.ceil(this.filteredNotifications.length / this.pageSize));
			},
            unreadBadge: function () {
                return this.unreadCount > 99 ? '99+' : this.unreadCount;
            },
            summaryText: function () {
                if (this.loading) return '알림을 불러오는 중입니다.';
                return this.unreadCount
                    ? '읽지 않은 알림이 ' + this.unreadCount + '개 있어요.'
                    : '새로운 알림을 모두 확인했어요.';
            },
            emptyState: function () {
                if (this.currentFilter === 'unread') return { icon: '✓', title: '모두 확인했어요', copy: '읽지 않은 알림이 없습니다.' };
                if (this.currentFilter === 'read') return { icon: '✓', title: '확인한 알림이 없어요', copy: '알림을 읽으면 이곳에서 다시 확인할 수 있어요.' };
                return { icon: '♡', title: '아직 알림이 없어요', copy: '새로운 소식이 생기면 이곳에 알려드릴게요.' };
            },
            currentWeddingNews: function () {
                return this.weddingNews[this.celebrationIndex] || {};
            },
            currentPopularItems: function () {
                return this.popularContent[this.popularType] || [];
            },
            currentProductAd: function () {
                return this.productAds[this.productAdIndex] || {};
            },
            productAdNumber: function () {
                return String(this.productAdIndex + 1).padStart(2, '0') + ' / ' + String(this.productAds.length).padStart(2, '0');
            }
        },

        methods: {
            request: function (path, data) {
                var self = this;
                var body = new URLSearchParams();
                Object.keys(data || {}).forEach(function (key) { body.append(key, data[key]); });

                return fetch(this.apiBase + path, {
                    method: 'POST',
                    credentials: 'same-origin',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
                    body: body.toString()
                }).then(function (response) {
                    if (!response.ok) throw new Error('HTTP 상태: ' + response.status);
                    return response.json();
                }).then(function (data) {
                    self.responseIsError = false;
                    self.responseText = JSON.stringify(data, null, 2);
                    return data;
                }).catch(function (error) {
                    self.responseIsError = true;
                    self.responseText = error.message || '잠시 후 다시 시도해 주세요.';
                    throw error;
                });
            },
	
			requestFormUrl: function (url, data) {
			    var body = new URLSearchParams();
			    Object.keys(data || {}).forEach(function (key) { body.append(key, data[key]); });

			    return fetch(url, {
			        method: 'POST',
			        credentials: 'same-origin',
			        headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
			        body: body.toString()
			    }).then(function (response) {
			        if (!response.ok) throw new Error('HTTP 상태: ' + response.status);
			        return response.json();
			    });
			},

			requestJsonUrl: function (url, data) {
			    return fetch(url, {
			        method: 'POST',
			        credentials: 'same-origin',
			        headers: { 'Content-Type': 'application/json;charset=UTF-8' },
			        body: JSON.stringify(data || {})
			    }).then(function (response) {
			        if (!response.ok) throw new Error('HTTP 상태: ' + response.status);
			        return response.json();
			    });
			},

			loadSidebarData: function () {
			    var self = this;
			    this.sidebarLoading = true;

			    return Promise.all([
			        this.requestFormUrl(this.contextPath + '/productList.dox', {}),
			        this.request('/wedding-news.dox', {}),
			        this.requestFormUrl(this.contextPath + '/api/community/popularList.dox', {}),
					this.requestJsonUrl(this.contextPath + '/api/review/list.dox', {
					    startIndex: 0,
					    pageSize: 3,
					    orderType: 'likes'
					})
			    ]).then(function (responses) {
			        self.productAds = self.mapProductAds(responses[0].list || []);
			        self.weddingNews = self.mapWeddingNews(responses[1].list || []);
			        self.popularContent.post = self.mapPopularPosts(responses[2].list || []);
			        self.popularContent.review = self.mapPopularReviews(responses[3].bestList || []);
			    }).catch(function () {
			        self.showToast('사이드 데이터를 불러오지 못했습니다.');
			    }).finally(function () {
			        self.sidebarLoading = false;
			    });
			},

			mapProductAds: function (list) {
				var self = this;
			    return list.slice(0, 3).map(function (item, index) {
			        return {
			            productNo: item.productNo,
			            company: item.comName || item.company || 'MarryView',
			            name: item.productName || item.name || '추천 상품',
			            discount: 'NEW',
			            amount: Number(item.originalPrice || item.price || 0).toLocaleString('ko-KR') + '원',
			            symbol: ['01', '02', '03'][index] || 'NEW',
			            tone: index === 1 ? 'gold' : (index === 2 ? 'lilac' : ''),
						imageUrl: self.normalizeImageUrl(item.imgUrl || item.thumbnail || item.comImgUrl),
			        };
			    });
			},

			mapWeddingNews: function (list) {
			    return list.slice(0, 3).map(function (item) {
			        var dday = Number(item.dday);
			        return {
			            isMine: false,
			            names: item.maskedUserId || '***',
			            date: item.weddingDateText || item.weddingDate || '',
			            dday: dday === 0 ? 'D-DAY' : 'D-' + dday,
			            kicker: 'MarryView 회원 결혼 예정 소식',
			            message: '새로운 시작을 준비하는 회원님의 결혼 예정일이 다가오고 있어요.',
			            bottom: '따뜻한 축하의 마음을 함께 전해주세요.'
			        };
			    });
			},

			mapPopularPosts: function (list) {
			    return list.slice(0, 3).map(function (item) {
			        return {
			            type: 'post',
			            postNo: item.postNo,
			            title: item.title || '인기글',
			            views: item.viewCnt || 0,
			            likes: item.likeCnt || 0
			        };
			    });
			},

			mapPopularReviews: function (list) {
			    return list.slice(0, 3).map(function (item) {
			        return {
			            type: 'review',
			            reviewNo: item.reviewNo,
			            title: item.title || '인기리뷰',
			            views: item.viewCnt || 0,
			            likes: item.likeCnt || 0
			        };
			    });
			},

			goProduct: function (item) {
			    if (!item || !item.productNo) {
			        this.showToast('상품 정보를 찾을 수 없습니다.');
			        return;
			    }
			    window.location.href = this.contextPath + '/productCategoryTag.do?productNo=' + item.productNo;
			},

			goPopularItem: function (item) {
			    if (!item) return;

			    if (item.type === 'review' && item.reviewNo) {
			        window.location.href = this.contextPath + '/api/review/detail.do?reviewNo=' + item.reviewNo;
			        return;
			    }

			    if (item.type === 'post' && item.postNo) {
			        window.location.href = this.contextPath + '/api/community/detail.do?postNo=' + item.postNo;
			        return;
			    }

			    this.showToast('상세 정보를 찾을 수 없습니다.');
			},
			
            refreshAll: function (showMessage) {
                var self = this;
                this.refreshing = true;
                this.errorMessage = '';

                return Promise.all([
                    this.request('/list.dox', { limit: 20 }),
                    this.request('/unread-count.dox', {})
                ]).then(function (responses) {
                    var listResponse = responses[0];
                    var countResponse = responses[1];

                    if (listResponse.result !== 'success') throw new Error(listResponse.message || '알림 목록을 불러오지 못했습니다.');
                    if (countResponse.result !== 'success') throw new Error(countResponse.message || '읽지 않은 알림 수를 불러오지 못했습니다.');

                    self.notifications = listResponse.list || [];
                    self.unreadCount = Number(countResponse.unreadCount) || 0;
                    if (showMessage) self.showToast('알림을 새로 불러왔어요.');
                }).catch(function (error) {
                    self.errorMessage = error.message || '네트워크 상태를 확인한 뒤 새로고침해 주세요.';
                }).finally(function () {
                    self.loading = false;
                    self.refreshing = false;
                });
            },

            readNotification: function (item) {
                var self = this;
                if (!item || item.isRead !== 'N') return;

                this.request('/read.dox', { notificationNo: item.notificationNo }).then(function (response) {
                    if (response.result === 'success') {
                        item.isRead = 'Y';
                        self.unreadCount = Math.max(0, self.unreadCount - 1);
                        self.showToast('알림을 읽음 처리했어요.');
                        document.dispatchEvent(new CustomEvent('mv:notification-changed'));
                    }
                }).catch(function () {
                    self.showToast('읽음 처리에 실패했습니다.');
                });
            },

            readAll: function () {
                var self = this;
                if (this.unreadCount === 0) return;
                this.refreshing = true;

                this.request('/read-all.dox', {}).then(function (response) {
                    if (response.result === 'success') {
                        self.notifications.forEach(function (item) { item.isRead = 'Y'; });
                        self.unreadCount = 0;
                        self.showToast('모든 알림을 확인했어요.');
                        document.dispatchEvent(new CustomEvent('mv:notification-changed'));
                    }
                }).catch(function () {
                    self.showToast('모두 읽음 처리에 실패했습니다.');
                }).finally(function () {
                    self.refreshing = false;
                });
            },

			typeLabel: function (type) {
			    var labels = {
			        MATCH: '매칭',
			        MESSAGE: '메시지',
			        SYSTEM: '안내',

			        REVIEW: '리뷰',
			        REVIEW_APPROVED: '리뷰 승인',
			        REVIEW_REJECTED: '리뷰 반려',
			        REVIEW_REQUEST_1DAY: '리뷰 요청',
			        REVIEW_REQUEST_7DAYS: '리뷰 요청',
			        REVIEW_REQUEST_30DAYS: '리뷰 요청',
			        REVIEW_COMMENTED: '리뷰 댓글',
			        COMPANY_REVIEW_RECEIVED: '업체 리뷰',

			        RESERVATION: '예약',
			        RESERVATION_REQUESTED: '예약 요청',
			        RESERVATION_CONFIRMED: '예약 확정',
			        RESERVATION_CANCELED: '예약 취소',

			        PAYMENT: '결제',

			        INQUIRY_ANSWERED: '문의 답변',
			        INQUIRY_RECEIVED: '문의 접수',
			        PRODUCT_INQUIRY_RECEIVED: '상품 문의',
			        PRODUCT_INQUIRY_ANSWERED: '상품 답변',

			        REPORT_RECEIVED: '신고 접수',
			        REPORT_WARNING: '신고 경고',
			        REPORT_RESULT: '신고 결과',
			        REPORT_APPROVED: '신고 승인',
			        REPORT_REJECTED: '신고 반려',

			        PARTNER_APPROVED: '업체 승인',
			        PARTNER_APPLICATION_RECEIVED: '제휴 신청',

			        COUPON_ISSUED: '쿠폰',
			        GIFTCON_ISSUED: '기프트콘',

			        POST_COMMENTED: '게시글 댓글'
			    };

			    return labels[type] || '알림';
			},

			typeIcon: function (type) {
			    var icons = {
			        MATCH: '♥',
			        MESSAGE: '✉',
			        SYSTEM: 'i',

			        REVIEW: '★',
			        REVIEW_APPROVED: '★',
			        REVIEW_REJECTED: '!',
			        REVIEW_REQUEST_1DAY: '★',
			        REVIEW_REQUEST_7DAYS: '★',
			        REVIEW_REQUEST_30DAYS: '★',
			        REVIEW_COMMENTED: '💬',
			        COMPANY_REVIEW_RECEIVED: '★',

			        RESERVATION: '📅',
			        RESERVATION_REQUESTED: '📅',
			        RESERVATION_CONFIRMED: '✓',
			        RESERVATION_CANCELED: '!',

			        PAYMENT: '₩',

			        INQUIRY_ANSWERED: '?',
			        INQUIRY_RECEIVED: '?',
			        PRODUCT_INQUIRY_RECEIVED: '?',
			        PRODUCT_INQUIRY_ANSWERED: '?',

			        REPORT_RECEIVED: '!',
			        REPORT_WARNING: '!',
			        REPORT_RESULT: '!',
			        REPORT_APPROVED: '!',
			        REPORT_REJECTED: '!',

			        PARTNER_APPROVED: '✓',
			        PARTNER_APPLICATION_RECEIVED: '+',

			        COUPON_ISSUED: '%',
			        GIFTCON_ISSUED: '🎁',

			        POST_COMMENTED: '💬'
			    };

			    return icons[type] || 'i';
			},

            formatDate: function (value) {
                if (!value) return '';
                var date = new Date(String(value).replace(' ', 'T'));
                if (Number.isNaN(date.getTime())) return value;

                var diff = Date.now() - date.getTime();
                var minute = 60 * 1000;
                var hour = 60 * minute;
                var day = 24 * hour;
                if (diff < minute) return '방금 전';
                if (diff < hour) return Math.floor(diff / minute) + '분 전';
                if (diff < day) return Math.floor(diff / hour) + '시간 전';
                if (diff < 7 * day) return Math.floor(diff / day) + '일 전';
                return new Intl.DateTimeFormat('ko-KR', { year: 'numeric', month: 'short', day: 'numeric' }).format(date);
            },

            showToast: function (message) {
                var self = this;
                window.clearTimeout(toastTimer);
                this.toastMessage = message;
                this.toastVisible = true;
                toastTimer = window.setTimeout(function () { self.toastVisible = false; }, 2200);
            },

            goBack: function () {
                if (window.history.length > 1) window.history.back();
                else window.location.href = this.contextPath + '/merryViewHome.do';
            },

            moveCelebration: function (direction) {
                this.celebrationIndex = (this.celebrationIndex + direction + this.weddingNews.length) % this.weddingNews.length;
            },

            moveProductAd: function (direction) {
                this.productAdIndex = (this.productAdIndex + direction + this.productAds.length) % this.productAds.length;
                this.restartProductAdTimer();
            },

            restartProductAdTimer: function () {
                var self = this;
                window.clearInterval(productAdTimer);
                productAdTimer = window.setInterval(function () {
                    self.productAdIndex = (self.productAdIndex + 1) % self.productAds.length;
                }, 5000);
            },

            setupSideVideo: function () {
                var video = document.getElementById('weddingSideVideo');
                if (!video) return;
                desktopScreen = window.matchMedia('(min-width: 1380px)');

                syncVideoHandler = function (event) {
                    if (event.matches) {
                        if (!video.getAttribute('poster')) video.setAttribute('poster', video.dataset.poster);
                        if (!video.getAttribute('src')) {
                            video.setAttribute('src', video.dataset.src);
                            video.load();
                        }
                        var playPromise = video.play();
                        if (playPromise) playPromise.catch(function () {});
                    } else {
                        video.pause();
                        video.removeAttribute('src');
                        video.removeAttribute('poster');
                        video.load();
                    }
                };

                syncVideoHandler(desktopScreen);
                if (desktopScreen.addEventListener) desktopScreen.addEventListener('change', syncVideoHandler);
                else desktopScreen.addListener(syncVideoHandler);
            },
			
			normalizeImageUrl: function (url) {
			    if (!url) return '';
			    if (url.indexOf('http://') === 0 || url.indexOf('https://') === 0 || url.indexOf('/') === 0) {
			        return url;
			    }
			    return this.contextPath + '/' + url;
			},
			
			changeFilter: function (value) {
			    this.currentFilter = value;
			    this.currentPage = 1;
			},

			movePage: function (page) {
			    if (page < 1 || page > this.totalPages) return;
			    this.currentPage = page;
			},
        },

        mounted: function () {
            this.refreshAll(false);
			this.loadSidebarData();
            this.restartProductAdTimer();
            this.setupSideVideo();
			this.notificationChangedHandler = this.refreshAll.bind(this, false);
			document.addEventListener('mv:notification-changed', this.notificationChangedHandler);
        },

        beforeUnmount: function () {
            window.clearInterval(productAdTimer);
            window.clearTimeout(toastTimer);
            if (desktopScreen && syncVideoHandler) {
                if (desktopScreen.removeEventListener) desktopScreen.removeEventListener('change', syncVideoHandler);
                else desktopScreen.removeListener(syncVideoHandler);
            }
			if (this.notificationChangedHandler) {
			    document.removeEventListener('mv:notification-changed', this.notificationChangedHandler);
			}
        }
		
		
    }).mount('#app');

//푸터충돌방지
	var footer = document.querySelector('footer');
	    var sideElements = document.querySelectorAll(
	        '.side-visual, .product-ad-rail, .wedding-celebration-rail'
	    );

		function stopSideBeforeFooter() {
		    if (!footer) return;

		    var footerTop = footer.getBoundingClientRect().top;
		    var gap = 20;

		    var video = document.querySelector('.side-visual--left');
		    var product = document.querySelector('.product-ad-rail');
		    var right = document.querySelector('.wedding-celebration-rail');

		    /* 왼쪽: 가장 아래에 있는 상품광고를 기준으로 함께 이동 */
		    if (video && product) {
		        var previousLeft =
		            parseFloat(product.style.getPropertyValue('--footer-overlap')) || 0;

		        var productOriginalBottom =
		            product.getBoundingClientRect().bottom + previousLeft;

		        var leftOverlap = Math.max(
		            0,
		            productOriginalBottom - footerTop + gap
		        );

		        video.style.setProperty(
		            '--footer-overlap',
		            leftOverlap + 'px'
		        );

		        product.style.setProperty(
		            '--footer-overlap',
		            leftOverlap + 'px'
		        );
		    }

		    /* 오른쪽은 따로 계산 */
		    if (right) {
		        var previousRight =
		            parseFloat(right.style.getPropertyValue('--footer-overlap')) || 0;

		        var rightOriginalBottom =
		            right.getBoundingClientRect().bottom + previousRight;

		        var rightOverlap = Math.max(
		            0,
		            rightOriginalBottom - footerTop + gap
		        );

		        right.style.setProperty(
		            '--footer-overlap',
		            rightOverlap + 'px'
		        );
		    }
		}

	    window.addEventListener('scroll', stopSideBeforeFooter, {
	        passive: true
	    });

	    window.addEventListener('resize', stopSideBeforeFooter);

	    stopSideBeforeFooter();

//
	
	
})();
