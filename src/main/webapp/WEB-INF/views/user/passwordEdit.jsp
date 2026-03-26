<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>비밀번호 재설정</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header_design.css">

    <style>
        body { background-color: #f5f6f8; }
        .pw-msg { font-size: 13px; margin-top: -8px; margin-bottom: 10px; display: block; }
        .text-success { color: #28a745 !important; }
        .text-danger { color: #dc3545 !important; }
    </style>
</head>
<body>

<div class="user-login-container">
    <img src="${pageContext.request.contextPath}/images/petlogo.png"
         class="user-login-logo"
         onclick="location.href='${pageContext.request.contextPath}/'">

    <div class="user-login-card">
        <h4 class="text-start mb-1" style="font-weight: bold;">비밀번호 재설정</h4>
        <p class="text-start text-muted small mb-4">새로운 비밀번호를 입력해 주세요.</p>

        <div class="mb-3">
            <label class="form-label d-block text-start small text-muted">대상 아이디</label>
            <input type="text" id="targetUserId" class="form-control user-login-input" readonly style="background-color: #eee;">
        </div>

        <input type="password" id="newPassword" class="form-control user-login-input" placeholder="새 비밀번호">

        <input type="password" id="confirmPassword" class="form-control user-login-input" placeholder="새 비밀번호 확인" oninput="validatePassword()">
        <span id="pwMatchMsg" class="pw-msg text-start"></span>

        <button class="user-login-btn mt-3" id="submitBtn" onclick="updatePassword()" disabled>비밀번호 변경하기</button>

        <div class="user-login-links mt-4">
            <a href="${pageContext.request.contextPath}/user/login">로그인으로 돌아가기</a>
        </div>
    </div>
</div>

<script>
    // 1. 페이지 로드 시 URL에서 userId 파라미터를 가져와 표시
    window.onload = function() {
        const urlParams = new URLSearchParams(window.location.search);
        const userId = urlParams.get('userId');

        if (!userId) {
            alert("잘못된 접근입니다.");
            location.href = "${pageContext.request.contextPath}/user/login";
            return;
        }
        document.getElementById("targetUserId").value = userId;
    };

    // 2. 비밀번호 일치 여부 실시간 체크
    function validatePassword() {
        const pw = document.getElementById("newPassword").value;
        const confirm = document.getElementById("confirmPassword").value;
        const msg = document.getElementById("pwMatchMsg");
        const btn = document.getElementById("submitBtn");

        if (confirm === "") {
            msg.textContent = "";
            btn.disabled = true;
            return;
        }

        if (pw === confirm) {
            msg.textContent = "비밀번호가 일치합니다.";
            msg.className = "pw-msg text-start text-success";
            btn.disabled = false;
        } else {
            msg.textContent = "비밀번호가 일치하지 않습니다.";
            msg.className = "pw-msg text-start text-danger";
            btn.disabled = true;
        }
    }

    // 3. 서버에 비밀번호 변경 요청 전송
    async function updatePassword() {
        const userId = document.getElementById("targetUserId").value;
        const userPassword = document.getElementById("newPassword").value;

        if (!userPassword) {
            alert("비밀번호를 입력해주세요.");
            return;
        }

        try {
            const res = await fetch("${pageContext.request.contextPath}/user/update-password", {
                method: "POST",
                headers: {"Content-Type": "application/json"},
                body: JSON.stringify({ userId, userPassword }),
            });

            if (res.ok) {
                alert("비밀번호가 성공적으로 변경되었습니다.\n다시 로그인 해주세요.");
                location.href = "${pageContext.request.contextPath}/user/login";
            } else {
                const data = await res.json();
                alert(data.message || "비밀번호 변경에 실패했습니다.");
            }
        } catch (error) {
            console.error("Error:", error);
            alert("서버 통신 중 오류가 발생했습니다.");
        }
    }
</script>

</body>
</html>