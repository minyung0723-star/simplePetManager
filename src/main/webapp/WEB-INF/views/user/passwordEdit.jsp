<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>비밀번호 재설정</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header_design.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/passwordEdit.css">
</head>
<body>

<div class="user-login-container">
    <img src="${pageContext.request.contextPath}/images/petlogo.png"
         class="user-login-logo" id="logoBtn" alt="Logo">

    <div class="user-login-card">
        <h4 class="text-start mb-1 fw-bold">비밀번호 재설정</h4>
        <p class="text-start text-muted small mb-4">새로운 비밀번호를 입력해 주세요.</p>

        <div class="mb-3 text-start">
            <label class="form-label small text-muted">대상 아이디</label>
            <input type="text" id="targetUserId" class="form-control user-login-input" readonly>
        </div>

        <div class="position-relative mb-3 password-wrapper">
            <input type="password" id="newPassword" class="form-control user-login-input" placeholder="새 비밀번호">
            <span id="togglePw">👁️</span>
        </div>

        <div class="position-relative mb-1 password-wrapper">
            <input type="password" id="confirmPassword" class="form-control user-login-input" placeholder="새 비밀번호 확인">
        </div>

        <div id="pwMatchMsg" class="pw-edit-msg"></div>

        <button class="user-login-btn mt-2" id="submitBtn" disabled>
            비밀번호 변경하기
        </button>

        <div class="user-login-links mt-4">
            <a href="${pageContext.request.contextPath}/login">로그인으로 돌아가기</a>
        </div>
    </div>
</div>

<script>
    // JS에서 공통으로 사용할 컨텍스트 경로 선언
    window.contextPath = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/js/user/passwordEdit.js"></script>

</body>
</html>