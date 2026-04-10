/**
 * passwordEdit.js
 */
const state = {
    contextPath: window.contextPath || "",
    userId: ""
};

let nodes = {};

// [신규] 세션 권한 삭제 함수 (메인 이동 전 실행)
const clearAuthAndMove = async (targetPath = "/") => {
    try {
        // 서버에 세션 삭제 요청 (결과와 상관없이 이동)
        await fetch(`${state.contextPath}/api/clear-password-auth`, {
            method: "POST"
        });
    } catch (err) {
        console.error("세션 삭제 오류:", err);
    } finally {
        location.href = state.contextPath + targetPath;
    }
};

// 1. 페이지 초기화 및 유효성 체크 (유지)
const initPage = () => {
    const urlParams = new URLSearchParams(window.location.search);
    state.userId = urlParams.get('userId');

    if (!state.userId || state.userId === "null" || state.userId === "") {
        alert("잘못된 접근입니다. 아이디 찾기부터 다시 진행해 주세요.");
        location.href = state.contextPath + "/login";
        return false;
    }

    if (nodes.targetUserId) {
        nodes.targetUserId.value = state.userId;
    }
    return true;
};

// 2. 비밀번호 실시간 검증 (유지)
const validatePassword = () => {
    const pw = nodes.newPassword.value;
    const confirm = nodes.confirmPassword.value;
    const pwPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$])[A-Za-z\d!@#$]{8,}$/;

    if (!pw && !confirm) {
        nodes.pwMsg.textContent = "";
        nodes.submitBtn.disabled = true;
        return;
    }

    const isPatternValid = pwPattern.test(pw);
    const isMatch = (pw === confirm && pw.length > 0);

    if (!isPatternValid) {
        nodes.pwMsg.textContent = "8자 이상, 대/소문자, 숫자, 특수문자(!@#$) 필수 포함";
        nodes.pwMsg.style.color = "#dc3545";
        nodes.submitBtn.disabled = true;
    } else if (!isMatch) {
        nodes.pwMsg.textContent = "비밀번호가 일치하지 않습니다.";
        nodes.pwMsg.style.color = "#dc3545";
        nodes.submitBtn.disabled = true;
    } else {
        nodes.pwMsg.textContent = "사용 가능한 비밀번호입니다.";
        nodes.pwMsg.style.color = "#198754";
        nodes.submitBtn.disabled = false;
    }
};

// 3. 눈 아이콘 토글 (유지)
const togglePasswordVisibility = (e) => {
    if (e) e.preventDefault();
    const isPassword = nodes.newPassword.type === "password";
    const type = isPassword ? "text" : "password";

    nodes.newPassword.type = type;
    nodes.confirmPassword.type = type;
    nodes.toggleBtn.textContent = isPassword ? "🙈" : "👁️";
};

// 4. 이벤트 바인딩 (수정됨)
const bindEvents = () => {
    if (nodes.toggleBtn) nodes.toggleBtn.onclick = togglePasswordVisibility;
    if (nodes.newPassword) nodes.newPassword.oninput = validatePassword;
    if (nodes.confirmPassword) nodes.confirmPassword.oninput = validatePassword;

    // [수정] 로고 버튼 클릭 시 세션 삭제 후 이동
    if (nodes.logoBtn) {
        nodes.logoBtn.onclick = (e) => {
            e.preventDefault();
            clearAuthAndMove("/");
        };
    }

    if (nodes.submitBtn) {
        nodes.submitBtn.onclick = async () => {
            try {
                const res = await fetch(`${state.contextPath}/api/update-password`, {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify({
                        userId: state.userId,
                        userPassword: nodes.newPassword.value.trim()
                    }),
                });

                if (res.ok) {
                    alert("비밀번호가 성공적으로 변경되었습니다.");
                    location.href = state.contextPath + "/login";
                } else {
                    const data = await res.json();
                    alert(data.message || "변경에 실패했습니다.");
                }
            } catch (err) {
                alert("서버 연결 오류");
            }
        };
    }
};

// 5. 실행 (유지)
document.addEventListener("DOMContentLoaded", () => {
    nodes = {
        targetUserId: document.getElementById("targetUserId"),
        newPassword: document.getElementById("newPassword"),
        confirmPassword: document.getElementById("confirmPassword"),
        pwMsg: document.getElementById("pwMatchMsg"),
        submitBtn: document.getElementById("submitBtn"),
        logoBtn: document.getElementById("logoBtn"),
        toggleBtn: document.getElementById("togglePw")
    };

    if (initPage()) {
        bindEvents();
    }
});