<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header_design.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user/register.css">
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
        <div id="idStatusMsg" class="d-none"></div>

        <div class="position-relative mb-3">
            <input type="password" id="userPassword" class="form-control user-login-input" placeholder="비밀번호" style="padding-right: 40px;">
            <span id="togglePw" class="position-absolute top-50 translate-middle-y" style="right: 15px; cursor: pointer; z-index: 10;">👁️</span>
        </div>

        <input type="password" id="userPasswordCheck" class="form-control user-login-input" placeholder="비밀번호 확인">
        <div id="pwMatchMsg" class="text-danger small d-none"></div>

        <input type="text" id="userName" class="form-control user-login-input" placeholder="이름">

        <div class="find-email-group mb-2">
            <input type="text" id="emailPrefix" class="form-control user-login-input" placeholder="이메일" style="flex: 3;">

            <span class="mb-2" style="flex: 0.5; text-align: center;">@</span>

            <select id="emailDomain" class="form-select user-login-input" style="flex: 2;">
                <option value="naver.com">naver.com</option>
                <option value="gmail.com">gmail.com</option>
                <option value="hanmail.net">hanmail.net</option>
                <option value="daum.net">daum.net</option>
                <option value="">직접입력</option>
            </select>

            <button type="button" id="btnRequestAuth" class="btn btn-outline-secondary btn-auth" style="margin-left:8px; height:50px; flex: 1.5;">인증요청</button>
        </div>

        <input type="text" id="emailDirect" class="form-control user-login-input find-direct-input d-none" placeholder="도메인 직접 입력 (ex: nate.com)">

        <div class="auth-group">
            <div class="position-relative flex-grow-1">
                <input type="text" id="emailCode" class="form-control user-login-input"
                       placeholder="인증번호 입력" autocomplete="off"
                       inputmode="numeric" pattern="[0-9]*" maxlength="6"> <span id="timerSpan">05:00</span>
            </div>
            <button type="button" id="btnVerifyCode" class="btn btn-outline-success btn-auth">확인</button>
        </div>

        <div id="emailStatusMsg" class="small d-none"></div>

        <button type="button" id="btnRegister" class="user-login-btn mt-4">회원가입</button>

        <div class="user-login-links mt-3">
            <a href="${pageContext.request.contextPath}/login">이미 계정이 있으신가요? 로그인</a>
        </div>
    </div>
</div>

<script>
    // JS에서 contextPath를 사용하기 위한 설정
    window.contextPath = "${pageContext.request.contextPath}";
</script>

<script src="${pageContext.request.contextPath}/js/user/register.js"></script>

</body>
</html>