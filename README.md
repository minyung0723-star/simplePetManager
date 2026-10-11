# simplePetManager 🐾
**서울시 반려동물 시설 정보 통합 플랫폼**

## 💡 프로젝트 소개
흩어져 있는 서울시 내 동물병원, 동물약국, 반려동물 호텔 등의 정보를 한곳에서 확인하고, 위치 기반으로 쉽게 찾아볼 수 있도록 만든 웹 서비스입니다.

- **개발 기간**: 2026.03.30 ~ 2026.04.15
- **인원**: 3명 (프론트엔드 2명, 백엔드 1명)
- **담당 역할 (조민영)**: 회원 인증 및 보안 아키텍처 설계, REST API 구현, Docker/Render 배포 환경 구축

---

## 🛠 기술 스택 (Tech Stack)

### **Backend**
![Java](https://img.shields.io/badge/Java-21-007396?style=for-the-badge&logo=java)
![Spring Boot](https://img.shields.io/badge/Spring_Boot-4.0.4-6DB33F?style=for-the-badge&logo=springboot)
![MyBatis](https://img.shields.io/badge/MyBatis-000000?style=for-the-badge&logo=mybatis)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql)

### **Frontend**
![JSP](https://img.shields.io/badge/JSP-007396?style=for-the-badge&logo=java)
![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black)

### **Infra & DevOps**
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker)
![Gradle](https://img.shields.io/badge/Gradle-02303A?style=for-the-badge&logo=gradle)
![Render](https://img.shields.io/badge/Render-46E3B7?style=for-the-badge&logo=render)

---

## 💻 핵심 기여 내용

### **1. 사용자 인증 및 보안 아키텍처 (Backend)**
- **JWT 기반 무상태(Stateless) 인증**: 서버 확장성을 고려하여 세션 대신 JWT(Access/Refresh Token) 도입.
- **보안 강화**: 
    * `HttpOnly` 쿠키를 활용하여 XSS 공격으로부터 토큰 탈취 방지.
    * `BCrypt` 알고리즘을 사용한 강력한 비밀번호 암호화.
- **이메일 인증 시스템**: 
    * Brevo API를 활용한 인증코드 검증 로직 구현.
    * **트러블슈팅**: Render 환경의 SMTP 포트(587) 차단 제약을 인지하고, HTTP API(443 포트) 방식으로 로직을 우회하여 이메일 인증 기능 안정화.

### **2. 프로젝트 인프라 및 배포**
- **Docker 멀티 스테이지 빌드**: 빌드 환경과 실행 환경을 분리하여 경량화된 이미지 생성 및 배포 효율 증대.
- **환경 변수 관리**: 민감 정보(DB 접속 정보, JWT Secret Key, API Key)를 외부 환경 변수로 분리하여 보안성 및 유지보수성 확보.

### **3. 데이터 모델링 및 API 최적화**
- 사용자, 가게, 리뷰, 북마크 도메인 설계 및 MyBatis를 활용한 효율적인 SQL 매핑.
- 권한별 접근 제어를 위해 `LoginInterceptor` 및 Spring Security를 조합하여 비정상적인 경로 접근 원천 차단.

---

## 🏗 프로젝트 구조 (Architecture)

```text
simplePetManager/
├── src/main/java/com/project/simplepetmanager/
│   ├── common/         # Security, JwtUtil, Filter, Interceptor
│   ├── controller/     # API(REST) 및 View 컨트롤러
│   ├── model/          # DTO, Mapper, Service(비즈니스 로직)
├── src/main/webapp/      # JSP 뷰 파일
└── Dockerfile            # 멀티 스테이지 빌드 설정
