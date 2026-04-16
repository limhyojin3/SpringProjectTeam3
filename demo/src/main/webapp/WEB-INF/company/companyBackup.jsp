<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="/js/page-change.js"></script>
        <style>
            

            /* 기본 레이아웃 */
            body {
                font-family: 'Malgun Gothic', sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f9f9f9;
            }

            #app {
                max-width: 1200px;
                margin: 0 auto;
                background: white;
                border: 1px solid #ddd;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
            }

            /* 헤더 영역 */
            header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 20px;
                border-bottom: 2px solid #333;
            }

            .nav-top button {
                padding: 8px 15px;
                margin-right: 5px;
                border: 1px solid #ff7f9f;
                background: white;
                color: #ff7f9f;
                cursor: pointer;
                border-radius: 5px;
            }

            .user-info {
                background: #ff7f9f;
                color: white;
                padding: 10px 20px;
                border-radius: 5px;
            }

            /* 메인 바디 레이아웃 */
            .container {
                display: flex;
                flex: 1;
            }

            /* 사이드바 */
            aside {
                width: 220px;
                background: #fff0f3;
                padding: 20px;
                border-right: 1px solid #ddd;
            }

            .menu-item {
                position: relative;
                margin-bottom: 10px;
            }

            .menu-item button {
                width: 100%;
                padding: 12px;
                text-align: center;
                border: 1px solid #ddd;
                background: white;
                cursor: pointer;
                font-weight: bold;
            }

            .menu-item button.active {
                background: #ff1493;
                color: white;
                border-color: #ff1493;
            }

            /* 숫자 배지 */
            .badge {
                position: absolute;
                right: -10px;
                top: 50%;
                transform: translateY(-50%);
                background: #ff1493;
                color: white;
                border-radius: 12px;
                padding: 2px 10px;
                font-size: 12px;
                border: 2px solid white;
                z-index: 10;
            }

            /* 메인 컨텐츠 */
            main {
                flex: 1;
                padding: 30px;
            }

            .content-card {
                border: 2px solid #ff7f9f;
                padding: 30px;
                border-radius: 10px;
                margin-bottom: 20px;
                position: relative;
            }

            .section-title {
                background: #ffb400;
                display: inline-block;
                padding: 5px 15px;
                color: white;
                font-weight: bold;
                margin-bottom: 15px;
            }

            /* 테이블 및 리스트 스타일 */
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 15px;
            }

            th,
            td {
                border: 1px solid #ddd;
                padding: 12px;
                text-align: left;
            }

            th {
                background: #fef0f3;
                width: 120px;
            }

            .new-label {
                background: #ff7f9f;
                color: white;
                font-size: 10px;
                padding: 2px 4px;
                border-radius: 3px;
                vertical-align: middle;
                margin-right: 5px;
            }

            /* 탭 버튼 */
            .tab-menu {
                margin-bottom: 20px;
            }

            .tab-menu button {
                padding: 10px 20px;
                border: 1px solid #ddd;
                background: #eee;
                cursor: pointer;
            }

            .tab-menu button.active {
                background: #ff7f9f;
                color: white;
                border-color: #ff7f9f;
            }

            /* 푸터 */
            footer {
                background: #ffc1cc;
                padding: 20px;
                text-align: center;
                font-size: 14px;
                border-top: 1px solid #ddd;
            }

            /* 플로팅 버튼 */
            .ai-chatbot {
                position: fixed;
                right: 30px;
                bottom: 100px;
                background: #0099ff;
                color: white;
                width: 70px;
                height: 70px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: bold;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            }
        </style>
    </head>

    <body>
        <div id="app">
            <!-- html 코드는 id가 app인 태그 안에서 작업 -->
            <header>
                <div class="logo"><img src="/images/logo.png" alt="메리뷰" height="60"></div>
                <div class="nav-top">
                    <button>회사소개</button>
                    <button>제휴업체</button>
                    <button>커뮤니티</button>
                    <button>패스구매</button>
                    <button>고객센터</button>
                </div>
                <div class="user-info">{{ userName }}님</div>
            </header>

            <div class="container">
                <aside>
                    <div class="menu-item" v-for="m in menuList" :key="m.id">
                        <button :class="{ active: currentMenu === m.id }" @click="currentMenu = m.id">{{ m.name
                            }}</button>
                        <span class="badge" v-if="m.count > 0">{{ m.count }}</span>
                    </div>
                </aside>

                <main>
                    <div v-if="currentMenu === 'main'">
                        <h2>안녕하세요, 'ABC 드레스 샵'님!</h2>
                        <div class="section-title">제휴업체</div>
                        <div class="content-card">
                            <h3>제휴업체 이용 기간</h3>
                            <p style="text-align: right; font-size: 20px;">25.01.01 ~ 26.01.01</p>
                        </div>
                        <div class="content-card">
                            <h3>마지막 결제 수단</h3>
                            <p style="text-align: right; font-size: 20px;">신협 ***</p>
                        </div>
                        <button style="float: right;">탈퇴하기</button>
                    </div>

                    <div v-if="currentMenu === 'product'">
                        <h2>등록한 상품(3)</h2>
                        <div v-for="i in 3" class="content-card"
                            style="display: flex; align-items: center; padding: 15px;">
                            <div
                                style="width: 120px; height: 80px; background: #ffcef0; display: flex; align-items: center; justify-content: center; margin-right: 20px;">
                                썸네일</div>
                            <div style="flex: 1;">상세 내용 및 상품 설명...</div>
                            <button>수정하기</button>
                        </div>
                        <div style="text-align: center;">
                            <button
                                style="background: #ffb400; padding: 15px 40px; border: none; font-weight: bold; cursor: pointer;">상품
                                등록</button>
                        </div>
                    </div>

                    <div v-if="currentMenu === 'reservation'">
                        <h2>예약 관리 : <span style="color: #ff1493;">새 예약 {{ resCount }}건</span></h2>
                        <table>
                            <tr>
                                <th>예약 상품</th>
                                <td>드레스 투어</td>
                            </tr>
                            <tr>
                                <th>예약 내용</th>
                                <td>본식 드레스 투어 하고 싶습니다.</td>
                            </tr>
                            <tr>
                                <th>예약 일자</th>
                                <td>26.03.01</td>
                            </tr>
                            <tr>
                                <th>이용 일자</th>
                                <td>26.04.01 14:00PM</td>
                            </tr>
                            <tr>
                                <th>예약자명</th>
                                <td>김결혼</td>
                            </tr>
                            <tr>
                                <th>연락처</th>
                                <td>010-1234-5678</td>
                            </tr>
                            <tr>
                                <th>결제 금액</th>
                                <td>(예약금) 50,000원</td>
                            </tr>
                        </table>
                    </div>

                    <div v-if="currentMenu === 'inquiry'">
                        <h2>문의 관리 : <span style="color: #ff1493;">새 문의 2건</span></h2>
                        <div class="content-card">
                            <div style="display: flex;">
                                <div style="width: 100px; height: 100px; background: #ffcef0; margin-right: 20px;">썸네일
                                </div>
                                <div style="flex: 1;"><strong>상세 내용</strong></div>
                            </div>
                            <table>
                                <tr>
                                    <th>제목</th>
                                    <td>투어 일정 변경하고 싶습니다.</td>
                                </tr>
                                <tr>
                                    <th>작성자</th>
                                    <td>김결혼</td>
                                </tr>
                                <tr>
                                    <th>내용</th>
                                    <td>04.01일 예약했는데 04.08일로 변경하고 싶어요.</td>
                                </tr>
                            </table>
                            <button
                                style="background: #ffb400; margin-top: 10px; padding: 10px 20px; border: none;">답변하기</button>
                        </div>
                    </div>

                    <div v-if="currentMenu === 'review'">
                        <div class="tab-menu">
                            <button :class="{ active: reviewTab === 'detail' }" @click="reviewTab = 'detail'">상세
                                리뷰(30)</button>
                            <button :class="{ active: reviewTab === 'simple' }" @click="reviewTab = 'simple'">한줄
                                리뷰(15)</button>
                        </div>

                        <div v-if="reviewTab === 'detail'">
                            <h3>리뷰 내역 : 새 리뷰 10건</h3>
                            <div class="content-card">
                                <div style="display: flex; justify-content: space-between;">
                                    <div><span class="new-label">NEW</span><strong>상품명</strong></div>
                                    <div>리뷰 갯수: 5개</div>
                                </div>
                                <p>평점 ★★★★★</p>
                                <div style="display: flex; gap: 15px;">
                                    <div style="width: 100px; height: 100px; background: #ffcef0;">리뷰 사진</div>
                                    <div>이런 부분이 너무 좋았습니다. 어쩌구 저쩌구 추천합니다!</div>
                                </div>
                                <div style="text-align: right; font-size: 12px; margin-top: 10px;">작성자: 김결혼 | 작성일자:
                                    26.04.08</div>
                            </div>
                        </div>

                        <div v-if="reviewTab === 'simple'">
                            <h3>리뷰 내역 : 새 리뷰 5건</h3>
                            <table>
                                <thead>
                                    <tr style="background: #fef0f3;">
                                        <th>번호</th>
                                        <th>내용</th>
                                        <th>작성자</th>
                                        <th>평점</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>3 <span class="new-label">NEW</span></td>
                                        <td>추천합니다. 친절해요.</td>
                                        <td>결혼해듀오</td>
                                        <td>5</td>
                                    </tr>
                                    <tr>
                                        <td>2 <span class="new-label">NEW</span></td>
                                        <td>조금 늦었는데 배려해주셔서 감사합니다.</td>
                                        <td>5월신부</td>
                                        <td>5</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </main>
            </div>

            <footer>
                푸터 → 업체 정보 | 사업자번호: 000-00-00000 | 고객센터: 1588-0000
            </footer>

            <div class="ai-chatbot">ai 챗봇</div>
        </div>
    </body>

    </html>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    // 변수 - (key : value)
                    userName: 'ooo',
                        currentMenu: 'main', // 초기 화면
                        reviewTab: 'detail',
                        resCount: 3,
                        menuList: [
                            { id: 'main', name: '마이 페이지', count: 0 },
                            { id: 'product', name: '상품 관리', count: 0 },
                            { id: 'reservation', name: '예약 관리', count: 3 },
                            { id: 'inquiry', name: '문의 내역', count: 2 },
                            { id: 'review', name: '리뷰 내역', count: 10 },
                            { id: 'customer', name: '고객센터', count: 0 }
                        ]
                };
            },
            methods: {
                // 함수(메소드) - (key : function())
                fnList: function () {
                    let self = this;
                    let param = {};
                    $.ajax({
                        url: "http://localhost:8080/",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {

                        }
                    });
                }
            }, // methods
            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
            }
        });

        app.mount('#app');
    </script>