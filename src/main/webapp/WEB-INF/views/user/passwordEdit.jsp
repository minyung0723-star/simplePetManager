<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>비밀번호 재설정</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header_design.css">
    <style>
        /* 가독성을 위한 추가 스타일 */
        .pw-edit-msg { font-size: 0.85rem; display: block; min-height: 1.2rem; margin-top: 5px; }
    </style>
</head>
<body>

<div class="user-login-container">
    <img src="${pageContext.request.contextPath}/images/petlogo.png"
         class="user-login-logo" id="logoBtn" alt="Logo" style="cursor:pointer;">

    <div class="user-login-card">
        <h4 class="text-start mb-1" style="font-weight: bold;">비밀번호 재설정</h4>
        <p class="text-start text-muted small mb-4">새로운 비밀번호를 입력해 주세요.</p>

        <div class="mb-3">
            <label class="form-label d-block text-start small text-muted">대상 아이디</label>
            <input type="text" id="targetUserId" class="form-control user-login-input" readonly>
        </div>

        <input type="password" id="newPassword" class="form-control user-login-input" placeholder="새 비밀번호">

        <input type="password" id="confirmPassword" class="form-control user-login-input" placeholder="새 비밀번호 확인">
        <span id="pwMatchMsg" class="pw-edit-msg text-start"></span>

        <button class="user-login-btn mt-3" id="submitBtn" disabled>
            비밀번호 변경하기
        </button>

        <div class="user-login-links mt-4">
            <a href="${pageContext.request.contextPath}/login">로그인으로 돌아가기</a>
        </div>
    </div>
</div>

<script>
    // 전역 변수로 contextPath 설정
    window.contextPath = "${pageContext.request.contextPath}";
</script>

<script src="${pageContext.request.contextPath}/js/user/passwordEdit.js"></script>

</body>
</html>