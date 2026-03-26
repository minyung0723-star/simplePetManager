<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header_design.css">

    <style>
        /* 추가적인 스타일 보정 (필요시) */
        body { background-color: #f5f6f8; }
    </style>
</head>

<body>

<div class="user-login-container">

    <img src="${pageContext.request.contextPath}/images/petlogo.png"
         class="user-login-logo"
         onclick="location.href='${pageContext.request.contextPath}/'"
         alt="로고">

    <div class="user-login-card">

        <div id="알림창" class="d-none mb-3"></div>

        <input type="text"
               id="userId"
               class="form-control user-login-input"
               placeholder="아이디">

        <input type="password"
               id="userPassword"
               class="form-control user-login-input"
               placeholder="비밀번호">

        <button class="user-login-btn" onclick="login()">로그인</button>

        <div class="user-login-links">
            <a href="${pageContext.request.contextPath}/user/findUser?mode=id">아이디 찾기</a> |
            <a href="${pageContext.request.contextPath}/user/findUser?mode=pw">비밀번호 찾기</a> |
            <a href="${pageContext.request.contextPath}/user/register">회원가입</a>
        </div>

    </div>
</div>

<script>
    // URL 파라미터를 확인하여 회원가입 완료 등의 메시지 처리
    const params = new URLSearchParams(window.location.search);
    if (params.has('success')) {
        const el = document.getElementById("알림창");
        el.classList.remove("d-none");
        el.className = "alert alert-success";
        el.textContent = "회원가입이 완료되었습니다. 로그인해주세요.";
    }

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
                // 로그인 성공 시 메인 페이지로 이동
                window.location.href = "${pageContext.request.contextPath}/";
            } else {
                // 로그인 실패 시 알림창 표시
                const el = document.getElementById("알림창");
                el.classList.remove("d-none");
                el.className = "alert alert-danger";
                el.textContent = data.message || "로그인 정보가 올바르지 않습니다.";
            }
        } catch (error) {
            console.error("로그인 에러:", error);
            alert("서버 통신 중 오류가 발생했습니다.");
        }
    }
</script>

</body>
</html>