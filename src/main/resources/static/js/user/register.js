/**
 * 1. 상태 관리
 */
const state = {
    isIdChecked: false,
    isEmailVerified: false,
    contextPath: window.contextPath || "",
    emailTimer: null
};

/**
 * 2. DOM 요소 참조
 */
const nodes = {
    userId: document.getElementById("userId"),
    btnCheckId: document.getElementById("btnCheckId"),
    idMsg: document.getElementById("idStatusMsg"),
    userPw: document.getElementById("userPassword"),
    userPwCheck: document.getElementById("userPasswordCheck"),
    userName: document.getElementById("userName"),

    // [수정됨] 이메일 분할 입력 필드들
    emailPrefix: document.getElementById("emailPrefix"),
    emailDomain: document.getElementById("emailDomain"),
    emailDirect: document.getElementById("emailDirect"),

    emailCode: document.getElementById("emailCode"),
    pwMsg: document.getElementById("pwMatchMsg"),
    emailMsg: document.getElementById("emailStatusMsg"),
    alertBox: document.getElementById("alertBox"),
    timerSpan: document.getElementById("timerSpan"),

    logoBtn: document.getElementById("logoBtn"),
    btnRequestAuth: document.getElementById("btnRequestAuth"),
    btnVerifyCode: document.getElementById("btnVerifyCode"),
    btnRegister: document.getElementById("btnRegister"),
};

/**
 * 3. 기능 로직
 */

// [추가] 이메일 주소 합치기 헬퍼 함수
const getFullEmail = () => {
    const prefix = nodes.emailPrefix.value.trim();
    const domainSelect = nodes.emailDomain.value;
    const domainDirect = nodes.emailDirect.value.trim();
    const finalDomain = (domainSelect === "") ? domainDirect : domainSelect;

    return (prefix && finalDomain) ? `${prefix}@${finalDomain}` : "";
};

// [추가] 도메인 직접 입력 토글 핸들러
const handleEmailDomainChange = () => {
    if (nodes.emailDomain.value === "") {
        nodes.emailDirect.classList.remove("d-none");
        nodes.emailDirect.focus();
    } else {
        nodes.emailDirect.classList.add("d-none");
        nodes.emailDirect.value = "";
    }
};

const checkIdDuplicate = async () => {
    const userId = nodes.userId.value.trim();
    if (!userId) {
        alert("아이디를 입력해 주세요.");
        nodes.userId.focus();
        return;
    }

    try {
        const res = await fetch(`${state.contextPath}/api/check-id?userId=${userId}`);
        const data = await res.json();
        nodes.idMsg.classList.remove("d-none");

        if (data.isDuplicate === true) {
            state.isIdChecked = false;
            nodes.idMsg.textContent = "이미 사용 중인 아이디입니다.";
            nodes.idMsg.className = "text-danger small mb-3 text-start";
        } else {
            state.isIdChecked = true;
            nodes.idMsg.textContent = "사용 가능한 아이디입니다.";
            nodes.idMsg.className = "text-success small mb-3 text-start";
        }
    } catch (e) {
        console.error("아이디 중복 체크 에러:", e);
        alert("서버와 통신 중 오류가 발생했습니다.");
    }
};

const startEmailTimer = (duration) => {
    if (state.emailTimer) clearInterval(state.emailTimer);
    nodes.timerSpan.style.display = "block";
    let timeLeft = duration;

    state.emailTimer = setInterval(() => {
        let minutes = Math.floor(timeLeft / 60);
        let seconds = timeLeft % 60;
        minutes = minutes < 10 ? "0" + minutes : minutes;
        seconds = seconds < 10 ? "0" + seconds : seconds;

        nodes.timerSpan.textContent = `${minutes}:${seconds}`;

        if (--timeLeft < 0) {
            clearInterval(state.emailTimer);
            nodes.timerSpan.textContent = "만료";
            nodes.emailCode.value = "";
            alert("인증 시간이 만료되었습니다. 다시 요청해 주세요.");
        }
    }, 1000);
};

