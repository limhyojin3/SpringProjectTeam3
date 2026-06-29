<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<main class="main-content">
            <!-- 상단 헤더 -->
            <header class="header-area">
                <h2><i class="fas fa-comments mr-3"></i>Marry Community</h2>
                <p>예비 부부들의 생생한 이야기와 꿀팁을 확인하세요.</p>
            </header>

            <!-- 카테고리 탭 -->
            <div class="category-tabs">
                <div v-for="cate in categoryList" :key="cate.value"
                    :class="['tab-item', { active: searchCategory === cate.value }]"
                    @click="fnChangeCategory(cate.value)">
                    <i v-if="cate.icon" :class="['fas', cate.icon, 'mr-1']"></i>
                    {{ cate.label }}
                </div>
            </div>
            <!-- 인기글 -->
            <div class="popular-board mb-5" v-show="popularList.length > 0">
                <div class="popular-title">
                    <i class="fas fa-fire mr-2"></i>실시간 인기글
                </div>
                <div class="popular-item"
                    v-for="(item,index) in popularList"
                    :key="item.postNo"
                    @click="fnDetail(item.postNo)">

                    <span class="popular-rank" v-html="getRank(index)"></span>

                    <span class="popular-subject">
                        {{ item.title }}
                    </span>

                    <span class="popular-stat">
                        <i class="fas fa-heart mr-1"></i>{{ item.likeCnt }}
                        <i class="fas fa-eye ml-2 mr-1"></i>{{ item.viewCnt }}
                    </span>
                </div>
            </div>

            <!-- 정렬 버튼 -->
            <div class="sort-tabs">
                <div :class="['sort-item', { active: sortType === 'latest' }]" @click="fnChangeSort('latest')">
                    <i class="fas fa-clock mr-1"></i>최신순
                </div>
                <div :class="['sort-item', { active: sortType === 'popular' }]" @click="fnChangeSort('popular')">
                    <i class="fas fa-fire mr-1"></i>인기순
                </div>
                <div :class="['sort-item', { active: sortType === 'view' }]" @click="fnChangeSort('view')">
                    <i class="fas fa-eye mr-1"></i>조회순
                </div>
                <div :class="['sort-item', { active: sortType === 'like' }]" @click="fnChangeSort('like')">
                    <i class="fas fa-heart mr-1"></i>좋아요순
                </div>
            </div>
            <!-- 상단 검색바 -->
            <div class="d-flex justify-content-between align-items-center mb-4 px-3">
                <div class="text-muted small">Total <span class="text-primary font-weight-bold">{{ totalCount }}</span> Posts</div>
                <div class="d-flex">
                    <input type="text" class="form-control search-box" 
                           v-model="searchKeyword" @keyup.enter="fnSearch" placeholder="무엇이든 검색해보세요">
                    <button @click="fnSearch" class="btn btn-search ml-3">검색</button>
                </div>
            </div>

            <!-- 게시판 리스트 -->
            <div class="board-list-container">
                <div class="list-header d-none d-md-flex">
                    <div class="col-no">No.</div>
                    <div class="col-cate">Category</div>
                    <div class="col-title">Subject</div>
                    <div class="col-date">Date</div>
                </div>

                <div v-for="item in list" :key="item.postNo" class="list-item" @click="fnDetail(item.postNo)">
                    <div class="col-no">{{ item.postNo }}</div>

                    <div class="col-cate">
                        <span :class="['badge-cate', 'cate-' + (item.category || 'default')]">
                            {{ getCategoryLabel(item.category) || '기타' }}
                        </span>
                    </div>

                    <div class="col-title">
                        <div class="title-main">
                            <span v-if="popularList.length > 0 && item.postNo === popularList[0].postNo" class="badge-king">
                                <i class="fas fa-crown mr-1"></i>KING
                            </span>
                            <span v-else-if="bestPosts.includes(item.postNo)" class="badge-best">
                                <i class="fas fa-trophy mr-1"></i>BEST
                            </span>
                            <span v-else-if="item.viewCnt >= 100 || item.commentCnt >= 10" class="badge-hot">
                                <i class="fas fa-fire mr-1"></i>HOT
                            </span>

                            {{ item.title }}

                            <span v-if="item.imgYn === 'Y'" style="margin-left:8px;color:#ff4d6d;font-size:.9rem;">
                                <i class="fas fa-image"></i>
                            </span>

                            <span v-if="item.commentCnt > 0" class="comment-count">
                                ({{ item.commentCnt }})
                            </span>
                        </div>

                        <div class="title-meta" @click.stop>
                            <span class="nickname-container"
                                @mouseenter="fnShowHover(item.userId, item.postNo)"
                                @mouseleave="fnHideHover">

                                <a v-if="item.nickname !== '탈퇴회원'"
                                    :href="'/userProfile.do?userId=' + item.userId"
                                    class="nickname-link meta-nickname">
                                    @{{ item.nickname }}
                                </a>

                                <b v-else class="text-danger meta-nickname">
                                    @{{ item.nickname }}
                                </b>

                                <div v-if="hoverUserId === item.userId && hoverPostNo === item.postNo && hoverInfo"
                                    class="profile-hover-modal">

                                    <div style="text-align:center;">
                                        <img
                                            :src="'/img/profile/' + (hoverInfo.info.profileImg || 'heart.png')"
                                            style="width:50px;height:50px;border-radius:50%;object-fit:cover;display:block;margin:0 auto;">

                                        <div class="mt-2 font-weight-bold">
                                            {{ hoverInfo.info.nickName }}
                                        </div>

                                        <div style="font-size:12px;color:#666;">
                                            게시글 {{ hoverInfo.postTotal }} | 리뷰 {{ hoverInfo.reviewTotal }}
                                        </div>
                                    </div>
                                </div>
                            </span>

                            <span>·</span>
                            조회 {{ item.viewCnt }}
                            <span>·</span>
                            좋아요 {{ item.likeCnt }}
                        </div>
                    </div>
                    <div class="col-date">
                        {{ formatTime(item.regDate) }}
                    </div>
                </div>
                <div v-if="list.length == 0" class="text-center p-5">
                    <div class="mb-3" style="font-size:50px;opacity:.3;">
                        <i class="fas fa-folder-open"></i>
                    </div>
                    <p style="color:#999;font-weight:500;">작성된 게시물이 없습니다.</p>
                </div>
            </div>
            <!-- 페이지네이션 -->
            <nav class="mt-5">
                <ul class="pagination justify-content-center">
                    <li class="page-item" :class="{disabled: currentPage === 1}">
                        <a class="page-link" href="javascript:;" @click="fnPageChange(currentPage - 1)">
                            <i class="fas fa-chevron-left"></i>
                        </a>
                    </li>
                    <li class="page-item" v-for="page in pageNumbers" :key="page" :class="{active: currentPage === page}">
                        <a class="page-link" href="javascript:;" @click="fnPageChange(page)">{{ page }}</a>
                    </li>
                    <li class="page-item" :class="{disabled: currentPage === totalPageCount}">
                        <a class="page-link" href="javascript:;" @click="fnPageChange(currentPage + 1)">
                            <i class="fas fa-chevron-right"></i>
                        </a>
                    </li>
                </ul>
            </nav>

            
            <!-- 플로팅 글쓰기 버튼 -->
            <div class="write-btn-wrapper">

                <button class="btn-write" @click="fnAddPage">
                    <i class="fas fa-pen"></i>
                </button>
            </div>
            
        </main>
