<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="detail-container" v-if="info">
            <div class="border-bottom pb-3 mb-4">
                <div class="d-flex justify-content-between align-items-start">
                    <span :class="info.isPaid == 1 ? 'badge-paid-detail' : 'badge-free-detail'">
                        {{ info.isPaid == 1 ? '유료리뷰' : '무료리뷰' }}
                    </span>
                    
                    <div v-if="info.userId !== sessionId && info.nickname !== '탈퇴회원'">
                        <button class="btn btn-sm btn-outline-secondary border-0" @click="openReportModal('REVIEW', reviewNo, info.userId)">
                            <i class="fas fa-bullhorn icon-pink mr-1"></i> <span class="small text-muted">신고</span>
                        </button>
                    </div>
                </div>
                <h2 class="mt-3 review-title">{{ info.title }}</h2>
                <div class="d-flex justify-content-between align-items-center flex-wrap">
                    <small class="text-muted">
                        작성자:
                        <a v-if="info.nickname !== '탈퇴회원'"
                            :href="'/userProfile.do?userId=' + info.userId" class="text-decoration-none text-dark">
                            <b :class="{'text-danger': info.nickname === '탈퇴회원'}">{{ info.nickname }}</b>
                        </a>
                        <b v-else class="text-danger">{{ info.nickname }}</b>
                        <span class="review-meta-divider">|</span> {{ info.regDate }}
                    </small>
                    <small class="text-muted">
                        <small class="text-muted d-flex align-items-center review-meta-right">
                            <span><i class="far fa-eye"></i> {{ info.viewCnt }}</span>
                            <span><i class="far fa-heart icon-pink"></i> {{ info.likeCnt }}</span>
                        </small>
                    </small>
                </div>
            </div>

            <div class="info-card-container p-4">
                <div class="d-flex justify-content-between mb-3 info-top-row">

                    <!-- 업체 정보 -->
                    <div class="info-left-section">
                        <div class="evaluation-header mb-2">
                            <i class="fas fa-check-circle text-secondary"></i>
                            <span class="ml-1 section-header-label">업체 정보</span>
                        </div>
                        <div class="info-left-box">
                            <div class="row no-gutters">
                                <div class="col-6 mb-2">
                                    <span class="eval-label"><i class="fas fa-store mr-1 icon-pink"></i> 업체 :</span>
                                    <span class="eval-val font-weight-bold ml-1">{{info.comName || info.externalName}}</span>
                                </div>
                                <div class="col-6 mb-2" v-if="info.productName">
                                    <span class="eval-label"><i class="fas fa-box-open mr-1 icon-pink"></i> 이용 상품 :</span>
                                    <span class="text-primary font-weight-bold ml-1">{{ info.productName }}</span>
                                </div>
                                <div class="col-6 mb-2">
                                    <span class="eval-label"><i class="fas fa-won-sign mr-1 icon-pink"></i> 비용 :</span>
                                    <span class="eval-val font-weight-bold ml-1">{{ Number(info.totalCost || 0).toLocaleString() }}원</span>
                                </div>
                                <div class="col-6 mb-2">
                                    <span class="eval-label"><i class="fas fa-star mr-1 text-warning"></i> 작성자 평점 :</span>
                                    <span class="eval-val font-weight-bold ml-1">{{ info.rating }} / 5</span>
                                </div>
                                <div class="col-6" v-if="info.avgCompanyRating > 0">
                                    <span class="eval-label"><i class="fas fa-star mr-1 text-primary"></i> 업체 평균 평점 :</span>
                                    <span class="font-weight-bold text-primary ml-1">{{ parseFloat(info.avgCompanyRating).toFixed(1) }} / 5</span>
                                </div>
                                <div class="col-6">
                                    <span class="eval-label"><i class="fas fa-link mr-1 icon-pink"></i> 경로 :</span>
                                    <span class="eval-val font-weight-bold ml-1">{{ info.bookingSource }}</span>
                                </div>
                            </div>
                        </div>
                    </div> 

                    <!-- 서비스 상세 평가 -->
                    <div class="evaluation-box-wrapper">
                        <div class="evaluation-header mb-2">
                            <i class="fas fa-check-circle text-secondary"></i>
                            <span class="ml-1 section-header-label">서비스 상세 평가</span>
                        </div>
                        <div class="evaluation-card p-3 border rounded evaluation-card-bg">
                            <div class="row no-gutters">
                                <div class="col-6 mb-2">
                                    <span class="eval-label"><i class="fas fa-tshirt mr-1"></i> 상품 상태 :</span>
                                    <span class="eval-val font-weight-bold ml-1">{{ info.dressCondition }}</span>
                                </div>
                                <div class="col-6 mb-2">
                                    <span class="eval-label"><i class="fas fa-user-tie mr-1"></i> 전문성 :</span>
                                    <span class="eval-val font-weight-bold ml-1">{{ info.professionalism }}</span>
                                </div>
                                <div class="col-6">
                                    <span class="eval-label"><i class="fas fa-hourglass-half mr-1"></i> 대기 시간 :</span>
                                    <span class="eval-val font-weight-bold ml-1" :class="info.waitingTimeStatus === 'Y' ? 'text-danger' : ''">
                                        {{ info.waitingTimeStatus === 'Y' ? info.waitingDuration : '없음' }}
                                    </span>
                                </div>
                                <div class="col-6">
                                    <span class="eval-label"><i class="fas fa-money-bill-wave mr-1"></i> 추가금 강요 :</span>
                                    <span class="eval-val font-weight-bold ml-1" :class="info.extraChargeForce === 'Y' ? 'text-danger' : ''">
                                        {{ info.extraChargeForce === 'Y' ? '있음' : '없음' }}
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

                <!-- 하단: AI 요약 전체 너비 -->
                <div id="ai-summary-box" class="p-4 border rounded shadow-sm ai-summary-box" v-if="aiSummary">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <div class="font-weight-bold ai-summary-title">
                            <i class="fas fa-magic mr-1"></i> ✨ AI 요약
                        </div>
                        <button class="btn-summary-toggle" @click="isSummaryOpen = !isSummaryOpen">
                            {{ isSummaryOpen ? '접기 ▲' : '펼치기 ▼' }}
                        </button>
                    </div>
                    <div v-show="isSummaryOpen" class="mt-2 text-muted ai-summary-content">
                        {{ aiSummary }}
                    </div>
                </div>
                <div id="ai-loading-box" class="p-4 border rounded shadow-sm text-center ai-summary-box" v-else-if="!aiSummary && !errorOccurred">
                    <div class="spinner-border spinner-border-sm text-primary mr-2" role="status"></div>
                    <span>AI가 리뷰를 요약하고 있습니다...</span>
                </div>

            </div>
            

            <!-- 관리자 전용 정보 박스 (영수증 및 관리 데이터) -->
            <div v-if="sessionRole === 'ADMIN'" class="admin-only-box">
                <span class="admin-badge"><i class="fas fa-user-shield"></i> 관리자 전용 확인란</span>
                
                <div class="row">
                    <!-- 왼쪽: 영수증 이미지 -->
                    <div class="col-md-6 border-right">
                        <h6 class="admin-receipt-title"><i class="fas fa-receipt mr-2"></i>첨부 영수증 내역</h6>
                        <div v-if="imgList.length > 0" class="img-wrapper text-center">
                            <img v-for="(src, index) in imgList" 
                                :key="index" 
                                :src="src" 
                                class="review-img single-img shadow-sm mb-2" 
                                style="max-height: 300px; width: auto; cursor: pointer;"
                                @click="fnOpenImage(src)">
                            <p class="small text-muted mt-2">이미지를 클릭하면 크게 볼 수 있습니다.</p>
                        </div>
                        <div v-else class="text-center py-4 text-muted">
                            첨부된 영수증 이미지가 없습니다.
                        </div>
                    </div>

                    <!-- 오른쪽: 관리용 세부 정보 -->
                    <div class="col-md-6">
                        <h6 class="admin-receipt-title"><i class="fas fa-database mr-2"></i>시스템 관리 정보</h6>
                        <div class="admin-info-item">
                            <span class="text-muted small">작성자 고유 ID</span>
                            <span class="font-weight-bold">{{ info.userId }}</span>
                        </div>
                        <div class="admin-info-item">
                            <span class="text-muted small">리뷰 번호</span>
                            <span># {{ reviewNo }}</span>
                        </div>
                        
                        <!-- 추가적으로 관리자가 알아야 할 DB 정보가 있다면 여기에 배치 -->
                    </div>
                </div>
            </div>

            <div class="review-content" v-html="info.content"></div>

            <div class="text-center">
                <button class="btn btn-list mr-2 px-4" @click="fnBack">
                    <i class="fas fa-list mr-1"></i>목록으로
                </button>
        
                <button :class="info.isLiked > 0 ? 'btn-like-cancel' : 'btn-like'"
                        class="btn px-5 shadow-sm"
                        @click="info.nickname !== '탈퇴회원' ? fnLike() : null"
                        :style="info.nickname === '탈퇴회원' ? 'cursor: default; opacity: 0.5;' : ''">
                    <i class="fas fa-heart mr-1"></i> {{ info.isLiked > 0 ? '좋아요 취소' : '좋아요' }} {{ info.likeCnt }}
                </button>
            </div>

            <div class="comment-section">
                <h5 class="mb-4">댓글 <span class="comment-count">{{ commentList.length }}</span></h5>
                <div class="comment-list">
                    <div v-for="item in commentList" :key="item.commentNo" :class="['comment-item', item.parentNo ? 'reply-item' : '']">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span v-if="item.parentNo" class="reply-mark">ㄴ</span>
                                <span class="comment-user">
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
                                </span>
                                <span class="comment-date">{{ item.regDate }}</span>
                                
                                <span v-if="item.isDeleted == 0 && item.nickname !== '탈퇴회원' && info.nickname !== '탈퇴회원'" 
                                    class="comment-like-btn ml-3" @click="fnCommentLike(item)">
                                    <i :class="item.isLiked > 0 ? 'fas fa-heart icon-pink' : 'far fa-heart comment-heart'"></i>
                                    <small :class="{'like-active': item.isLiked > 0}">{{ item.likeCnt }}</small>
                                </span>
                            </div>

                            <div v-if="item.isDeleted == 0" class="comment-action-btns">
                                <template v-if="item.nickname !== '탈퇴회원' && info.nickname !== '탈퇴회원'">
                                    <span v-if="!item.parentNo" @click="fnShowReply(item.commentNo)">
                                        <i class="far fa-comment-dots"></i> {{ replyTo === item.commentNo ? '취소' : '답글' }}
                                    </span>

                                    <span v-if="item.userId !== sessionId && sessionRole !== 'ADMIN'" 
                                        @click="openReportModal('COMMENT', item.commentNo, item.userId)" 
                                        class="report-link icon-pink">
                                        <i class="fas fa-exclamation-triangle"></i> 신고
                                    </span>
                                </template>

                                <span v-if="item.userId === sessionId && !item.isEdit" @click="fnEditMode(item)">
                                    <i class="far fa-edit"></i> 수정
                                </span>
                                <span v-if="(item.userId === sessionId || sessionRole === 'ADMIN') && !item.isEdit" 
                                    @click="fnDeleteComment(item.commentNo)">
                                    <i class="far fa-trash-alt"></i> 삭제
                                </span>
                            </div>
                        </div>

                        <div v-if="item.isDeleted == 0">
                            <div v-if="!item.isEdit" class="comment-content">
                                <template v-if="item.nickname === '탈퇴회원'">
                                    <span class="text-muted font-italic">탈퇴한 사용자의 댓글입니다.</span>
                                </template>
                                <template v-else>
                                <div>{{ item.content }}</div>

                                <img v-if="item.imgUrl"
                                    :src="item.imgUrl"
                                    class="comment-uploaded-image mt-2"
                                    alt="댓글 첨부 이미지"
                                    @click="fnOpenImage(item.imgUrl)">
                            </template>
                            </div>
                            
                            <div v-else class="mt-2">
                                <textarea class="form-control edit-textarea" v-model="item.content" rows="2"></textarea>
                                <div class="text-right mt-2">
                                    <button class="btn btn-sm btn-cancel mr-1" @click="fnCancelEdit(item)">취소</button>
                                    <button class="btn btn-sm btn-comment" @click="fnUpdateComment(item)">수정완료</button>
                                </div>
                            </div>
                        </div>

                        <div v-else class="comment-content mt-2">
                            <template v-if="item.delRole === 'ADMIN'">
                                <span class="text-danger font-italic">
                                    <i class="fas fa-ban"></i> 관리자에 의해 삭제된 댓글입니다.
                                </span>
                            </template>
                            <template v-else>
                                <span class="text-muted">삭제된 댓글입니다.</span>
                            </template>
                        </div>

                        <div v-if="item.isDeleted == 0 && replyTo === item.commentNo && item.nickname !== '탈퇴회원' && info.nickname !== '탈퇴회원'" 
                            class="mt-3 p-3 bg-white border rounded shadow-sm">
                            <textarea class="form-control" v-model="replyContent" rows="2" :placeholder="item.userId + '님께 답글 남기기...'"></textarea>
                            <div v-if="replyPreview" class="comment-image-preview-box mt-2">
                                <img :src="replyPreview" class="comment-image-preview">

                                <button type="button"
                                        class="btn btn-sm btn-light border ml-2"
                                        @click="fnRemoveReplyImage">
                                    이미지 취소
                                </button>
                            </div>

                            <div class="d-flex justify-content-between align-items-center mt-2">
                                <div>
                                    <input type="file"
                                        ref="replyFileInput"
                                        accept="image/*"
                                        style="display:none;"
                                        @change="fnSelectReplyImage">

                                    <button type="button"
                                            class="btn btn-sm btn-light border"
                                            @click="$refs.replyFileInput.click()">
                                        <i class="far fa-image icon-pink"></i>
                                        사진 첨부
                                    </button>
                                </div>

                                <button class="btn btn-sm btn-comment"
                                        @click="fnSaveReply(item.commentNo)">
                                    답글 등록
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="comment-input-box shadow-sm mt-4"
                    v-if="info.nickname !== '탈퇴회원'">

                    <textarea class="form-control mb-2"
                            v-model="newComment"
                            rows="3"
                            placeholder="댓글을 입력해 주세요."></textarea>

                    <!-- 이미지 미리보기 -->
                    <div v-if="commentPreview" class="comment-image-preview-box mb-2">
                        <img :src="commentPreview" class="comment-image-preview">

                        <button type="button"
                                class="btn btn-sm btn-light border ml-2"
                                @click="fnRemoveCommentImage">
                            이미지 취소
                        </button>
                    </div>

                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <input type="file"
                                ref="commentFileInput"
                                accept="image/*"
                                style="display:none;"
                                @change="fnSelectCommentImage">

                            <button type="button"
                                    class="btn btn-sm btn-light border"
                                    @click="$refs.commentFileInput.click()">
                                <i class="far fa-image icon-pink"></i>
                                사진 첨부
                            </button>
                        </div>

                        <button class="btn btn-comment px-4 py-2"
                                @click="fnAddComment">
                            댓글 등록
                        </button>
                    </div>
                </div>
                
                <div v-else class="alert alert-light text-center mt-4 border">
                    <i class="fas fa-info-circle text-muted"></i> 탈퇴한 사용자의 리뷰에는 댓글을 남길 수 없습니다.
                </div>
            </div>

             <ul class="post-navigation">
                <!-- 다음글 (위쪽) -->
                <li v-if="reviewDetail && reviewDetail.nextNo" @click="fnGoDetail(reviewDetail.nextNo)">
                    <span class="nav-label">Next</span>
                    <span class="nav-arrow nav-arrow-none">▲</span>
                    <span class="nav-title">{{ reviewDetail.nextTitle }}</span>
                </li>
                <li v-else class="nav-none">
                    <span class="nav-label">Next</span>
                    <span class="nav-arrow nav-arrow-none">▲</span>
                    <span class="nav-title">다음 글이 없습니다.</span>
                </li>

                <!-- 이전글 (아래쪽) -->
                <li v-if="reviewDetail && reviewDetail.prevNo" @click="fnGoDetail(reviewDetail.prevNo)">
                    <span class="nav-label">Prev</span>
                    <span class="nav-arrow nav-arrow-none">▼</span>
                    <span class="nav-title">{{ reviewDetail.prevTitle }}</span>
                </li>
                <li v-else class="nav-none">
                    <span class="nav-label">Prev</span>
                    <span class="nav-arrow nav-arrow-none">▼</span>
                    <span class="nav-title">이전 글이 없습니다.</span>
                </li>
            </ul>
        </div>

       

        <div class="modal fade" id="reportModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-exclamation-circle mr-1"></i> 신고하기
                        </h5>
                        <button type="button" class="close text-white" data-dismiss="modal"><span>&times;</span></button>
                    </div>
                    <div class="modal-body">
                        <p class="small text-muted">허위 신고 시 서비스 이용에 제한을 받을 수 있습니다.</p>
                        
                        <div class="form-group">
                            <label><b>신고 제목</b></label>
                            <input type="text" class="form-control" v-model="reportData.title" placeholder="신고 제목을 입력해 주세요.">
                        </div>

                        <div class="form-group">
                            <label><b>신고 사유 선택</b></label>
                            <select class="form-control" v-model="reportData.reason" @change="fnHandleReasonChange">
                                <option value="">사유를 선택해 주세요</option>
                                <option v-for="opt in reportOptions" :key="opt" :value="opt">{{ opt }}</option>
                                <option value="직접 입력">직접 입력</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label><b>상세 신고 내용</b></label>
                            <textarea class="form-control" v-model="reportData.customReason" rows="3" 
                                      :disabled="reportData.reason === ''" 
                                      placeholder="상세 사유를 입력해 주세요."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-light border" data-dismiss="modal">취소</button>
                        <button type="button" class="btn btn-report-submit" @click="fnSubmitReport">신고 제출</button>
                    </div>
                </div>
            </div>
        </div>