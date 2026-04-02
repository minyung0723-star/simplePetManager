<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header_design.css">

</head>

<body>

<div class="user-login-container">

    <img src="${pageContext.request.contextPath}/images/petlogo.png"
         class="user-login-logo"
         onclick="location.href='${pageContext.request.contextPath}/'"
         alt="로고"
         style="cursor: pointer;">

    <div class="user-login-card">

        <div id="알림창" class="login-alert d-none mb-3"></div>

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
            <a href="${pageContext.request.contextPath}/findUser?mode=id">아이디 찾기</a> |
            <a href="${pageContext.request.contextPath}/findUser?mode=pw">비밀번호 찾기</a> |
            <a href="${pageContext.request.contextPath}/register">회원가입</a>
        </div>

    </div>
</div>

<script>
    // 1. URL 파라미터 체크 (즉시 실행)
    const checkUrlParams = () => {
        const params = new URLSearchParams(window.location.search);
        const el = document.getElementById("알림창");
        if (params.has('success') && el) {
            el.classList.remove("d-none");
            el.className = "alert alert-success mb-3";
            el.textContent = "회원가입이 완료되었습니다. 로그인해주세요.";
        }
    };
    checkUrlParams();

    // 2. 엔터 키 입력 시 로그인 실행
    const passwordInput = document.getElementById("userPassword");
    if (passwordInput) {
        passwordInput.addEventListener("keypress", (e) => {
            if (e.key === "Enter") {
                login(); // 아래 정의된 login 함수 호출
            }
        });
    }

    // 3. 로그인 함수 (이름을 login으로 통일)
    const login = async () => {
        const userId = document.getElementById("userId").value.trim();
        const userPassword = document.getElementById("userPassword").value.trim();

        if (!userId || !userPassword) {
            alert("아이디와 비밀번호를 입력하세요.");
            return;
        }

        try {
            const res = await fetch("${pageContext.request.contextPath}/api/login", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ userId, userPassword }),
            });

            // 응답 데이터 파싱 (res.ok 체크 전에 먼저 파싱하는 것이 안전함)
            const data = await res.json();

            if (res.ok) {
                // 로그인 성공 처리
                localStorage.setItem("isLoggedIn", "true");
                localStorage.setItem("userName", data.userName);
                window.location.href = "${pageContext.request.contextPath}/";
            } else {
                // 로그인 실패 처리
                const el = document.getElementById("알림창");
                if (el) {
                    el.classList.remove("d-none");
                    el.className = "alert alert-danger mb-3";
                    el.textContent = data.message || "아이디 또는 비밀번호가 올바르지 않습니다.";
                }
            }
        } catch (error) {
            console.error("로그인 에러:", error);
            alert("서버와 통신하는 중 오류가 발생했습니다.");
        }
    };
</script>

</body>
</html>