const handlePasswordInput = () => {
    const pw = nodes.userPw.value;
    const check = nodes.userPwCheck.value;
    const pwPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$])[A-Za-z\d!@#$]{8,}$/;

    nodes.pwMsg.classList.remove("d-none");

    if (!pwPattern.test(pw)) {
        nodes.pwMsg.className = "text-danger small mb-2";
        nodes.pwMsg.textContent = "비밀번호는 8자 이상, 영문 대/소문자, 숫자, 특수문자(!@#$)를 포함해야 합니다.";
        return;
    }

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

// [수정됨] 이메일 인증번호 발송 요청
const requestEmailAuth = async () => {
    const email = getFullEmail(); // 합쳐진 이메일 가져오기
    if (!email) return alert("이메일 주소를 완성해 주세요.");

    try {
        const res = await fetch(state.contextPath + "/api/email-auth", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ userEmail: email })
        });

        if (res.ok) {
            alert("인증번호가 발송되었습니다. 5분 이내에 입력해주세요.");
            startEmailTimer(300);
        } else {
            const data = await res.json();
            alert(data.message || "이미 가입된 이메일이거나 발송에 실패했습니다.");
        }
    } catch (e) {
        console.error("인증 요청 에러:", e);
        alert("서버 통신 오류가 발생했습니다.");
    }
};

// [수정됨] 이메일 인증번호 검증
const verifyEmailCode = async () => {
    const email = getFullEmail();
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

            // 인증 성공 시 필드 잠금
            nodes.emailPrefix.readOnly = true;
            nodes.emailDomain.disabled = true;
            nodes.emailDirect.readOnly = true;
            nodes.emailCode.readOnly = true;
            if (state.emailTimer) clearInterval(state.emailTimer);
            nodes.timerSpan.style.display = "none";
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

// [수정됨] 최종 회원가입 제출
const handleRegister = async () => {
    const email = getFullEmail();
    const data = {
        userId: nodes.userId.value.trim(),
        userPassword: nodes.userPw.value.trim(),
        userName: nodes.userName.value.trim(),
        userEmail: email
    };

    if (Object.values(data).some(val => !val)) return alert("모든 필수 정보를 입력해 주세요.");
    if (!state.isIdChecked) return alert("아이디 중복 확인을 완료해 주세요.");
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
    if (nodes.btnCheckId) nodes.btnCheckId.addEventListener("click", checkIdDuplicate);
    if (nodes.userPw) nodes.userPw.addEventListener("input", handlePasswordInput);
    if (nodes.userPwCheck) nodes.userPwCheck.addEventListener("input", handlePasswordInput);

    // [추가] 이메일 도메인 변경 리스너
    if (nodes.emailDomain) nodes.emailDomain.addEventListener("change", handleEmailDomainChange);

    if (nodes.btnRequestAuth) nodes.btnRequestAuth.addEventListener("click", requestEmailAuth);
    if (nodes.btnVerifyCode) nodes.btnVerifyCode.addEventListener("click", verifyEmailCode);
    if (nodes.btnRegister) nodes.btnRegister.addEventListener("click", handleRegister);

    const togglePw = document.getElementById("togglePw");
    if (togglePw) togglePw.addEventListener("click", togglePasswordVisibility);

    if (nodes.emailCode) nodes.emailCode.addEventListener("input", handleOnlyNumber);
};

const togglePasswordVisibility = () => {
    const pwInput = nodes.userPw;
    const toggleIcon = document.getElementById("togglePw");
    if (pwInput.type === "password") {
        pwInput.type = "text";
        toggleIcon.textContent = "🙈";
    } else {
        pwInput.type = "password";
        toggleIcon.textContent = "👁️";
    }
};

const handleOnlyNumber = (e) => {
    e.target.value = e.target.value.replace(/[^0-9]/g, "");
};

document.addEventListener("DOMContentLoaded", init);