<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header_design.css">
</head>

<body>

<header class="header">
    <div class="header-logo">
        <a href="${pageContext.request.contextPath}/">
            <img src="${pageContext.request.contextPath}/images/petlogo.png" alt="SimplePetManager 로고">
        </a>
    </div>

    <nav class="header-nav">
        <a href="${pageContext.request.contextPath}/board/boardList?category=hospital">동물병원찾기</a>
        <a href="${pageContext.request.contextPath}/board/boardList?category=hotel">동물호텔찾기</a>
        <a href="${pageContext.request.contextPath}/board/boardList?category=pharmacy">동물약국찾기</a>
        <a href="${pageContext.request.contextPath}/review/reviewPage">리뷰</a>
    </nav>

    <div class="header-actions">
        <%-- 로그인 상태는 JWT 쿠키 기반이므로 JS에서 판단. JSTL 세션 방식 사용 안 함 --%>
            <%-- /mypage/myPage → /myPage 로 수정 --%>
            <a href="${pageContext.request.contextPath}/mypage/myPage" class="btn-login" id="header-mypage-btn" ...>마이페이지</a><button class="btn-logout" id="header-logout-btn" style="display:none;">로그아웃</button>
        <a href="${pageContext.request.contextPath}/user/login" class="btn-login" id="header-login-btn" style="display:none;">로그인</a>
    </div>
</header>

<script>
    (function () {
        // 페이지 로드 시 로그인 상태를 서버에 확인하여 헤더 버튼 전환
        fetch('${pageContext.request.contextPath}/user/profile-info')
            .then(res => res.json())
            .then(data => {
                const loginBtn  = document.getElementById('header-login-btn');
                const logoutBtn = document.getElementById('header-logout-btn');
                const mypageBtn = document.getElementById('header-mypage-btn');

                if (data.loggedIn) {
                    logoutBtn.style.display = '';
                    mypageBtn.style.display = '';
                } else {
                    loginBtn.style.display = '';
                }

                // 현재 경로에 맞는 nav 링크에 active 클래스 적용
                const currentPath = window.location.pathname;
                document.querySelectorAll('.header-nav a').forEach(a => {
                    if (a.getAttribute('href') && currentPath.startsWith(a.getAttribute('href'))) {
                        a.classList.add('active');
                    }
                });
            })
            .catch(() => {
                // 요청 실패 시 로그인 버튼 노출
                document.getElementById('header-login-btn').style.display = '';
            });

        // 로그아웃 버튼 클릭 처리
        document.getElementById('header-logout-btn').addEventListener('click', function () {
            fetch('${pageContext.request.contextPath}/user/logout', { method: 'POST' })
                .then(res => res.json())
                .then(() => {
                    window.location.href = '${pageContext.request.contextPath}/';
                });
        });
    })();
</script>
