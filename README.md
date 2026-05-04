# 💟 MarryView 💟 - 웨딩 리뷰 플랫폼

https://github.com/user-attachments/assets/a00ba838-6ce2-4335-ac79-0b14a1077616

## 📚 목차
1. [프로젝트 소개](#-프로젝트-소개)
2. [개발 기간](#-개발-기간)
3. [팀원 구성](#-팀원-구성)
4. [사용 기술](#-사용-기술)
5. [주요 기능](#-주요-기능)
6. [역할 분담](#-역할-분담)
7. [발표 PPT](#-발표-ppt)
8. [시연 영상](#-시연-영상)

---

## 🔎 프로젝트 소개
여러분의 결혼 이야기를 우리 **Marry View**에서 허심탄회하게 표출해보세요!  
**MarryView**는 **스튜디오 - 드레스 - 메이크업**에 대한 정보를 실제 경험자들의 후기를 통해  
결혼을 준비하고 있는 **예비 부부**들에게 **실제 선배 부부**들이 제공해주는 정보로 더욱 신뢰할 수 있고,  
업체 상품을 연계해주는 하이브리드 웨딩 플랫폼입니다.

- 현재 결혼한 부부들의 스-드-메 결혼 후기를 제공
- 영수증 인증 기반 **관리자 승인제**를 통한 리뷰 업로드로 신뢰도 확보
- 허위/광고성 리뷰 원천 차단
- 마음에 드는 후기 확인 후 원하는 상품 예약 연계

---

## 🗓 개발 기간
- **2026.04.02 ~ 2026.04.12** : 기획 및 ERD, 테이블 설계
- **2026.04.13 ~ 2026.04.27** : 기능 개발
- **2026.04.28 ~ 2026.05.01** : 테스트 및 보완

---

## 🤝🏼 팀원 구성
| 이름 | GitHub | 이메일 |
|:---:|:---:|:---:|
| 임효진 | [@limhyojin3](https://github.com/limhyojin3) | skwlaks1@gmail.com |
| 안혜진 | [@coolpxp-source](https://github.com/coolpxp-source) | coolpxp@gmail.com |
| 최제현 | [@cjh-devv](https://github.com/cjh-devv) | cjh900318@gmail.com |
| 이태화 | [@leetaehwa1](https://github.com/leetaehwa1) | th3926@naver.com |

---

## 🖥 사용 기술

### 🎨 Frontend
<p>
  <img src="https://img.shields.io/badge/vue.js_3-4FC08D?style=for-the-badge&logo=vuedotjs&logoColor=white">
  <img src="https://img.shields.io/badge/javascript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black">
  <img src="https://img.shields.io/badge/html5-E34F26?style=for-the-badge&logo=html5&logoColor=white">
  <img src="https://img.shields.io/badge/css3-1572B6?style=for-the-badge&logo=css3&logoColor=white">
  <img src="https://img.shields.io/badge/bootstrap-7952B3?style=for-the-badge&logo=bootstrap&logoColor=white">
  <img src="https://img.shields.io/badge/jquery-0769AD?style=for-the-badge&logo=jquery&logoColor=white">
</p>
<ul>
  <li><b>Vue.js 3</b>: 컴포넌트 기반 프레임워크를 통한 효율적인 UI 개발</li>
  <li><b>jQuery</b>: Ajax를 활용한 서버와의 비동기 데이터 통신 구현</li>
</ul>

### 🛠 Backend
<p>
  <img src="https://img.shields.io/badge/java_17-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white">
  <img src="https://img.shields.io/badge/springboot-6DB33F?style=for-the-badge&logo=springboot&logoColor=white">
  <img src="https://img.shields.io/badge/mybatis-black?style=for-the-badge&logo=mybatis&logoColor=white">
  <img src="https://img.shields.io/badge/apache_maven-C71A36?style=for-the-badge&logo=apachemaven&logoColor=white">
</p>
<ul>
  <li><b>Spring Boot</b>: 프로젝트 전반의 핵심 프레임워크 활용</li>
  <li><b>MyBatis</b>: 복잡한 SQL 쿼리 관리 및 데이터베이스 매퍼 제어</li>
  <li><b>Maven</b>: 효율적인 빌드 프로세스 및 라이브러리 의존성 관리</li>
</ul>

### 🗄 Database & Tools
<p>
  <img src="https://img.shields.io/badge/mysql-4479A1?style=for-the-badge&logo=mysql&logoColor=white">
  <img src="https://img.shields.io/badge/git-F05032?style=for-the-badge&logo=git&logoColor=white">
  <img src="https://img.shields.io/badge/github-181717?style=for-the-badge&logo=github&logoColor=white">
  <img src="https://img.shields.io/badge/postman-FF6C37?style=for-the-badge&logo=postman&logoColor=white">
  <img src="https://img.shields.io/badge/cloudinary-3448C5?style=for-the-badge&logo=cloudinary&logoColor=white">
</p>
<ul>
  <li><b>Cloudinary</b>: 클라우드 기반 미디어 관리 시스템으로 서버 파일 저장 및 관리</li>
  <li><b>Postman</b>: RESTful API 설계 및 동작 테스트</li>
</ul>

---

## 🧠 주요 기능

- 다중 권한 기반 회원 시스템: 일반 사용자, 업체, 관리자별 Role(역할) 부여 및 차별화된 기능 제공

- 통합 마이페이지: 게시글, 댓글, 좋아요, 신고/문의 내역 등 사용자 활동 데이터 요약 및 관리

- 카카오맵 API 연동: 위치 기반 서비스(찾아오시는 길) 및 업체 정보 제공

- 예약 및 문의 프로세스: 상품별 예약 서비스, 실시간 문의 내역 조회 및 상태 관리

- 리치 에디터 커뮤니티: 사진 첨부 기능이 포함된 게시글 작성 및 실시간 댓글 상호작용

- 비즈니스 모델(Paid Content): 리뷰 유·무료 구분(블러 처리), 영수증 인증 기반의 관리자 승인 시스템

- 파일 관리 및 보안: Cloudinary를 활용한 미디어 서버 관리 및 민감 서류(영수증) 접근 권한 제어

- 결제 시스템: 결제 API 연동을 통한 이용권(Pass) 구매 및 잔여 횟수 관리
  
---

## 💪🏼 역할 분담

 ### 임효진 (팀장)
- **작업 페이지:**

   - ㅎ

- **구현 기능:**
  
  - ㅎ
 
 ### 안혜진
- **작업 페이지:**

   - ㅎ

- **구현 기능:**
  
  - ㅎ

 ### 최제현
- **작업 페이지:**

   - ㅎ

- **구현 기능:**
  
  - ㅎ

 ### 이태화
- **작업 페이지:**

   - ㅎ

- **구현 기능:**
  
  - ㅎ
---

## 📝 발표 PPT

## 🎥 시연 영상
![시연영상](assets/demo.gif)

---
