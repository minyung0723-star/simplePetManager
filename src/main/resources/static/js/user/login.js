/**
 * login.js
 */

const state = {
    contextPath: window.contextPath || "",
    COOKIE_NAME: "rememberedUserId",
    COOKIE_EXPIRY_DAYS: 7
};

const nodes = {
    userId:     document.getElementById("userId"),
    userPw:     document.getElementById("userPassword"),
    rememberMe: document.getElementById("rememberMe"),
    togglePw:   document.getElementById("togglePw"),
    alertBox:   document.getElementById("loginAlert"),
    logoBtn:    document.getElementById("logoBtn"),
    loginBtn:   document.getElementById("btnLogin")
};

/* ── 쿠키 유틸 (아이디 저장용 – 브라우저 JS 쿠키) ── */
const cookieUtil = {
    set(name, value, days) {
        let expires = "";
        if (days) {
            const d = new Date();
            d.setTime(d.getTime() + days * 24 * 60 * 60 * 1000);
            expires = "; expires=" + d.toUTCString();
        }
        document.cookie = `${name}=${value || ""}${expires}; path=/`;
    },
    get(name) {
        const eq = name + "=";
        for (let c of document.cookie.split(";")) {
            c = c.trimStart();
            if (c.startsWith(eq)) return c.substring(eq.length);
        }
        return null;
    }
};

/* ── 비밀번호 토글 ── */
const togglePasswordVisibility = () => {
    if (!nodes.userPw || !nodes.togglePw) return;
    const isPassword = nodes.userPw.type === "password";
    nodes.userPw.type = isPassword ? "text" : "password";
    nodes.togglePw.textContent = isPassword ? "🙈" : "👁️";
};

/* ── 알림 표시 ── */
const showAlert = (message, type = "danger") => {
    if (!nodes.alertBox) return;
    nodes.alertBox.classList.remove("d-none", "alert-danger", "alert-success");
    nodes.alertBox.classList.add(`alert-${type}`);
    nodes.alertBox.textContent = message;
};

/* ── 회원가입 성공 파라미터 체크 ── */
const checkRegistrationSuccess = () => {
    if (new URLSearchParams(window.location.search).has("success")) {
        showAlert("회원가입이 완료되었습니다. 로그인해주세요.", "success");
    }
};

/* ── 로그인 처리 ── */
const handleLogin = async () => {
    const userId       = nodes.userId.value.trim();
    const userPassword = nodes.userPw.value.trim();
    const isRemember   = nodes.rememberMe ? nodes.rememberMe.checked : false;

    if (!userId || !userPassword) {
        alert("아이디와 비밀번호를 입력하세요.");
        return;
    }

    try {
        const res  = await fetch(state.contextPath + "/api/login", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ userId, userPassword })
        });
        const data = await res.json();

        if (res.ok) {
            // 아이디 저장 쿠키 처리
            if (isRemember) {
                cookieUtil.set(state.COOKIE_NAME, userId, state.COOKIE_EXPIRY_DAYS);
            } else {
                cookieUtil.set(state.COOKIE_NAME, "", -1);
            }
            // ★ 수정: localStorage 저장 제거 – 헤더는 /mypage/info API로 상태 확인
            location.href = state.contextPath + "/";
        } else {
            showAlert(data.message || "아이디 또는 비밀번호가 올바르지 않습니다.");
        }
    } catch (err) {
        console.error("로그인 에러:", err);
        alert("서버와 통신하는 중 오류가 발생했습니다.");
    }
};

/* ── 초기화 ── */
const init = () => {
    const savedId = cookieUtil.get(state.COOKIE_NAME);
    if (savedId && nodes.userId) {
        nodes.userId.value = savedId;
        if (nodes.rememberMe) nodes.rememberMe.checked = true;
    }

    if (nodes.userId) {
        nodes.userId.addEventListener("input", (e) => {
            e.target.value = e.target.value.replace(/[^a-zA-Z0-9]/g, "");
        });
    }

    if (nodes.logoBtn)  nodes.logoBtn.addEventListener("click",    () => location.href = state.contextPath + "/");
    if (nodes.loginBtn) nodes.loginBtn.addEventListener("click",   handleLogin);
    if (nodes.togglePw) nodes.togglePw.addEventListener("click",   togglePasswordVisibility);
    if (nodes.userPw)   nodes.userPw.addEventListener("keypress",  (e) => { if (e.key === "Enter") handleLogin(); });

    checkRegistrationSuccess();
};

document.addEventListener("DOMContentLoaded", init);