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
            table,
            tr,
            td,
            th {
                border: 1px solid black;
                border-collapse: collapse;
                padding: 5px 10px;
                text-align: center;
            }

            th {
                background-color: beige;
            }

            tr:nth-child(even) {
                background-color: azure;
            }
        </style>
    </head>

    <body>
        <div id="app">
            <!-- html 코드는 id가 app인 태그 안에서 작업 -->
            <img src="/images/img2.jpg" height="200px">
            <div style="display: inline;">
                <button>회사소개</button>
                <button>제휴업체</button>
                <button>커뮤니티</button>
                <button>패스구매</button>
                <button>고객센터</button>
            </div>
            <span>ooo님</span>
            <div>
                <div style="display: inline-block; box-sizing: border-box; border: 2px solid black;" >
                    <button style="background-color: palevioletred;">마이 페이지</button>
                    <br>
                    <button>상품 관리</button>
                    <br>
                    <button>예약 관리</button><span>3</span>
                    <br>
                    <button>문의 내역</button><span>2</span>
                    <br>
                    <button>리뷰 내역</button><span>10</span>
                    <br>
                    <button>고객센터</button>
                </div>
                <div style="display: inline-block; box-sizing: border-box; border: 2px solid black;" >
                    <h1>안녕하세요,'ABC 드레스 샵'님!</h1>
                    <span style="box-sizing: border-box; border: 1px solid black;">제휴업체</span>
                    <div style="box-sizing: border-box; border: 1px solid black;">
                        <p>제휴업체 이용 기간</p>
                        <p>25.01.01~26.01.01</p>
                    </div>
                    <div style="box-sizing: border-box; border: 1px solid black;">
                        <p>마지막 결제 수단</p>
                        <p>신협 ***</p>
                    </div>
                </div>
            </div>
            <div style="display: inline-block; box-sizing: border-box; border: 1px solid black;">
                푸터
            </div>
        </div>
    </body>

    </html>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    // 변수 - (key : value)
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