<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header_design.css">
    <style>
        /* 추가적인 스타일 조정이 필요하다면 여기에 작성하세요 */
        .user-login-input { margin-bottom: 15px; }
        .auth-group { display: flex; gap: 10px; margin-bottom: 15px; }
        .btn-auth { white-space: nowrap; }
    </style>
</head>
<body>

<div class="user-login-container">
    <img src="${pageContext.request.contextPath}/images/petlogo.png"
         class="user-login-logo" id="logoBtn" alt="Logo" style="cursor:pointer;">

    <div class="user-login-card">
        <h4 class="mb-4 fw-bold">회원가입</h4>

        <div id="alertBox" class="alert alert-danger d-none mb-3"></div>

        <input type="text" id="userId" class="form-control user-login-input" placeholder="아이디">

        <input type="password" id="userPassword" class="form-control user-login-input" placeholder="비밀번호">

        <input type="password" id="userPasswordCheck" class="form-control user-login-input" placeholder="비밀번호 확인">
        <div id="pwMatchMsg" class="text-danger small mb-2 d-none"></div>

        <input type="text" id="userName" class="form-control user-login-input" placeholder="이름">

        <div class="auth-group">
            <input type="email" id="userEmail" class="form-control user-login-input" placeholder="이메일" style="margin-bottom:0;">
            <button type="button" id="btnRequestAuth" class="btn btn-outline-secondary btn-auth">인증번호요청</button>
        </div>

        <div class="auth-group">
            <input type="text" id="emailCode" class="form-control user-login-input" placeholder="인증번호 입력" style="margin-bottom:0;">
            <button type="button" id="btnVerifyCode" class="btn btn-outline-success btn-auth">확인</button>
        </div>

        <div id="emailStatusMsg" class="small mt-1 mb-3 d-none text-start" style="padding-left: 5px;"></div>

        <button type="button" id="btnRegister" class="user-login-btn mt-4">회원가입</button>

        <div class="user-login-links mt-3">
            <a href="${pageContext.request.contextPath}/login">이미 계정이 있으신가요? 로그인</a>
        </div>
    </div>
</div>

<script>
    // 전역 변수로 contextPath 설정
    window.contextPath = "${pageContext.request.contextPath}";
</script>

<script src="${pageContext.request.contextPath}/js/user/register.js"></script>

</body>
</html>