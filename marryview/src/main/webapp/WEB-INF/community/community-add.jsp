<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>새 글 작성 - MarryView</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <!-- Quill Editor -->
    <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
    <script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">

    <style>
        :root {
            --primary-color: #e9787e;
            --primary-dark: #d85f68;
            --secondary-color: #ff8fa3;

            --bg-soft: #fff7f8;
            --card-bg: #ffffff;

            --dark-text: #2f2f35;
            --body-text: #55555f;
            --muted-text: #777782;

            --border-color: #eadfe1;
            --focus-color: rgba(233, 120, 126, 0.16);
        }

        body {
            background:
                radial-gradient(circle at 10% 15%, rgba(255, 196, 206, 0.25), transparent 28%),
                radial-gradient(circle at 90% 75%, rgba(244, 160, 150, 0.18), transparent 30%),
                var(--bg-soft);

            color: var(--body-text);
            font-family: "Pretendard", "Malgun Gothic", -apple-system, sans-serif;
        }

        .main-content {
            padding: 60px 20px;
            max-width: 940px;
            margin: 0 auto;
            min-height: 100vh;

            animation: pageFadeUp 0.55s ease both;
        }
        @keyframes pageFadeUp {
            from {
                opacity: 0;
                transform: translateY(18px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        /* 헤더 섹션 */
        .write-header {
            text-align: center;
            margin-bottom: 36px;
        }

        .write-header h2 {
            display: inline-flex;
            align-items: center;

            margin-bottom: 12px;
            color: var(--dark-text);
            font-size: 36px;
            font-weight: 900;
            letter-spacing: -1px;
        }

        .write-header h2 i {
            color: var(--primary-color);
            filter: drop-shadow(0 4px 8px rgba(233, 120, 126, 0.22));
            animation: penFloat 2.5s ease-in-out infinite;
        }
        @keyframes penFloat {
            0%,
            100% {
                transform: translateY(0) rotate(0deg);
            }

            50% {
                transform: translateY(-4px) rotate(-4deg);
            }
        }
        .write-header .sub-title {
            color: var(--muted-text);
            font-size: 16px;
            font-weight: 500;
        }

        /* 작성 카드 레이아웃 */
        .write-card {
            position: relative;
            padding: 45px;

            background: rgba(255, 255, 255, 0.96);
            border: 1px solid var(--border-color);
            border-radius: 24px;

            box-shadow:
                0 18px 50px rgba(98, 68, 73, 0.09),
                0 4px 14px rgba(233, 120, 126, 0.07);

            animation: cardFadeUp 0.65s 0.08s ease both;
        }
        @keyframes cardFadeUp {
            from {
                opacity: 0;
                transform: translateY(22px) scale(0.985);
            }

            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }
        .write-card::before {
            content: "";
            position: absolute;
            top: 0;
            left: 32px;
            right: 32px;

            height: 4px;
            border-radius: 0 0 8px 8px;

            background: linear-gradient(
                90deg,
                var(--primary-color),
                #f7a9b3,
                #ffcad2
            );
        }

       .write-row {
            margin-bottom: 32px;
        }
        .write-row label {
            display: flex;
            align-items: center;

            margin-bottom: 12px;
            color: var(--dark-text);
            font-size: 16px;
            font-weight: 800;
            letter-spacing: -0.2px;
        }

        .write-row label::before {
            content: "";
            width: 4px;
            height: 17px;
            margin-right: 8px;

            background: var(--primary-color);
            border-radius: 5px;
        }

        label { display: block; font-weight: 700; margin-bottom: 12px; color: #444; font-size: 16px; }
        
        /* 카테고리 칩 UI */
        /* 수정된 카테고리 칩 UI */
        .category-group {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .cate-item {
            padding: 10px 18px;

            background: #fff;
            color: #656570;

            border: 1.5px solid #ddd5d7;
            border-radius: 50px;

            cursor: pointer;
            font-weight: 700;
            white-space: nowrap;

            box-shadow: 0 3px 8px rgba(0, 0, 0, 0.035);

            transition:
                transform 0.2s ease,
                border-color 0.2s ease,
                box-shadow 0.2s ease,
                background-color 0.2s ease,
                color 0.2s ease;
        }

        .cate-item:hover {
            color: var(--primary-dark);
            border-color: var(--primary-color);
            transform: translateY(-2px);

            box-shadow: 0 7px 14px rgba(233, 120, 126, 0.12);
        }

        .cate-item.active {
            color: #fff;
            background: linear-gradient(
                135deg,
                var(--primary-color),
                var(--secondary-color)
            );

            border-color: transparent;
            transform: translateY(-2px) scale(1.03);

            box-shadow: 0 8px 18px rgba(233, 120, 126, 0.25);
        }

        /* 제목 입력창 */
        .input-title {
            width: 100%;
            padding: 17px 19px;

            color: var(--dark-text);
            background: #fff;

            border: 1.5px solid #dcd4d6;
            border-radius: 14px;

            font-size: 17px;
            font-weight: 600;
            outline: none;

            transition:
                border-color 0.2s ease,
                box-shadow 0.2s ease,
                transform 0.2s ease;
        }

        .input-title::placeholder {
            color: #aaa5aa;
            font-weight: 400;
        }

        .input-title:hover {
            border-color: #cfc4c7;
        }

        .input-title:focus {
            background: #fff;
            border-color: var(--primary-color);

            box-shadow:
                0 0 0 4px var(--focus-color),
                0 8px 18px rgba(233, 120, 126, 0.08);

            transform: translateY(-1px);
        }

        /* 에디터 커스텀 */
       .ql-toolbar.ql-snow {
            padding: 13px;

            background: #fff8f9;
            border: 1.5px solid #dcd4d6 !important;
            border-bottom: 1px solid #eee4e6 !important;
            border-radius: 14px 14px 0 0;

            transition:
                border-color 0.2s ease,
                box-shadow 0.2s ease;
        }

        .ql-container.ql-snow {
            height: 480px;

            color: var(--dark-text);
            background: #fff;

            border: 1.5px solid #dcd4d6 !important;
            border-top: none !important;
            border-radius: 0 0 14px 14px;

            font-size: 16px;
            line-height: 1.8;

            transition:
                border-color 0.2s ease,
                box-shadow 0.2s ease;
        }

        .ql-editor {
            padding: 22px;
        }

        .ql-editor.ql-blank::before {
            color: #aaa5aa;
            font-style: normal;
        }

        .write-row:focus-within .ql-toolbar.ql-snow {
            border-color: var(--primary-color) !important;
        }

        .write-row:focus-within .ql-container.ql-snow {
            border-color: var(--primary-color) !important;

            box-shadow:
                0 0 0 4px var(--focus-color),
                0 10px 24px rgba(233, 120, 126, 0.08);
        }

        /* 하단 버튼 */
        .write-actions {
            position: sticky;
            bottom: 12px;
            z-index: 20;

            display: flex;
            justify-content: center;
            gap: 14px;

            width: fit-content;
            margin: 30px auto 0;
            padding: 12px;

            background: rgba(255, 255, 255, 0.9);
            border: 1px solid rgba(233, 120, 126, 0.13);
            border-radius: 20px;

            box-shadow: 0 12px 30px rgba(75, 53, 57, 0.12);
            backdrop-filter: blur(12px);

            animation: actionFadeUp 0.7s 0.2s ease both;
        }
        .btn-common {
            min-width: 170px;
            padding: 15px 38px;

            border: none;
            border-radius: 13px;

            cursor: pointer;
            font-size: 16px;
            font-weight: 800;

            transition:
                transform 0.2s ease,
                box-shadow 0.2s ease,
                background-color 0.2s ease;
        }

        .btn-cancel {
            color: #5f5f68;
            background: #eeecee;
        }

        .btn-cancel:hover {
            color: #3e3e45;
            background: #dfdadd;
            transform: translateY(-3px);
        }

        .btn-save {
            color: #fff;

            background: linear-gradient(
                135deg,
                var(--primary-color),
                var(--secondary-color)
            );

            box-shadow: 0 7px 16px rgba(233, 120, 126, 0.22);
        }

        .btn-save:hover:not(:disabled) {
            color: #fff;
            transform: translateY(-3px);

            box-shadow: 0 11px 24px rgba(233, 120, 126, 0.32);
        }

        .btn-common:active:not(:disabled) {
            transform: translateY(0) scale(0.98);
        }

        .btn-save:disabled {
            opacity: 0.65;
            cursor: not-allowed;
            transform: none;
        }

        @keyframes actionFadeUp {
            from {
                opacity: 0;
                transform: translateY(15px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* 모바일 대응 (화면이 작을 때 카드 패딩 축소) */
        @media (max-width: 768px) {
            .main-content {
                padding: 36px 14px;
            }

            .write-header h2 {
                font-size: 29px;
            }

            .write-header .sub-title {
                font-size: 14px;
            }

            .write-card {
                padding: 28px 20px;
                border-radius: 18px;
            }

            .cate-item {
                padding: 9px 14px;
                font-size: 14px;
            }

            .write-actions {
                bottom: 8px;
                width: 100%;
            }

            .btn-common {
                flex: 1;
                min-width: 0;
                padding: 14px 12px;
            }

            .ql-container.ql-snow {
                height: 380px;
            }
        }

        /* 카테고리 칩 아이콘 색상 */
        .cate-item .fa-smile { color: #7eb8d4; }
        .cate-item .fa-gem { color: #f4a096; }
        .cate-item .fa-users { color: #7bc99a; }
        .cate-item .fa-baby { color: #f0c070; }
        .cate-item .fa-comment-dots { color: #b39ddb; }
        .cate-item .fa-briefcase { color: #90a4ae; }

        /* active 시 아이콘 흰색 */
        .cate-item.active i {
            color: white !important;
        }

        /* 헤더 h2 아이콘 인라인 스타일 분리 */
        .write-header h2 i {
            color: #f4a096;
        }
        .char-count {
            color: #aaa;
            font-size: 13px;
            font-weight: 600;
        }

        .count-warning {
            color: #e64980;
        }
        .editor-bottom-info {
            display: flex;
            justify-content: space-between;
            padding: 10px 4px 0;
            color: #aaa;
            font-size: 13px;
        }
        .btn-save:disabled {
            opacity: 0.65;
            cursor: not-allowed;
            transform: none;
        }

        .btn-saving {
            min-width: 210px;
        }
        .category-help {
            display: flex;
            align-items: center;

            margin: 14px 4px 0;
            padding: 10px 14px;

            color: #666672;
            background: #fff5f6;

            border-left: 3px solid var(--primary-color);
            border-radius: 6px 12px 12px 6px;

            font-size: 13px;
            font-weight: 500;

            animation: helpFade 0.25s ease;
        }
        .category-help i {
            color: var(--primary-color);
        }
        @keyframes helpFade {
            from {
                opacity: 0;
                transform: translateX(-5px);
            }

            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
        .char-count,
        .editor-bottom-info {
            color: #767680;
            font-size: 13px;
            font-weight: 600;
        }

        .char-count {
            padding: 4px 9px;

            background: #f7f5f5;
            border-radius: 20px;

            transition:
                color 0.2s ease,
                background-color 0.2s ease,
                transform 0.2s ease;
        }

        .count-warning {
            color: #d6336c;
            background: #fff0f4;
            transform: scale(1.04);
        }

        .editor-bottom-info {
            display: flex;
            justify-content: space-between;

            padding: 11px 5px 0;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
    
    <div id="app">
        <main class="main-content">
            <div class="write-header">
                <h2><i class="fas fa-pen-nib mr-2"></i>새 글 작성</h2>
                <p class="sub-title">메리뷰 가족들과 소중한 일상과 정보를 공유해보세요.</p>
            </div>
            
            <div class="write-card">
                <!-- 카테고리 선택 (칩 방식) -->
                 
                <div class="write-row">
                    <label>카테고리</label>
                    <div class="category-group">
                        <div v-for="item in categoryList"
                            :key="item.value"
                            class="cate-item"
                            :class="{ active: category === item.value }"
                            @click="category = item.value">
                            <i :class="['fas', item.icon, 'mr-1']"></i>
                            {{ item.label }}
                        </div>
                    </div>
                    <p class="category-help">
                            <i class="fas fa-info-circle mr-1"></i>
                            {{ categoryDescription }}
                        </p>
                </div>

                <div class="write-row">
                    <div class="d-flex justify-content-between align-items-center">
                        <label>제목</label>

                        <span class="char-count"
                            :class="{ 'count-warning': title.length >= 45 }">
                            {{ title.length }} / 50
                        </span>
                    </div>

                    <input 
                        ref="titleInput"
                        type="text"
                        class="input-title"
                        v-model="title"
                        maxlength="50"
                        placeholder="제목을 입력해 주세요">
                </div>

                <!-- 에디터 영역 -->
                <div class="write-row">
                    <label>내용</label>
                    <div id="editor"></div>
                </div>
                <div class="editor-bottom-info">
                    <span>
                        이미지와 링크를 함께 첨부할 수 있습니다.
                    </span>
                    <span>
                        {{ contentLength }}자
                    </span>
                </div>
            </div>

            <div class="write-actions">
                <button class="btn-common btn-cancel" @click="fnBack">
                    <i class="fas fa-times mr-2"></i>취소
                </button>

                <button class="btn-common btn-save"
                        :disabled="isSaving"
                        :class="{ 'btn-saving': isSaving }"
                        @click="fnSave">

                    <template v-if="isSaving">
                        <i class="fas fa-spinner fa-spin mr-2"></i>
                        등록 중...
                    </template>

                    <template v-else>
                        <i class="fas fa-check mr-2"></i>
                        등록하기
                    </template>
                </button>
            </div>
        </main>

        <jsp:include page="/WEB-INF/common/footer.jsp" />
    </div>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    title: "",
                    category: "자유",
                    categoryList: [
                        { label: "자유게시판", value: "자유", icon: "fa-smile" },
                        { label: "결혼", value: "결혼", icon: "fa-gem" },
                        { label: "가족행사", value: "가족행사", icon: "fa-users" },
                        { label: "육아출산", value: "육아출산", icon: "fa-baby" },
                        { label: "고민", value: "고민", icon: "fa-comment-dots" },
                        { label: "직장", value: "직장", icon: "fa-briefcase" }
                    ],
                    userId: "${sessionId}",
                    quill: null,
                    contentLength: 0,
                    isSaving: false,
                };
            },
            computed: {
                categoryDescription() {
                    const descriptions = {
                        자유: "일상 이야기나 자유로운 주제를 나눠보세요.",
                        결혼: "결혼 준비, 예식장, 스드메 정보를 공유해보세요.",
                        가족행사: "돌잔치, 생신, 가족 모임 이야기를 공유해보세요.",
                        육아출산: "출산과 육아에 관한 경험을 나눠보세요.",
                        고민: "혼자 해결하기 어려운 고민을 이야기해보세요.",
                        직장: "회사 생활과 직장 관련 이야기를 공유해보세요."
                    };

                    return descriptions[this.category] || "";
                }
            },
            methods: {
                initEditor() {
                    this.quill = new Quill('#editor', {
                        theme: 'snow',
                        modules: {
                            toolbar: [
                                [{ 'header': [1, 2, 3, false] }],
                                ['bold', 'italic', 'underline', 'strike'],
                                [{ 'color': [] }, { 'background': [] }],
                                [{ 'list': 'ordered'}, { 'list': 'bullet' }],
                                ['link', 'image'],
                                ['clean']
                            ]
                        },
                        placeholder: '메리뷰 가족들에게 전할 따뜻한 내용을 입력해주세요.'
                    });
                    this.quill.on("text-change", () => {
                        this.contentLength = Math.max(
                            0,
                            this.quill.getText().trim().length
                        );
                    });
                },
                fnSave() {
                    if (this.isSaving) {
                        return;
                    }

                    const content = this.quill.root.innerHTML;

                    if(!this.title.trim()) { alert("제목을 입력해주세요! ✨"); return; }
                    if(this.quill.getText().trim().length <= 0 && content.indexOf('<img') === -1) { 
                        alert("내용을 입력해주세요! ✨"); return; 
                    }
                    this.isSaving = true;

                    let param = {
                        title: this.title,
                        content: content,
                        category: this.category,
                        userId: this.userId
                    };

                    $.ajax({
                        url: "/api/community/add.dox",
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify(param),
                        success: (data) => {
                            alert("글이 성공적으로 등록되었습니다! 🎉"); 
                            location.href = "/api/community/list.do";
                        },
                        error: () => {
                            alert("저장 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
                        },
                         complete: () => {
                            this.isSaving = false;
                        }
                    });
                },
                fnBack() {
                    const hasTitle = this.title.trim().length > 0;

                    const hasContent =
                        this.quill &&
                        (
                            this.quill.getText().trim().length > 0 ||
                            this.quill.root.innerHTML.includes("<img")
                        );

                    if (!hasTitle && !hasContent) {
                        history.back();
                        return;
                    }

                    if (confirm("작성 중인 내용은 저장되지 않습니다. 돌아가시겠습니까?")) {
                        history.back();
                    }
                }
            },
            mounted() {
                this.initEditor();
                this.$nextTick(() => {
                    this.$refs.titleInput.focus();
                });
            }
        });
        app.mount('#app');
    </script>
</body>
</html>