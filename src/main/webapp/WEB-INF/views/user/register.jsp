<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header_design.css?v=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/register.css?v=1.0">
</head>
<body>

<div class="user-login-container">
    <img src="${pageContext.request.contextPath}/images/petlogo.png"
         class="user-login-logo" id="logoBtn" alt="Logo">

    <div class="user-login-card">
        <h4 class="mb-4 fw-bold">회원가입</h4>

        <div id="alertBox" class="alert alert-danger d-none mb-3"></div>

        <div class="auth-group">
            <input type="text" id="userId" class="form-control user-login-input" placeholder="아이디">
            <button type="button" id="btnCheckId" class="btn btn-outline-secondary btn-auth">중복확인</button>
        </div>
        <div id="idStatusMsg"></div>

        <div class="position-relative mb-2">
            <input type="password" id="userPassword" class="form-control user-login-input" placeholder="비밀번호">
            <span id="togglePw">👁️</span>
        </div>

        <input type="password" id="userPasswordCheck" class="form-control user-login-input" placeholder="비밀번호 확인">
        <div id="pwMatchMsg"></div>

        <input type="text" id="userName" class="form-control user-login-input" placeholder="이름">

        <div class="find-email-group">
            <input type="text" id="emailPrefix" class="form-control user-login-input" placeholder="이메일">
            <span class="email-at">@</span>
            <select id="emailDomain" class="form-select user-login-input">
                <option value="naver.com">naver.com</option>
                <option value="gmail.com">gmail.com</option>
                <option value="hanmail.net">hanmail.net</option>
                <option value="daum.net">daum.net</option>
                <option value="">직접입력</option>
            </select>
            <button type="button" id="btnRequestAuth" class="btn btn-outline-secondary btn-auth btn-request">인증요청</button>
        </div>

        <input type="text" id="emailDirect" class="form-control user-login-input d-none" placeholder="도메인 직접 입력">

        <div class="auth-group mt-2">
            <div class="position-relative flex-grow-1">
                <input type="text" id="emailCode" class="form-control user-login-input"
                       placeholder="인증번호 입력" autocomplete="off"
                       inputmode="numeric" maxlength="6">
                <span id="timerSpan">05:00</span>
            </div>
            <button type="button" id="btnVerifyCode" class="btn btn-outline-success btn-auth">확인</button>
        </div>

        <div id="emailStatusMsg"></div>

        <button type="button" id="btnRegister" class="user-login-btn mt-4">회원가입</button>

        <div class="user-login-links mt-3">
            <a href="${pageContext.request.contextPath}/login">이미 계정이 있으신가요? 로그인</a>
        </div>
    </div>
</div>

<script>window.contextPath = "${pageContext.request.contextPath}";</script>
<script src="${pageContext.request.contextPath}/js/user/register.js"></script>
</body>
</html>