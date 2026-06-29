<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<main class="main-content">
            <template v-if="post && post.postNo">
                <div class="post-card">
                    <!-- 게시글 헤더 -->
                    <div class="post-header">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span :class="['category-tag', 'cate-' + (post.category || 'default')]">
                                # {{ post.category || '일반' }}
                            </span>
                            <button v-if="sessionId && post.userId !== sessionId && post.nickname !== '탈퇴회원'" 
                                    class="btn-report" 
                                    @click="fnOpenReportModal('POST', post.postNo, post.userId)">
                                <i class="fas fa-exclamation-circle"></i> 신고하기
                            </button>
                        </div>
                        <h2 class="post-title">{{ post.title }}</h2>
                        <div class="post-info">
                            <a 
                            v-if="post.nickname !== '탈퇴회원'"
                            :href="'/userProfile.do?userId=' + post.userId" class="nickname-link">
                                <span class="author-name">@{{ post.nickname }}</span>
                            </a>
                            <b v-else class="text-danger">{{ post.nickname }}</b>
                            <span class="text-light">|</span>
                            <span>{{ formatTime(post.regDate) }}</span>
                            <span class="text-light">|</span>
                            <span>조회 {{ post.viewCnt }}</span>
                        </div>
                    </div>

                    <!-- 게시글 본문 -->
                    <div class="post-content" v-html="post.content"></div>

                    <!-- 하단 반응/버튼 -->
                    <div class="bottom-area">
                        <button class="btn-like" @click="post.nickname !== '탈퇴회원' ? fnPostLike() : null"
                            :style="post.nickname === '탈퇴회원' ? 'cursor: default; opacity: 0.7;' : ''">
                            <i :class="post && post.isLiked > 0 ? 'fas fa-heart' : 'far fa-heart'"></i>
                            좋아요 {{ post.likeCnt || 0 }}
                        </button>
                        
                        <div class="right-btns">
                            <button class="btn-list" @click="fnGoList">목록으로</button>
                            <button v-if="post.userId === sessionId" class="btn-edit" @click="fnEdit">수정</button>
                            <button v-if="post.userId === sessionId || sessionRole === 'ADMIN'" 
                                    class="btn-delete" 
                                    @click="fnRemove">
                                삭제
                            </button>
                        </div>
                    </div>
                </div>

                <!-- 댓글 섹션 -->
                <div class="comment-section">
                    <h5 class="comment-title">댓글 <b>{{ commentList.length }}</b></h5>
                    
                    <!-- 댓글 입력 -->
                    <div class="comment-write-box mb-5"
                        v-if="sessionId && post.nickname !== '탈퇴회원'">

                        <textarea v-model="newComment"
                                class="form-control"
                                placeholder="따뜻한 댓글을 남겨주세요."
                                rows="3"></textarea>

                        <!-- 첨부 이미지 미리보기 -->
                        <div v-if="commentPreview" class="comment-image-preview-box">
                            <img :src="commentPreview"
                                class="comment-image-preview"
                                alt="첨부 이미지 미리보기">

                            <button type="button"
                                    class="comment-image-remove"
                                    @click="fnRemoveCommentImage">
                                이미지 취소
                            </button>
                        </div>

                        <div class="comment-file-area">
                            <div>
                                <input type="file"
                                    ref="commentFileInput"
                                    accept="image/*"
                                    style="display:none;"
                                    @change="fnSelectCommentImage">

                                <button type="button"
                                        class="comment-file-btn"
                                        @click="$refs.commentFileInput.click()">
                                    <i class="far fa-image"></i>
                                    사진 첨부
                                </button>
                            </div>

                            <button class="btn-primary-sm"
                                    @click="fnAddComment(null)">
                                등록하기
                            </button>
                        </div>
                    </div>
                    <div v-else-if="post.nickname === '탈퇴회원'" class="alert alert-light text-center py-4" style="border-radius: 20px;">
                        탈퇴한 사용자의 게시글에는 댓글을 작성할 수 없습니다.
                    </div>

                    <!-- 댓글 리스트 -->
                    <div class="comment-list">
                        <div v-for="item in commentList" :key="item.commentNo" :class="['comment-item', { 'is-reply': item.parentNo }]">
                            <div class="comment-header">
                                <div>
                                    <!-- 정상 댓글 -->
                                    <template v-if="item.isDeleted == 0 && item.nickname !== '탈퇴회원'">
                                        <div class="nickname-container"
                                            @mouseenter="fnShowHover(item.userId)"
                                            @mouseleave="fnHideHover">
                                            <a :href="'/userProfile.do?userId=' + item.userId"
                                            class="nickname-link">
                                                @{{ item.nickname }}
                                            </a>
                                            <div v-if="hoverUserId === item.userId && hoverInfo"
                                                class="profile-hover-modal">
                                                <div style="text-align:center;">
                                                    <img
                                                        :src="'/img/profile/' + (hoverInfo.info.profileImg || 'heart.png')"
                                                        style="width:50px;height:50px;border-radius:50%;object-fit:cover;">
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
                                    </template>
                                    <!-- 탈퇴회원 -->
                                    <template v-else-if="item.nickname === '탈퇴회원'">
                                        <span class="text-danger">탈퇴회원</span>
                                    </template>
                                    <!-- 관리자 삭제 -->
                                    <template v-else-if="item.delRole === 'ADMIN'">
                                        <span class="text-muted">[관리자 삭제]</span>
                                    </template>
                                    <!-- 일반 삭제 -->
                                    <template v-else>
                                        <span class="text-muted">[삭제된 댓글]</span>
                                    </template>
                                </div>

                                <span class="text-muted small">
                                    {{ formatTime(item.regDate) }}
                                </span>

                            </div>

                            <div class="comment-body mt-2">
                                <template v-if="item.isDeleted == 1">
                                    <span class="text-muted" style="font-style: italic;">삭제된 댓글입니다.</span>
                                </template>
                                <template v-else-if="item.nickname === '탈퇴회원'">
                                    <span class="text-muted" style="font-style: italic;">탈퇴한 사용자의 댓글입니다.</span>
                                </template>
                                <template v-else>
                                    <!-- [수정 기능 추가] 수정 모드가 아닐 때 -->
                                    <div v-if="!item.isEdit">
                                        <div>{{ item.content }}</div>

                                        <img v-if="item.imgUrl"
                                            :src="item.imgUrl"
                                            class="comment-uploaded-image"
                                            alt="댓글 첨부 이미지"
                                            @click="fnOpenCommentImage(item.imgUrl)">
                                    </div>
                                    <!-- [수정 기능 추가] 수정 모드일 때 -->
                                    <div v-else class="edit-box">
                                        <textarea v-model="item.content" class="form-control mb-2" rows="2"></textarea>
                                        <div class="text-right">
                                            <button class="btn btn-xs btn-light border mr-1" @click="item.isEdit = false">취소</button>
                                            <button class="btn btn-xs btn-dark" @click="fnUpdateComment(item)">수정완료</button>
                                        </div>
                                    </div>
                                </template>
                            </div>

                            <div class="comment-footer" v-if="item.isDeleted == 0 && !item.isEdit">
                                <template v-if="post.nickname !== '탈퇴회원' && item.nickname !== '탈퇴회원'">
                                    <span class="comment-like-btn" @click="fnCommentLike(item)">
                                        <i :class="item.isLiked > 0 ? 'fas fa-heart text-danger' : 'far fa-heart'"></i>
                                        <b>{{ item.likeCnt }}</b>
                                    </span>
                                    
                                    <span class="action-link" v-if="!item.parentNo && sessionId" @click="item.showReply = !item.showReply">답글달기</span>
                                    
                                    <span class="action-link" 
                                          v-if="sessionId && item.userId !== sessionId && sessionRole !== 'ADMIN'" 
                                          @click="fnOpenReportModal('COMMENT', item.commentNo, item.userId)">
                                        신고
                                    </span>
                                </template>

                                <span class="action-link" v-if="item.userId === sessionId" @click="fnEditMode(item)">수정</span>
                                <span class="action-link" v-if="item.userId === sessionId || sessionRole === 'ADMIN'" @click="fnRemoveComment(item.commentNo)">삭제</span>
                            </div>

                            <!-- 답글 입력창 -->
                            <div class="mt-3 p-3 bg-white shadow-sm rounded"
                                v-if="item.isDeleted == 0
                                    && item.showReply
                                    && item.nickname !== '탈퇴회원'
                                    && post.nickname !== '탈퇴회원'">

                                <textarea v-model="item.replyContent"
                                        class="form-control border-0 bg-light"
                                        rows="2"
                                        placeholder="답글을 작성하세요..."></textarea>

                                <!-- 대댓글 이미지 미리보기 -->
                                <div v-if="item.replyPreview" class="comment-image-preview-box">
                                    <img :src="item.replyPreview"
                                        class="comment-image-preview"
                                        alt="답글 이미지 미리보기">

                                    <button type="button"
                                            class="comment-image-remove"
                                            @click="fnRemoveReplyImage(item)">
                                        이미지 취소
                                    </button>
                                </div>

                                <div class="comment-file-area">
                                    <div>
                                        <input type="file"
                                            :ref="'replyFileInput_' + item.commentNo"
                                            accept="image/*"
                                            style="display:none;"
                                            @change="fnSelectReplyImage($event, item)">

                                        <button type="button"
                                                class="comment-file-btn"
                                                @click="fnOpenReplyFileInput(item)">
                                            <i class="far fa-image"></i>
                                            사진 첨부
                                        </button>
                                    </div>

                                    <button class="btn btn-sm btn-dark px-3"
                                            @click="fnAddComment(item)">
                                        답글 등록
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </template>
            
            <div v-else class="text-center py-5">
                <div class="spinner-border text-danger mb-3" role="status"></div>
                <p class="text-muted">게시글을 소중히 불러오고 있습니다...</p>
            </div>
        </main>

        <!-- 신고 모달 -->
        <div class="modal fade" id="reportModal" tabindex="-1" role="dialog">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content" style="border-radius: 25px; border: none; overflow: hidden;">
                    <div class="modal-header" style="background: #fff; border-bottom: 1px solid #f8f9fa; padding: 25px 30px;">
                        <h5 class="modal-title font-weight-bold">신고 접수</h5>
                        <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                    </div>
                    <div class="modal-body" style="padding: 30px;">
                        <div class="form-group mb-4">
                            <label class="small font-weight-bold text-muted">신고 제목</label>
                            <input type="text" v-model="reportInfo.report_title" class="form-control border-0 bg-light" style="border-radius: 12px; padding: 12px;" placeholder="사유를 간단히 입력하세요.">
                        </div>
                        <div class="form-group">
                            <label class="small font-weight-bold text-muted">상세 신고 내용</label>
                            <textarea v-model="reportInfo.report_content" class="form-control border-0 bg-light" style="border-radius: 12px; padding: 12px;" rows="5" placeholder="신고 사유를 구체적으로 적어주시면 관리에 큰 도움이 됩니다."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer" style="border-top: none; padding: 0 30px 30px;">
                        <div class="row w-100 m-0">
                            <div class="col-6 pl-0 pr-2">
                                <button type="button" class="btn btn-light w-100 py-3" style="border-radius: 15px; font-weight: 700;" data-dismiss="modal">취소</button>
                            </div>
                            <div class="col-6 pr-0 pl-2">
                                <button type="button" class="btn btn-danger w-100 py-3" style="border-radius: 15px; background: var(--primary-color); border:none; font-weight: 700;" @click="fnSubmitReport">제출하기</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
