<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header_design.css">
</head>
<body>

<div class="user-login-container">
    <img src="${pageContext.request.contextPath}/images/petlogo.png"
         class="user-login-logo"
         onclick="location.href='${pageContext.request.contextPath}/'">

    <div class="user-login-card">
        <h4 class="mb-3 fw-bold">회원가입</h4>
        <div id="alertBox" class="d-none mb-3"></div>

        <input type="text" id="userId" class="form-control user-login-input" placeholder="아이디">

        <input type="password" id="userPassword" class="form-control user-login-input" placeholder="비밀번호">

        <input type="password" id="userPasswordCheck" class="form-control user-login-input" placeholder="비밀번호 확인">
        <div id="pwMatchMsg" class="text-danger small mb-2 d-none"></div>

        <input type="text" id="userName" class="form-control user-login-input" placeholder="이름">

        <div class="d-flex">
            <input type="email" id="userEmail" class="form-control user-login-input" placeholder="이메일">
            <button class="btn btn-outline-secondary ms-2" style="height: 50px;" onclick="requestEmailAuth()">인증</button>
        </div>

        <div class="d-flex mt-2">
            <input type="text" id="emailCode" class="form-control user-login-input" placeholder="인증번호 입력">
            <button class="btn btn-outline-success ms-2" style="height: 50px;" onclick="verifyEmailCode()">확인</button>
        </div>
        <div id="emailStatusMsg" class="small mt-2 d-none"></div>

        <button class="user-login-btn mt-4" onclick="handleRegister()">회원가입</button>

        <div class="user-login-links">
            <a href="${pageContext.request.contextPath}/user/login">이미 계정이 있으신가요? 로그인</a>
        </div>
    </div>
</div>

<script>
    // 이메일 인증 여부를 저장하는 상태 변수
    let isEmailVerified = false;

    /**
     * 1. 비밀번호 실시간 일치 확인
     * 사용자가 '비밀번호 확인' 칸에 입력할 때마다 실행되어 일치 여부를 텍스트로 표시함
     */
    document.getElementById("userPasswordCheck").addEventListener("input", () => {
        const pw = document.getElementById("userPassword").value;
        const pwCheck = document.getElementById("userPasswordCheck").value;
        const msg = document.getElementById("pwMatchMsg");

        msg.classList.remove("d-none");
        if (pw !== pwCheck) {
            msg.className = "text-danger small mb-2";
            msg.textContent = "비밀번호가 일치하지 않습니다.";
        } else {
            msg.className = "text-success small mb-2";
            msg.textContent = "비밀번호가 일치합니다.";
        }
    });

    /**
     * 2. 이메일 인증번호 요청 (requestEmailAuth)
     * 입력된 이메일 주소로 서버에 인증 번호 발송을 요청함
     */
    async function requestEmailAuth() {
        const email = document.getElementById("userEmail").value.trim();

        if (!email) {
            alert("이메일을 입력해 주세요.");
            return;
        }

        // TODO: 실제 서버의 메일 발송 API와 연결 필요
        console.log("인증 번호 요청 이메일:", email);
        alert("인증번호가 이메일로 전송되었습니다. (테스트용 번호: 1234)");
    }

    /**
     * 3. 인증번호 확인 (verifyEmailCode)
     * 사용자가 입력한 번호가 서버에서 보낸 번호와 일치하는지 확인
     */
    function verifyEmailCode() {
        const code = document.getElementById("emailCode").value.trim();
        const msg = document.getElementById("emailStatusMsg");

        msg.classList.remove("d-none");
        if (code === "1234") { // 테스트용 하드코딩 (실제로는 서버 응답값과 비교)
            isEmailVerified = true;
            msg.className = "text-success small mt-2";
            msg.textContent = "이메일 인증이 완료되었습니다.";
        } else {
            isEmailVerified = false;
            msg.className = "text-danger small mt-2";
            msg.textContent = "인증번호가 일치하지 않습니다.";
        }
    }

    /**
     * 4. 최종 회원가입 처리 (handleRegister)
     * 모든 유효성 검사(필수 입력, 비밀번호 일치, 이메일 인증)를 통과하면 서버로 가입 요청 전송
     */
    async function handleRegister() {
        const userId = document.getElementById("userId").value.trim();
        const userPassword = document.getElementById("userPassword").value.trim();
        const userPasswordCheck = document.getElementById("userPasswordCheck").value.trim();
        const userName = document.getElementById("userName").value.trim();
        const userEmail = document.getElementById("userEmail").value.trim();

        // 4-1. 필수값 입력 체크
        if (!userId || !userPassword || !userName || !userEmail) {
            alert("모든 필수 정보를 입력해 주세요.");
            return;
        }

        // 4-2. 비밀번호 재확인
        if (userPassword !== userPasswordCheck) {
            alert("비밀번호가 일치하지 않습니다.");
            return;
        }

        // 4-3. 이메일 인증 완료 여부 확인
        if (!isEmailVerified) {
            alert("이메일 인증을 완료해 주세요.");
            return;
        }

        // 4-4. 서버 데이터 전송
        try {
            const res = await fetch("${pageContext.request.contextPath}/user/register", {
                method: "POST",
                headers: {"Content-Type": "application/json"},
                body: JSON.stringify({ userId, userPassword, userName, userEmail }),
            });

            if (res.ok) {
                // 가입 성공 시 로그인 페이지로 이동 (파라미터 포함)
                window.location.href = "${pageContext.request.contextPath}/user/login?success";
            } else {
                const data = await res.json();
                const el = document.getElementById("alertBox");
                el.classList.remove("d-none");
                el.className = "alert alert-danger";
                el.textContent = data.message || "회원가입에 실패했습니다.";
            }
        } catch (error) {
            console.error("회원가입 요청 에러:", error);
            alert("서버 통신 중 오류가 발생했습니다.");
        }
    }
</script>

</body>
</html>