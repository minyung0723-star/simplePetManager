/**
 * 1. 상태 및 경로 관리
 */
const state = {
    // JSP에서 전달받을 전역 변수를 참조하거나 기본값을 설정합니다.
    contextPath: window.contextPath || ""
};

/**
 * 2. DOM 요소 참조
 */
const nodes = {
    userId: document.getElementById("userId"),
    userPw: document.getElementById("userPassword"),
    alertBox: document.getElementById("loginAlert"),
    logoBtn: document.getElementById("logoBtn"),
    loginBtn: document.getElementById("btnLogin")
};

/**
 * 3. 기능 로직
 */
const checkRegistrationSuccess = () => {
    const params = new URLSearchParams(window.location.search);
    if (params.has('success')) {
        showAlert("회원가입이 완료되었습니다. 로그인해주세요.", "success");
    }
};

const showAlert = (message, type = "danger") => {
    if(!nodes.alertBox) return;
    nodes.alertBox.classList.remove("d-none", "alert-danger", "alert-success");
    nodes.alertBox.classList.add(`alert-${type}`);
    nodes.alertBox.textContent = message;
};

const handleLogin = async () => {
    const userId = nodes.userId.value.trim();
    const userPassword = nodes.userPw.value.trim();

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
            localStorage.setItem("isLoggedIn", "true");
            localStorage.setItem("userName", data.userName);
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
 * 4. 이벤트 바인딩
 */
const init = () => {
    if (nodes.logoBtn) {
        nodes.logoBtn.addEventListener("click", () => {
            location.href = state.contextPath + "/";
        });
    }

    if (nodes.loginBtn) {
        nodes.loginBtn.addEventListener("click", handleLogin);
    }

    if (nodes.userPw) {
        nodes.userPw.addEventListener("keypress", (e) => {
            if (e.key === "Enter") handleLogin();
        });
    }

    checkRegistrationSuccess();
};

// DOM 로드 완료 후 실행
document.addEventListener("DOMContentLoaded", init);