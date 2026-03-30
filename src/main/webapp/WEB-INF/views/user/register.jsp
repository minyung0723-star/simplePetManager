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
            <button type="button" class="btn btn-outline-secondary ms-2" style="height: 50px;" onclick="requestEmailAuth()">인증</button>
        </div>

        <div class="d-flex mt-2">
            <input type="text" id="emailCode" class="form-control user-login-input" placeholder="인증번호 입력">
            <button type="button" class="btn btn-outline-success ms-2" style="height: 50px;" onclick="verifyEmailCode()">확인</button>
        </div>

        <div id="emailStatusMsg" class="small mt-2 d-none"></div>

        <button type="button" class="user-login-btn mt-4" onclick="handleRegister()">회원가입</button>

        <div class="user-login-links">
            <a href="${pageContext.request.contextPath}/user/login">이미 계정이 있으신가요? 로그인</a>
        </div>
    </div>
</div>

<script>

    // 이메일 인증 여부 저장
    let isEmailVerified = false;

    // 비밀번호 일치 확인
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


    // 이메일 인증 요청
    async function requestEmailAuth() {

        const email = document.getElementById("userEmail").value.trim();

        if (!email) {
            alert("이메일을 입력해 주세요.");
            return;
        }

        // 실제 이메일 API 연결 필요
        console.log("인증 요청 이메일 :", email);

        alert("인증번호가 이메일로 전송되었습니다. (테스트용 번호 : 1234)");

    }


    // 인증번호 확인
    function verifyEmailCode() {

        const code = document.getElementById("emailCode").value.trim();
        const msg = document.getElementById("emailStatusMsg");

        msg.classList.remove("d-none");

        if (code === "1234") {

            isEmailVerified = true;

            msg.className = "text-success small mt-2";
            msg.textContent = "이메일 인증이 완료되었습니다.";

        } else {

            isEmailVerified = false;

            msg.className = "text-danger small mt-2";
            msg.textContent = "인증번호가 일치하지 않습니다.";

        }

    }


    // 회원가입 처리
    async function handleRegister() {

        const userId = document.getElementById("userId").value.trim();
        const userPassword = document.getElementById("userPassword").value.trim();
        const userPasswordCheck = document.getElementById("userPasswordCheck").value.trim();
        const userName = document.getElementById("userName").value.trim();
        const userEmail = document.getElementById("userEmail").value.trim();


        // 필수 입력 체크
        if (!userId || !userPassword || !userName || !userEmail) {
            alert("모든 필수 정보를 입력해 주세요.");
            return;
        }


        // 비밀번호 확인
        if (userPassword !== userPasswordCheck) {
            alert("비밀번호가 일치하지 않습니다.");
            return;
        }


        // 이메일 인증 여부
        if (!isEmailVerified) {
            alert("이메일 인증을 완료해 주세요.");
            return;
        }


        try {

            const res = await fetch("${pageContext.request.contextPath}/user/register", {

                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({
                    userId,
                    userPassword,
                    userName,
                    userEmail
                })

            });


            if (res.ok) {

                window.location.href =
                    "${pageContext.request.contextPath}/user/login?success";

            } else {

                const data = await res.json();

                const el = document.getElementById("alertBox");

                el.classList.remove("d-none");
                el.className = "alert alert-danger";

                el.textContent =
                    data.message || "회원가입에 실패했습니다.";

            }

        } catch (error) {

            console.error("회원가입 요청 에러:", error);

            alert("서버 통신 중 오류가 발생했습니다.");

        }

    }

</script>

</body>
</html>