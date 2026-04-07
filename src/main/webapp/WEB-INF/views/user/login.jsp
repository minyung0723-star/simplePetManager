<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header_design.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user/register.css">
</head>
<body>

<div class="user-login-container">
    <img src="${pageContext.request.contextPath}/images/petlogo.png"
         class="user-login-logo" id="logoBtn" alt="로고">

    <div class="user-login-card">
        <div id="loginAlert" class="alert d-none mb-3"></div>

        <input type="text" id="userId" class="form-control user-login-input mb-2" placeholder="아이디">

        <div class="position-relative mb-2">
            <input type="password" id="userPassword" class="form-control user-login-input"
                   placeholder="비밀번호" style="padding-right: 40px;">
            <span id="togglePw">👁️</span>
        </div>

        <div class="d-flex justify-content-start align-items-center mb-3 px-1">
            <div class="form-check">
                <input class="form-check-input" type="checkbox" id="rememberMe">
                <label class="form-check-label small text-muted" for="rememberMe">
                    아이디 기억하기
                </label>
            </div>
        </div>

        <button type="button" id="btnLogin" class="user-login-btn w-100">로그인</button>

        <div class="user-login-links mt-3 text-center">
            <a href="${pageContext.request.contextPath}/findUser?mode=id">아이디 찾기</a> |
            <a href="${pageContext.request.contextPath}/findUser?mode=pw">비밀번호 찾기</a> |
            <a href="${pageContext.request.contextPath}/register">회원가입</a>
        </div>
    </div>
</div>

<script>
    window.contextPath = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/js/user/login.js"></script>

</body>
</html>