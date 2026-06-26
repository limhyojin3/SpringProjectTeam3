<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<main class="main-content">
            <div class="d-flex justify-content-between align-items-end mb-4">
                <div>
                    <h2 class="review-page-title review-title-header" @click="fnReset">
                        <i class="fas fa-camera mr-2"></i>리뷰 커뮤니티
                    </h2>
                    <span v-if="sessionId" class="badge badge-ticket ml-2">
                        내 열람권: {{ userRemainingCount }}개
                    </span>
                    <p class="text-muted mb-0">생생한 이용 후기를 확인하고 스마트하게 선택하세요.</p>
                </div>
                <button class="btn btn-primary-pill btn-lg" @click="fnWrite">
                    <i class="fas fa-pen mr-2"></i>리뷰 작성하기
                </button>
            </div>

            <div class="search-area d-flex justify-content-center">
                <div class="input-group" style="max-width: 600px;">
                    <select class="form-control col-3" v-model="searchType">
                        <option value="all">전체</option>
                        <option value="company">업체명</option>
                        <option value="title">제목</option>
                        <option value="content">내용</option>
                    </select>
                    <input type="text" class="form-control col-7" placeholder="검색어를 입력하세요" v-model="searchKeyword" @keyup.enter="fnList">
                    <div class="input-group-append col-2 p-0">
                        <button class="btn btn-primary-pill btn-block" @click="fnList">
                            <i class="fas fa-search mr-1"></i>검색
                        </button>
                    </div>
                </div>
            </div>

            <div class="d-flex justify-content-between align-items-center mb-2">
                <div class="review-tabs review-tabs-wrap mb-0">
                    <div class="tab-item" :class="{active: isPaid === null}" @click="fnFilter(null)">전체보기</div>
                    <div class="tab-item tab-paid" :class="{active: isPaid === 1}" @click="fnFilter(1)">
                        <i class="fas fa-gem mr-1"></i> 유료 리뷰
                    </div>
                    <div class="tab-item tab-free" :class="{active: isPaid === 0}" @click="fnFilter(0)">
                        <i class="fas fa-gift mr-1"></i> 무료 리뷰
                    </div>
                </div>
                <div class="btn-group btn-group-sm">
                    <div class="order-btn-wrap">
                        <button class="btn btn-sm btn-order" 
                                :class="{active: orderType === 'date'}" 
                                @click="fnChangeOrder('date')">
                            <i class="fas fa-clock mr-1"></i>최신순
                        </button>
                        <button class="btn btn-sm btn-order" 
                                :class="{active: orderType === 'views'}" 
                                @click="fnChangeOrder('views')">
                            <i class="fas fa-eye mr-1"></i>조회순
                        </button>
                        <button class="btn btn-sm btn-order" 
                                :class="{active: orderType === 'likes'}" 
                                @click="fnChangeOrder('likes')">
                            <i class="fas fa-heart mr-1"></i>좋아요순
                        </button>
                    </div>
                </div>
            </div>

            <div class="category-filter-wrap">
                <button class="btn btn-sm btn-cat mr-1"
                        :class="mainCategory === 'all' ? 'btn-cat-all-active' : 'btn-cat-all'"
                        @click="fnChangeLargeCategory('all')">전체</button>

                <!-- 결혼 -->
                <div class="category-wrap">
                    <button class="btn btn-sm btn-cat btn-cat-wedding"
                            :class="{active: mainCategory === '결혼'}"
                            @click="fnChangeLargeCategory('결혼')">
                        <i class="fas fa-ring mr-1"></i>결혼
                    </button>
                    <div v-if="mainCategory === '결혼'" class="sub-category-dropdown sub-dropdown-wedding">
                        <button class="btn btn-sm btn-sub-wedding"
                                :class="{active: subCategory === 'all'}"
                                @click="fnChangeMediumCategory('all')">전체</button>
                        <button v-for="sub in categoryMap['결혼']" :key="sub"
                                class="btn btn-sm btn-sub-wedding"
                                :class="{active: subCategory === sub}"
                                @click="fnChangeMediumCategory(sub)">{{ sub }}</button>
                        <!-- 닫기 버튼 추가 -->
                        <button class="btn btn-sm btn-close-dropdown" @click.stop="fnChangeLargeCategory('all')">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                </div>

                <!-- 가족행사 -->
                <div class="category-wrap">
                    <button class="btn btn-sm btn-cat btn-cat-family"
                            :class="{active: mainCategory === '가족행사'}"
                            @click="fnChangeLargeCategory('가족행사')">
                        <i class="fas fa-users mr-1"></i>가족행사
                    </button>
                    <div v-if="mainCategory === '가족행사'" class="sub-category-dropdown sub-dropdown-family">
                        <button class="btn btn-sm btn-sub-family"
                                :class="{active: subCategory === 'all'}"
                                @click="fnChangeMediumCategory('all')">전체</button>
                        <button v-for="sub in categoryMap['가족행사']" :key="sub"
                                class="btn btn-sm btn-sub-family"
                                :class="{active: subCategory === sub}"
                                @click="fnChangeMediumCategory(sub)">{{ sub }}</button>
                        <!-- 닫기 버튼 추가 -->
                        <button class="btn btn-sm btn-close-dropdown" @click.stop="fnChangeLargeCategory('all')">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                </div>

                <!-- 친구와함께 -->
                <div class="category-wrap">
                    <button class="btn btn-sm btn-cat btn-cat-friends"
                            :class="{active: mainCategory === '친구와함께'}"
                            @click="fnChangeLargeCategory('친구와함께')">
                        <i class="fas fa-glass-cheers mr-1"></i>친구와함께
                    </button>
                    <div v-if="mainCategory === '친구와함께'" class="sub-category-dropdown sub-dropdown-friends">
                        <button class="btn btn-sm btn-sub-friends"
                                :class="{active: subCategory === 'all'}"
                                @click="fnChangeMediumCategory('all')">전체</button>
                        <button v-for="sub in categoryMap['친구와함께']" :key="sub"
                                class="btn btn-sm btn-sub-friends"
                                :class="{active: subCategory === sub}"
                                @click="fnChangeMediumCategory(sub)">{{ sub }}</button>
                        <!-- 닫기 버튼 추가 -->
                        <button class="btn btn-sm btn-close-dropdown" @click.stop="fnChangeLargeCategory('all')">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                </div>
            </div>

            <div class="best-review-wrapper" v-if="bestList && bestList.length > 0">
                <!-- 하트 장식 추가 -->
                <div class="heart-deco">
                    <i class="fas fa-heart"></i>
                    <i class="fas fa-heart"></i>
                    <i class="fas fa-heart"></i>
                    <i class="fas fa-heart"></i>
                    <i class="fas fa-heart"></i>
                    <i class="fas fa-heart"></i>
                </div>
                <div class="section-header">
                    <h2 class="best-main-title">
                        <i class="fas fa-crown icon-crown"></i> WEEKLY BEST REVIEWS <i class="fas fa-crown icon-crown"></i> 
                    </h2>
                    <p class="best-sub-title">가장 많은 사랑을 받은 베스트 후기입니다.</p>
                </div>

                <div class="best-grid">
                    <div v-for="(best, index) in bestList" :key="best.reviewNo" class="best-card" @click="fnDetail(best)">
                        <div class="rank-label" :class="'rank-' + (index + 1)">{{index + 1}}</div>
                        
                        <div class="best-img-box">
                            <!-- [추가] 프리미엄 배지 (유료글이면 항상 노출) -->
                            <span v-if="best.isPaid == 1" class="badge-premium badge-premium-overlay">PREMIUM</span>

                            <!-- [수정] 조건부 블러 클래스 적용 -->
                            <img :src="best.thumbnailUrl || '/images/marryviewlogo_v3.png'" 
                                :class="{'no-img-default': !best.thumbnailUrl, 'is-blurred': shouldBlur(best)}"
                                @error="(e) => e.target.src = '/images/marryviewlogo_v3.png'">
                                 <div v-if="shouldBlur(best)" class="premium-lock-guide">
                                    <i class="fas fa-lock"></i>
                                    <strong>유료 리뷰</strong>
                                    <span>열람권을 사용하면 확인할 수 있습니다.</span>
                                </div>
                        </div>

                        <div class="best-info">
                            <span class="company-tag">{{best.comName}}</span>
                            <a v-if="best.nickname !== '탈퇴회원'":href="'/userProfile.do?userId=' + best.userId" class="nickname-link">
                                <div class="user-nickname"> {{ best.nickname }} 님</div>
                            </a>
                            <h3 class="title-text">{{best.title}}</h3>
                            <div class="best-meta">
                                <span><i class="fas fa-heart"></i> {{best.likeCnt}}</span>
                                <span><i class="fas fa-eye"></i> {{best.viewCnt}}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <hr class="section-divider">

            <div class="review-grid">
                <div v-for="item in list" :key="item.reviewNo" class="review-card" @click="fnDetail(item)">
                    <div class="card-badges">
                        <span v-if="item.viewCnt >= 100 || item.likeCnt >= 50" class="badge-best">BEST</span>
                        <span v-if="item.isPaid == 1" class="badge badge-paid">유료</span>
                        <span v-else class="badge badge-free">무료</span>
                    </div>

                    <div class="card-img-box">
                        <!-- 오른쪽 상단 PREMIUM 배지 -->
                        <span v-if="item.isPaid == 1" class="badge-premium badge-premium-overlay">PREMIUM</span>
                        <img :src="item.thumbnailUrl || '/images/marryviewlogo_v3.png'" 
                            :class="{'default-logo': !item.thumbnailUrl, 'is-blurred': shouldBlur(item)}"
                            @error="(e) => e.target.src = '/images/marryviewlogo_v3.png'"
                            alt="리뷰 썸네일">
                            <div v-if="shouldBlur(item)" class="premium-lock-guide">
                                <i class="fas fa-lock"></i>
                                <strong>유료 리뷰</strong>
                                <span>열람권을 사용하면 확인할 수 있습니다.</span>
                            </div>
                    </div>

                    <div class="card-body-custom">
                        <div class="card-com-name">{{ item.comName }}</div>
                        <h5 class="card-review-title">
                            {{ item.title }}
                            <span v-if="item.commentCnt > 0" class="comment-count">[{{ item.commentCnt }}]</span>
                        </h5>
                        
                        <div class="card-stats">
                            <span class="text-warning"><i class="fas fa-star mr-1"></i>{{ parseFloat(item.rating || 0).toFixed(1) }}</span>
                            <span><i class="fas fa-heart mr-1"></i>{{ item.likeCnt || 0 }}</span>
                            <span><i class="far fa-eye mr-1"></i>{{ item.viewCnt }}</span>
                        </div>

                        <div class="card-info-row">
                            <div class="nickname-container" 
                            @mouseenter="fnShowHover(item.userId, item.reviewNo)" 
                            @mouseleave="fnHideHover">
                            
                            <a v-if="item.nickname !== '탈퇴회원'" 
                            :href="'/userProfile.do?userId=' + item.userId" 
                            class="nickname-link">
                                <span class="nickname">@{{ item.nickname }}</span>
                            </a>
                            <b v-else class="text-danger">@{{ item.nickname }}</b>

                            <div v-if="hoverUserId === item.userId 
                                        && hoverReviewNo === item.reviewNo 
                                        && hoverInfo"
                                class="profile-hover-modal">

                                <div style="text-align:center;">

                                    <img
                                        :src="'/img/profile/' + (hoverInfo.info.profileImg || 'heart.png')"
                                        style="
                                            width:50px;
                                            height:50px;
                                            border-radius:50%;
                                            object-fit:cover;
                                            display:block;
                                            margin:0 auto;
                                        ">

                                    <div class="mt-2 font-weight-bold">
                                        {{ hoverInfo.info.nickName }}
                                    </div>

                                    <div style="font-size:12px;color:#666;">
                                        게시글 {{ hoverInfo.postTotal }}
                                        |
                                        리뷰 {{ hoverInfo.reviewTotal }}
                                    </div>

                                </div>

                            </div>
                        </div>
                           
                            <span>{{ item.regDate }}</span>
                        </div>
                    </div>
                </div>
            </div>

            <div v-if="list.length == 0" class="py-5 text-center bg-light rounded border">
                <p class="text-muted mb-0">조건에 맞는 리뷰가 아직 없습니다.</p>
            </div>

            <div class="d-flex justify-content-center mt-4">
                <nav class="mt-4">
                    <ul class="pagination justify-content-center">
                        <li class="page-item" :class="{disabled: currentPage === 1}">
                            <a class="page-link" href="javascript:;" @click.prevent="fnPageChange(1)">&laquo;</a>
                        </li>
                        <li class="page-item" :class="{disabled: currentPage === 1}">
                            <a class="page-link" href="javascript:;" @click.prevent="currentPage > 1 && fnPageChange(currentPage - 1)">이전</a>
                        </li>
                        <li class="page-item" v-for="page in pageNumbers" :key="page" :class="{active: currentPage === page}">
                            <a class="page-link" href="javascript:;" @click.prevent="fnPageChange(page)">{{ page }}</a>
                        </li>
                        <li class="page-item" :class="{disabled: currentPage === totalPageCount}">
                            <a class="page-link" href="javascript:;" @click.prevent="currentPage < totalPageCount && fnPageChange(currentPage + 1)">다음</a>
                        </li>
                        <li class="page-item" :class="{disabled: currentPage === totalPageCount}">
                            <a class="page-link" href="javascript:;" @click.prevent="fnPageChange(totalPageCount)">&raquo;</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </main>