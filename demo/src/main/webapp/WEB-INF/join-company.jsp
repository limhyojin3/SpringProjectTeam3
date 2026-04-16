<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { background: #f9f9f9; font-family: 'Noto Sans KR', sans-serif; }

        #app {
            width: 500px;
            margin: 50px auto;
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        /* 행 하나 감싸는 컨테이너 */
        .form-row {
            display: flex;
            align-items: center;
            margin-bottom: 2px;
        }
        /* 왼쪽 라벨 (핑크 배경) */
        .form-label {
            background: #f4a096;
            color: white;
            width: 120px;
            min-height: 45px;
            display: flex;
            align-items: center;
            padding-left: 15px;
            font-size: 14px;
            flex-shrink: 0;
        }
        /* 오른쪽 입력 영역 */
        .form-input {
            flex: 1;
            padding: 0 10px;
            display: flex;
            align-items: center;
            gap: 8px;
            min-height: 45px;
            border: 1px solid #eee;
        }
        /* 비활성화 행 */
        .form-input.disabled {
            background: #e0e0e0;
        }
        input[type="text"],
        input[type="password"],
        input[type="number"] {
            border: none;
            outline: none;
            flex: 1;
            font-size: 14px;
            background: transparent;
        }
        /* 중복체크, 본인인증 버튼 */
        .btn-check {
            background: #f0b429;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            white-space: nowrap;
        }
        /* 가입하기 버튼 */
        .btn-submit {
            display: block;
            margin: 20px auto 0;
            background: #f0b429;
            color: white;
            border: none;
            padding: 10px 40px;
            border-radius: 8px;
            font-size: 15px;
            cursor: pointer;
        }
        select {
            border: none;
            outline: none;
            font-size: 14px;
            background: transparent;
            width: 100%;
        }

    </style>
</head>
<body>
    <div id="app">
        <div class="form-row">
            <div class="form-label">업체명</div>
            <div class="form-input">
                <input type="text">
                <button class="btn-check">중복체크</button>
            </div>
        </div>
        <div class="form-row">
            <div class="form-label">아이디</div>
            <div class="form-input">
                <input type="text">
                <button class="btn-check">중복체크</button>
            </div>
        </div>
        <div class="form-row">
            <div class="form-label">대표자명</div>
            <div class="form-input"><input type="text"></div>
        </div>
        <div class="form-row">
            <div class="form-label">대표 이메일</div>
            <div class="form-input">
                <input type="text">
                <button class="btn-check">중복체크</button>
            </div>
        </div>
        <div class="form-row">
            <div class="form-label">업체 분류</div>
            <div class="form-input">
                <select v-model="category" @change="fnCategoryChange()">
                    <option value="studio">스튜디오</option>
                    <option value="dress">드레스</option>
                    <option value="makeUp">메이크업</option>
                    <option value="snapShot">스냅샷</option>
                    <option value="etc">기타</option>
                </select>
                <input type="text" v-if="isEtc" placeholder="직접 입력">
            </div>
        </div>
        <div class="form-row">
            <div class="form-label">업체 전화번호</div>
            <div class="form-input">
                <input type="number">
                <button class="btn-check">인증</button>
            </div>
        </div>
        <div class="form-row">
            <div class="form-label">사업자번호 인증</div>
            <div class="form-input">
                <input type="number">
                <button class="btn-check">인증</button>
            </div>
        </div>
        <div class="form-row">
            <div class="form-label">비밀번호</div>
            <div class="form-input disabled"></div>
        </div>
        <div class="form-row">
            <div class="form-label">비밀번호 확인</div>
            <div class="form-input disabled"></div>
        </div>
        <div class="form-row">
            <div class="form-label">사업장 주소</div>
            <div class="form-input">위치 api 사용</div>
        </div>
        <button class="btn-submit">가입 하기</button>
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                category: '',
                isEtc: false
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
            },
            fnCategoryChange : function(){
                this.isEtc = this.category === 'etc';
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
        }
    });

    app.mount('#app');
</script>