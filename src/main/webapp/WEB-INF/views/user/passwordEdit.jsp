<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>비밀번호 재설정</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header_design.css">
</head>
<body>

<div class="user-login-container">
    <img src="${pageContext.request.contextPath}/images/petlogo.png"
         class="user-login-logo"
         onclick="location.href='${pageContext.request.contextPath}/'"
         style="cursor:pointer;">

    <div class="user-login-card">
        <h4 class="text-start mb-1" style="font-weight: bold;">비밀번호 재설정</h4>
        <p class="text-start text-muted small mb-4">새로운 비밀번호를 입력해 주세요.</p>

        <div class="mb-3">
            <label class="form-label d-block text-start small text-muted">대상 아이디</label>
            <input type="text" id="targetUserId" class="form-control user-login-input" readonly>
        </div>

        <input type="password" id="newPassword" class="form-control user-login-input" placeholder="새 비밀번호" oninput="validatePassword()">

        <input type="password" id="confirmPassword" class="form-control user-login-input" placeholder="새 비밀번호 확인" oninput="validatePassword()">
        <span id="pwMatchMsg" class="pw-edit-msg text-start"></span>

        <button class="user-login-btn mt-3" id="submitBtn" onclick="updatePassword()" disabled>
            비밀번호 변경하기
        </button>

        <div class="user-login-links mt-4">
            <a href="${pageContext.request.contextPath}/login">로그인으로 돌아가기</a>
        </div>
    </div>
</div>

<script>
    // 1. 페이지 로드 시 URL 파라미터 체크
    window.onload = () => {
        const urlParams = new URLSearchParams(window.location.search);
        const userId = urlParams.get('userId');

        if (!userId) {
            alert("잘못된 접근입니다. 아이디 찾기/비밀번호 찾기부터 진행해 주세요.");
            location.href = "${pageContext.request.contextPath}/login";
            return;
        }

        const targetInput = document.getElementById("targetUserId");
        if (targetInput) targetInput.value = userId;
    };

    // 2. 실시간 비밀번호 일치 검증
    const validatePassword = () => {
        const pw = document.getElementById("newPassword").value;
        const confirm = document.getElementById("confirmPassword").value;
        const msg = document.getElementById("pwMatchMsg");
        const btn = document.getElementById("submitBtn");

        // 비밀번호가 비어있는 경우 초기화
        if (pw === "" && confirm === "") {
            msg.textContent = "";
            btn.disabled = true;
            return;
        }

        // 비밀번호 일치 여부 확인
        if (pw === confirm && pw.length > 0) {
            msg.textContent = "비밀번호가 일치합니다.";
            msg.className = "pw-edit-msg text-start text-success"; // 부트스트랩 클래스 활용
            btn.disabled = false;
        } else {
            msg.textContent = "비밀번호가 일치하지 않습니다.";
            msg.className = "pw-edit-msg text-start text-danger"; // 부트스트랩 클래스 활용
            btn.disabled = true;
        }
    };

    // 3. 서버에 비밀번호 변경 요청 전송
    const updatePassword = async () => {
        const userId = document.getElementById("targetUserId").value;
        const userPassword = document.getElementById("newPassword").value.trim();

        if (!userPassword) {
            alert("새로운 비밀번호를 입력해주세요.");
            return;
        }

        try {

            const res = await fetch("${pageContext.request.contextPath}/api/update-password", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({
                    userId: userId,
                    userPassword: userPassword
                }),
            });

            if (res.ok) {
                alert("비밀번호가 성공적으로 변경되었습니다.\n새로운 비밀번호로 로그인해 주세요.");
                location.href = "${pageContext.request.contextPath}/login";
            } else {
                const data = await res.json();
                alert(data.message || "비밀번호 변경 중 오류가 발생했습니다.");
            }
        } catch (error) {
            console.error("비밀번호 변경 에러:", error);
            alert("서버와 통신하는 중 오류가 발생했습니다.");
        }
    };
</script>
</script>

</body>
</html>