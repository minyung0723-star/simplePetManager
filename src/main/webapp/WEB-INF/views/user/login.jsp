<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header_design.css">

    <style>
        /* 추가적인 스타일 보정 */
        body { background-color: #f5f6f8; }
        .user-login-card { padding: 30px; border-radius: 10px; background: white; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
    </style>
</head>

<body>

<div class="user-login-container">

    <img src="${pageContext.request.contextPath}/images/petlogo.png"
         class="user-login-logo"
         onclick="location.href='${pageContext.request.contextPath}/'"
         alt="로고"
         style="cursor: pointer;">

    <div class="user-login-card">

        <div id="알림창" class="d-none mb-3"></div>

        <input type="text"
               id="userId"
               class="form-control user-login-input mb-2"
               placeholder="아이디">

        <input type="password"
               id="userPassword"
               class="form-control user-login-input mb-3"
               placeholder="비밀번호">

        <button class="user-login-btn w-100" onclick="login()">로그인</button>

        <div class="user-login-links mt-3 text-center">
            <a href="${pageContext.request.contextPath}/user/findUser?mode=id">아이디 찾기</a> |
            <a href="${pageContext.request.contextPath}/user/findUser?mode=pw">비밀번호 찾기</a> |
            <a href="${pageContext.request.contextPath}/user/register">회원가입</a>
        </div>

    </div>
</div>

<script>
    // 1. 회원가입 완료 등 URL 파라미터 메시지 처리
    const params = new URLSearchParams(window.location.search);
    if (params.has('success')) {
        const el = document.getElementById("알림창");
        el.classList.remove("d-none");
        el.className = "alert alert-success";
        el.textContent = "회원가입이 완료되었습니다. 로그인해주세요.";
    }

    // 2. 엔터 키 입력 시 로그인 실행
    document.getElementById("userPassword").addEventListener("keypress", function(e) {
        if (e.key === "Enter") {
            login();
        }
    });

    // 3. 로그인 함수
    async function login() {
        const userId = document.getElementById("userId").value.trim();
        const userPassword = document.getElementById("userPassword").value.trim();

        if (!userId || !userPassword) {
            alert("아이디와 비밀번호를 입력하세요.");
            return;
        }

        try {
            const res = await fetch("${pageContext.request.contextPath}/user/login", {
                method: "POST",
                headers: {"Content-Type": "application/json"},
                body: JSON.stringify({ userId, userPassword }),
            });

            const data = await res.json();

            if (res.ok) {
                // ✅ 중요: 헤더의 디자인 변경 및 환영 문구를 위한 데이터 저장
                // HttpOnly 쿠키는 JS가 읽을 수 없으므로 브라우저 저장소(localStorage)를 활용합니다.
                localStorage.setItem("isLoggedIn", "true");

                // 서버(UserApiController)에서 보낸 사용자 이름을 저장 (ㅇㅇㅇ님 환영합니다 용도)
                localStorage.setItem("userName", data.userName);

                // 로그인 성공 시 메인 페이지로 이동
                window.location.href = "${pageContext.request.contextPath}/";
            } else {
                // 로그인 실패 시 알림창 표시
                const el = document.getElementById("알림창");
                el.classList.remove("d-none");
                el.className = "alert alert-danger";

                // 서버에서 보낸 에러 메시지가 있으면 표시
                el.textContent = data.message || "아이디 또는 비밀번호가 올바르지 않습니다.";
            }
        } catch (error) {
            console.error("로그인 에러:", error);
            alert("서버와 통신하는 중 오류가 발생했습니다.");
        }
    }
</script>

</body>
</html>