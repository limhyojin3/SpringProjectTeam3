# 💟 MarryView 💟 - 웨딩 리뷰 플랫폼
![MarryView Header](https://capsule-render.vercel.app/api?type=shark&height=300&color=gradient&text=Marry%20View&animation=scaleIn)

https://github.com/user-attachments/assets/a00ba838-6ce2-4335-ac79-0b14a1077616

## 📚 목차
1. [프로젝트 소개](#intro)
2. [주요 기능](#features)
3. [개발 기간](#period)
4. [팀원 구성](#members)
5. [사용 기술](#tech)
6. [역할 분담](#roles)
7. [발표 PPT](#ppt)
8. [시연 영상](#video)
9. [프로젝트 자료 모음](#resources)

---

## <a name="intro"></a>🔍 프로젝트 소개 (Project Introduction)

### **"정보 비대칭 해소를 넘어 일상으로 확장되는 웨딩&라이프 올인원 플랫폼, MarryView"**

MarryView는 스·드·메 시장의 고질적인 정보 비대칭 해결을 시작으로, **가족행사(돌잔치·칠순잔치 등) 및 친구들과 함께하는 특별한 순간(모임·파티·이벤트 상품 등)**까지 연결하는 종합 라이프스타일 하이브리드 플랫폼입니다. 

영수증 인증 기반의 투명한 리뷰 시스템을 통해 광고성 정보를 원천 차단하고, 소중한 사람들과 함께하는 모든 행사의 탐색부터 맞춤형 예약까지 신뢰할 수 있는 원스톱 서비스를 제공합니다.

---

### 📌 핵심 비즈니스 모델 및 차별성 (Business Core Value)

* ⚖️ **정보 비대칭성 근절**
  * 베일에 싸인 웨딩 및 행사 업계의 가격 및 서비스 정보를 투명하게 공개하여 소비자-업체 간의 신뢰를 회복합니다.
* 🎈 **단발성 이벤트에서 생애주기형 모델로의 확장**
  * 결혼 준비라는 일회성 서비스에 그치지 않고, 육아·가족행사·소모임 등 라이프스타일 전반으로 서비스를 유기적으로 확장하여 유저 락인(Lock-in) 효과를 극대화합니다.
* 🔐 **영수증 인증 기반의 맑은 리뷰 생태계**
  * 허위/광고성 리뷰를 차단하기 위해 증빙 서류 승인 프로세스를 구축하여 100% 진짜 이용자 중심의 고신뢰 데이터를 축적합니다.

---

### <a name="features"></a>🛠️ 주요 기능 (Key Features)

#### 1. 회원 및 권한 관리 (Auth & User Management)
* 👥 **다중 권한 기반 회원 시스템**
  * 일반 사용자, 파트너 업체, 전체 관리자로 역할을 명확히 분기하여 각 Role별 맞춤형 인가(Authorization) 및 차별화된 대시보드를 제공합니다.
  * 카카오/네이버 소셜 로그인 (OAuth2 연동)를 제공합니다.
* 🗂️ **통합 마이페이지**
  * 사용자가 작성한 게시글, 댓글뿐만 아니라 좋아요 클릭 내역, 신고/문의 현황 등 파편화된 활동 데이터를 한눈에 요약하고 관리할 수 있는 통합 대시보드를 지원합니다.
  *  **AI 챗봇**
    *  Gemini API 직접 연동, DB 기반 업체 정보·카테고리 가격 안내 제공합니다.

#### 2. 커뮤니티 및 정보 제공 (Community & Location Services)
* 🗺️ **카카오맵 API 연동 위치 기반 서비스**
  * 우리 업체의 정확한 위치 정보 및 '찾아오시는 길' 서비스를 연동하여 사용자의 오프라인 접근성을 높이고 위치 기반 탐색 기능을 제공합니다.
* ✍️ **리치 에디터 기반 소통 창구**
  * 멀티미디어(사진, 이미지) 첨부가 가능한 고기능 에디터를 도입하여 풍성한 정보 공유 커뮤니티를 활성화하고, 실시간 댓글 상호작용 기능을 지원합니다.

#### 3. 비즈니스 로직 및 결제 (Business Logic & Payment)
* 💳 **결제 API 연동 및 이용권(Pass) 시스템**
  * 외부 결제 연동을 통해 플랫폼 내에서 사용 가능한 이용권 구매 기능을 제공하며, 차감형 잔여 횟수 관리 로직을 구현했습니다.
* 💰 **유·무료 콘텐츠 차별화 (Paid Content)**
  * 비즈니스 수익 모델로서 일반 리뷰와 유료 리뷰를 구분하고, 비구독 유저에게는 프리미엄 리뷰를 블러(Blur) 처리하여 결제를 유도하는 유료화 구조를 갖추었습니다.

#### 4. 예약, 문의 및 보안 (Process & Security)
* 📅 **예약 및 실시간 문의 프로세스**
  * 각 업체 상품별 예약 신청, 접수, 완료 단계별 상태 변경 로직을 제공하며, 관리자와 유저 간의 실시간 문의 내역 조회 및 상태 관리 기능을 지원합니다.
* 🛡️ **Cloudinary 미디어 서버 및 서류 보안 관리**
  * Cloudinary 클라우드 미디어 서버를 활용하여 대용량 이미지 자원을 효율적으로 관리하며, 영수증 등 민감한 서류 데이터에 대한 접근 권한을 제어하여 보안성을 강화했습니다.

---

## <a name="period"></a>🗓 개발 기간
- **2026.04.02 ~ 2026.04.12** : 기획 및 ERD, 테이블 설계
- **2026.04.13 ~ 2026.04.27** : 기능 개발
- **2026.04.28 ~ 2026.05.01** : 테스트 및 보완
- **2026.06.18 ~ 2026.06.26** : 추가 개선사항 반영 및 최종 안정화 진행

---

## <a name="members"></a>🤝🏼 팀원 구성
| 이름 | GitHub | 이메일 |
|:---:|:---:|:---:|
| 임효진 | [@limhyojin3](https://github.com/limhyojin3) | skwlaks1@gmail.com |
| 안혜진 | [@coolpxp-source](https://github.com/coolpxp-source) | coolpxp@gmail.com |
| 최제현 | [@cjh-devv](https://github.com/cjh-devv) | cjh900318@gmail.com |
| 이태화 | [@leetaehwa1](https://github.com/leetaehwa1) | th3926@naver.com |

---

## <a name="tech"></a>🖥 사용 기술

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

## <a name="roles"></a>💪🏼 역할 분담

 ### 임효진 (팀장)
- **작업 페이지:**

   - 업체 페이지 전체 (상품관리,예약관리,문의내역,리뷰내역)
   - 상품 목록, 업체 목록 전체 (상품예약,문의)

- **구현 주요 기능:**
  
  - 스마트 예약·결제 및 Q&A 프로세스 연동: '상품 선택 → 예약 저장 → 내역 확인 → 결제 API 연동'으로 이어지는 주문 흐름 및 문의-답변 양방향 데이터 트래킹 구현
  - 리뷰 권한별 조건부 렌더링 및 페이징: 유료/무료 리뷰 권한별 화면 노출 차별화(이미지 제공 및 5줄 요약 제한) 및 Front-end 중심의 리뷰 페이징 처리
  - 대용량 상품 정보 처리 및 다중 태그 필터링: 멀티파트 업로드 기반 이미지 서버 경로 매핑 및 MyBatis foreach를 활용해 사용자가 선택한 여러 개의 복합 태그를 AND 조건으로 정교하게 교집합 검색하는 다중 필터링 기능 구현
  - 사용자 접근 시점 기반 상태 자동 동기화: 사용자 접근 시점(예약/업체 조회)의 날짜·결제 상태를 비교하여 예약 상태(DONE/CANCEL)를 실시간 업데이트하는 로직 구축
  - 컴포넌트 기반 아키텍처 최적화: 대형 페이지(3,000줄)를 단일 책임 원칙(SRP)에 맞춰 구조화된 독립 컴포넌트(50~200줄)로 분리하여 앱 로딩 및 유지보수 성능 개선
  - 결제 상황별 권한 기반 접근 제어: 결제 상황(대기, 확정, 취소, 만료)에 따른 세밀한 서비스 접근 권한 구분 및 CS 처리 상태(대기/완료) 시각화
 
### 안혜진
- **작업 페이지:**
   - 마이페이지 전체, 대문(INTRO), 메인 홈, 헤더 백엔드, 로그인(유저/업체/관리자), 회원가입, AI 챗봇, 정적 페이지(관리자 로그인/이벤트/사용자 정보)
   - 
- **구현 주요 기능:**
  - 마이페이지 전체 페이징 구현 — XML LIMIT/OFFSET 처리, Controller에서 페이징 계산 후 Vue로 데이터 전달
  - 열람 내역 조회 — 유료/무료 탭 분리, pass_usage_log 기반 유료 리뷰 열람 기록 조회
  - 예약/결제/쿠폰 내역 조회 — 다중 테이블 JOIN으로 사용자별 내역 출력
  - 마이페이지 내 글/리뷰/댓글/좋아요 목록 — 탭 전환 방식으로 한 페이지에서 통합 관리, 체크박스 선택 삭제 구현
  - 카카오/네이버 소셜 로그인 (OAuth2) — 일반/업체 회원 분리 처리, Spring Security 미사용 직접 구현
  - 역할 기반 헤더 테마 — 일반(핑크)/업체(퍼플)/관리자(다크) 분기 처리


 ### 최제현
- **작업 페이지:**

   - 관리자페이지 전체, 회사 연혁, 패스구매,결제, 패스 조회, 제휴등록 결제, 결제 완료 페이지, 알림 페이지

- **구현 주요 기능:**

  - 관리자 페이지 구현: 회원, 신고, 문의, 상품, 쿠폰, 패스 정보를 관리할 수 있는 운영자 화면 구현
  - 결제/환불 처리: PortOne API를 활용한 패스·예약·업체 등록 결제 검증, 결제 완료 처리, 환불 조건 검증 및 쿠폰 할인 금액 계산 구현
  - 관리자 통계 구현: AJAX로 통계 데이터를 조회하고 ApexCharts를 활용해 회원, 리뷰, 매출, 리뷰 참여율 등 운영 지표 시각화
  - 알림 기능 구현: 신고 처리, 문의 답변, 예약 상태 변경 등 주요 이벤트 발생 시 알림 생성 및 읽음 상태 관리 구현
  - 콘텐츠 관리 기능: 게시글·리뷰 목록 검색, 필터링, 정렬 및 Soft Delete 기반 검수 흐름 구현

    
 ### 이태화
- **작업 페이지:**

   - 커뮤니티, 리뷰 ,신고, 문의

- **구현 주요 기능:**
  
  - 커뮤니티와 리뷰 게시글에서 에디터로 사진 첨부, 리뷰 게시글에서는 에디터로 첨부한 첫 번째 사진의 경로를 추출해서 경로로 만들어 리뷰 목록에 출력
  - 리뷰 게시글 작성 시 영수증 파일은 서버에 저장하는 API 사용 후 Spring Boot에서 File첨부 업로드 로직을 작성해 관리자에게만 출력하도록 구현
  - 리뷰 게시글의 대한 열람권 차감 로직 구현 -> 무료 리뷰는 전부 보여주고 유료 리뷰는 열람권 소유 여부 유효성 검사를 통해 유료 리뷰 조회 가능
---

## <a name="ppt"></a>📝 발표 PPT
[MarryView 발표 PPT](https://docs.google.com/presentation/d/1Jx6EC_XN0us7FykB43xtrjgjnf6b6ZGl/edit?usp=sharing&ouid=108808101243830684768&rtpof=true&sd=true)

## <a name="video"></a>🎥 시연 영상
▶ [메리뷰 핵심 기능 시연 영상](https://drive.google.com/file/d/16Tgbzrr97_oLvOAWiNWqGL-nJJD1LcrD/view?usp=sharing)

[팀원별 페이지 시연 영상]

▶ [임효진](https://drive.google.com/file/d/1kXyyePI2AX5bJnvwa5PozuMvjTAVaqJ9/view?usp=sharing)

▶ [안혜진](https://drive.google.com/file/d/1kxYzbKtFlfdL6WbU__c3j-mil4AWzKQH/view?usp=sharing)

▶ [이태화](https://drive.google.com/file/d/1pqQ_pyURBMwpx7uKTF0D3lAdYQb8Qd0c/view?usp=drive_link)

▶ [최제현](https://drive.google.com/file/d/1cptjY-CzqURMIsnRAyQsBYt6H4_IdXcV/view?usp=sharing)

---

## <a name="resources"></a>📂 프로젝트 자료 모음

| 분류 | 링크 |
|------|------|
| 📋 회의록 | [회의록 보기](https://drive.google.com/drive/folders/1fGEhyE5Tf5JI_LVZ8f9topqmcFG7Td0O?usp=drive_link) |
| 📊 설계 자료 | [설계 보기](https://drive.google.com/drive/folders/1KnTR-GPw67oNPN7pkzJrcK5pyN8dBjaK?usp=drive_link) |
| 📚 공통 문서 | [공통 문서 보기](https://drive.google.com/drive/folders/1o8RTFEo0e9tSL0cwIc8kyLVvHyuDhvC8?usp=drive_link) |
