/**
 * 1. 상태 및 경로 관리
 */
const state = {
    // JSP에서 전달받은 contextPath 참조
    contextPath: window.contextPath || "",
    // 쿠키 관련 설정
    COOKIE_NAME: "rememberedUserId",
    COOKIE_EXPIRY_DAYS: 7
};

/**
 * 2. DOM 요소 참조
 */
const nodes = {
    userId: document.getElementById("userId"),
    userPw: document.getElementById("userPassword"),
    rememberMe: document.getElementById("rememberMe"), // 아이디 저장 체크박스
    togglePw: document.getElementById("togglePw"),     // 비밀번호 토글 버튼
    alertBox: document.getElementById("loginAlert"),
    logoBtn: document.getElementById("logoBtn"),
    loginBtn: document.getElementById("btnLogin")
};

/**
 * 3. 기능 로직 (함수들)
 */

// 쿠키 제어 유틸리티 (아이디 저장용)
const cookieUtil = {
    set: (name, value, days) => {
        let expires = "";
        if (days) {
            const date = new Date();
            date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
            expires = "; expires=" + date.toUTCString();
        }
        document.cookie = name + "=" + (value || "") + expires + "; path=/";
    },
    get: (name) => {
        const nameEQ = name + "=";
        const ca = document.cookie.split(';');
        for (let i = 0; i < ca.length; i++) {
            let c = ca[i];
            while (c.charAt(0) === ' ') c = c.substring(1, c.length);
            if (c.indexOf(nameEQ) === 0) return c.substring(nameEQ.length, c.length);
        }
        return null;
    }
};

// 비밀번호 가시성 토글
const togglePasswordVisibility = () => {
    if (!nodes.userPw || !nodes.togglePw) return;

    if (nodes.userPw.type === "password") {
        nodes.userPw.type = "text";
        nodes.togglePw.textContent = "🙈"; // 숨기기 아이콘
    } else {
        nodes.userPw.type = "password";
        nodes.togglePw.textContent = "👁️"; // 보기 아이콘
    }
};

// 회원가입 성공 메시지 확인
const checkRegistrationSuccess = () => {
    const params = new URLSearchParams(window.location.search);
    if (params.has('success')) {
        showAlert("회원가입이 완료되었습니다. 로그인해주세요.", "success");
    }
};

// 알림창 표시 함수
const showAlert = (message, type = "danger") => {
    if(!nodes.alertBox) return;
    nodes.alertBox.classList.remove("d-none", "alert-danger", "alert-success");
    nodes.alertBox.classList.add(`alert-${type}`);
    nodes.alertBox.textContent = message;
};

// 로그인 처리 함수
const handleLogin = async () => {
    const userId = nodes.userId.value.trim();
    const userPassword = nodes.userPw.value.trim();

    //  체크박스 상태 확인 (정의되지 않은 변수 오류 해결)
    const isRememberChecked = nodes.rememberMe ? nodes.rememberMe.checked : false;

    if (!userId || !userPassword) {
        alert("아이디와 비밀번호를 입력하세요.");
        return;
    }

    try {
        const res = await fetch(state.contextPath + "/api/login", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ userId, userPassword }),
        });

        const data = await res.json();

        if (res.ok) {
            // 1. 아이디 저장 쿠키 처리
            if (isRememberChecked) {
                cookieUtil.set(state.COOKIE_NAME, userId, state.COOKIE_EXPIRY_DAYS);
            } else {
                cookieUtil.set(state.COOKIE_NAME, "", -1); // 쿠키 삭제
            }

            // 2. 헤더 UI 변경을 위한 로컬 스토리지 저장
            localStorage.setItem("isLoggedIn", "true");
            localStorage.setItem("userName", data.userName);

            // 3. 메인 페이지 이동
            location.href = state.contextPath + "/";
        } else {
            showAlert(data.message || "아이디 또는 비밀번호가 올바르지 않습니다.");
        }
    } catch (error) {
        console.error("로그인 에러:", error);
        alert("서버와 통신하는 중 오류가 발생했습니다.");
    }
};

/**
 * 4. 이벤트 바인딩 및 초기화
 */
const init = () => {
    // 페이지 로드 시 저장된 아이디가 있으면 자동 입력
    const savedId = cookieUtil.get(state.COOKIE_NAME);
    if (savedId && nodes.userId) {
        nodes.userId.value = savedId;
        if (nodes.rememberMe) nodes.rememberMe.checked = true;
    }

    // 로고 클릭 이벤트
    if (nodes.logoBtn) {
        nodes.logoBtn.addEventListener("click", () => {
            location.href = state.contextPath + "/";
        });
    }

    // 로그인 버튼 클릭 이벤트
    if (nodes.loginBtn) {
        nodes.loginBtn.addEventListener("click", handleLogin);
    }

    // 비밀번호 토글 버튼 이벤트
    if (nodes.togglePw) {
        nodes.togglePw.addEventListener("click", togglePasswordVisibility);
    }

    // 비밀번호 입력란에서 엔터키 이벤트
    if (nodes.userPw) {
        nodes.userPw.addEventListener("keypress", (e) => {
            if (e.key === "Enter") handleLogin();
        });
    }

    // 회원가입 성공 파라미터 체크
    checkRegistrationSuccess();
};

// DOM 로드 완료 후 실행
document.addEventListener("DOMContentLoaded", init);