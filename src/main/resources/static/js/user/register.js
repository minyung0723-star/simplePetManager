/**
 * 1. 상태 관리
 */
const state = {
    isEmailVerified: false,
    contextPath: window.contextPath || ""
};

/**
 * 2. DOM 요소 참조
 */
const nodes = {
    userId: document.getElementById("userId"),
    userPw: document.getElementById("userPassword"),
    userPwCheck: document.getElementById("userPasswordCheck"),
    userName: document.getElementById("userName"),
    userEmail: document.getElementById("userEmail"),
    emailCode: document.getElementById("emailCode"),
    pwMsg: document.getElementById("pwMatchMsg"),
    emailMsg: document.getElementById("emailStatusMsg"),
    alertBox: document.getElementById("alertBox"),
    // Buttons
    logoBtn: document.getElementById("logoBtn"),
    btnRequestAuth: document.getElementById("btnRequestAuth"),
    btnVerifyCode: document.getElementById("btnVerifyCode"),
    btnRegister: document.getElementById("btnRegister")
};

/**
 * 3. 기능 로직 (함수들)
 */

// register.js 내의 handlePasswordInput 함수 수정
const handlePasswordInput = () => {
    const pw = nodes.userPw.value;
    const check = nodes.userPwCheck.value;
    const pwPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$])[A-Za-z\d!@#$]{8,}$/;

    nodes.pwMsg.classList.remove("d-none");

    // 1. 복잡도 검사
    if (!pwPattern.test(pw)) {
        nodes.pwMsg.className = "text-danger small mb-2";
        nodes.pwMsg.textContent = "비밀번호는 8자 이상, 영문 대/소문자, 숫자, 특수문자(!@#$)를 포함해야 합니다.";
        return;
    }

    // 2. 일치 여부 확인
    if (check === "") {
        nodes.pwMsg.classList.add("d-none");
        return;
    }

    if (pw === check) {
        nodes.pwMsg.className = "text-success small mb-2";
        nodes.pwMsg.textContent = "안전한 비밀번호이며, 일치합니다.";
    } else {
        nodes.pwMsg.className = "text-danger small mb-2";
        nodes.pwMsg.textContent = "비밀번호가 일치하지 않습니다.";
    }
};

// 이메일 인증번호 발송 요청
const requestEmailAuth = async () => {
    const email = nodes.userEmail.value.trim();
    if (!email) return alert("이메일을 입력해 주세요.");

    try {
        const res = await fetch(state.contextPath + "/api/email-auth", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ userEmail: email })
        });

        if (res.ok) {
            alert("인증번호가 발송되었습니다. 5분 이내에 입력해주세요.");
        } else {
            const data = await res.json();
            alert(data.message || "발송 실패. 이메일 주소를 확인해주세요.");
        }
    } catch (e) {
        console.error("인증 요청 에러:", e);
        alert("서버 통신 오류가 발생했습니다.");
    }
};

// 이메일 인증번호 검증
const verifyEmailCode = async () => {
    const email = nodes.userEmail.value.trim();
    const code = nodes.emailCode.value.trim();
    if (!code) return alert("인증번호를 입력해주세요.");

    try {
        const res = await fetch(state.contextPath + "/api/email-verify", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ userEmail: email, emailCode: code })
        });

        if (nodes.emailMsg) nodes.emailMsg.classList.remove("d-none");

        if (res.ok) {
            state.isEmailVerified = true;
            nodes.emailMsg.className = "text-success small mt-1 mb-3 text-start";
            nodes.emailMsg.textContent = "이메일 인증이 완료되었습니다.";
            nodes.userEmail.readOnly = true;
            nodes.emailCode.readOnly = true;
        } else {
            state.isEmailVerified = false;
            nodes.emailMsg.className = "text-danger small mt-1 mb-3 text-start";
            nodes.emailMsg.textContent = "인증번호가 틀렸거나 만료되었습니다.";
        }
    } catch (e) {
        console.error("인증 확인 에러:", e);
        alert("서버 통신 오류가 발생했습니다.");
    }
};

// 최종 회원가입 제출
const handleRegister = async () => {
    const data = {
        userId: nodes.userId.value.trim(),
        userPassword: nodes.userPw.value.trim(),
        userName: nodes.userName.value.trim(),
        userEmail: nodes.userEmail.value.trim()
    };

    // 유효성 검사
    if (Object.values(data).some(val => !val)) return alert("모든 필수 정보를 입력해 주세요.");
    if (data.userPassword !== nodes.userPwCheck.value) return alert("비밀번호가 일치하지 않습니다.");
    if (!state.isEmailVerified) return alert("이메일 인증을 완료해 주세요.");

    try {
        const res = await fetch(state.contextPath + "/api/register", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(data)
        });

        if (res.ok) {
            location.href = state.contextPath + "/login?success";
        } else {
            const errorData = await res.json();
            if (nodes.alertBox) {
                nodes.alertBox.classList.remove("d-none");
                nodes.alertBox.textContent = errorData.message || "회원가입에 실패했습니다.";
            }
        }
    } catch (e) {
        console.error("회원가입 요청 에러:", e);
        alert("서버 통신 중 오류가 발생했습니다.");
    }
};

/**
 * 4. 이벤트 리스너 등록
 */
const init = () => {
    if (nodes.logoBtn) {
        nodes.logoBtn.addEventListener("click", () => {
            location.href = state.contextPath + "/";
        });
    }

    if (nodes.userPw) nodes.userPw.addEventListener("input", handlePasswordInput);
    if (nodes.userPwCheck) nodes.userPwCheck.addEventListener("input", handlePasswordInput);

    if (nodes.btnRequestAuth) nodes.btnRequestAuth.addEventListener("click", requestEmailAuth);
    if (nodes.btnVerifyCode) nodes.btnVerifyCode.addEventListener("click", verifyEmailCode);
    if (nodes.btnRegister) nodes.btnRegister.addEventListener("click", handleRegister);
};

document.addEventListener("DOMContentLoaded", init);