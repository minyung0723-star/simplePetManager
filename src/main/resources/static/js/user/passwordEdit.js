/**
 * 1. 상태 및 상수 관리
 */
const state = {
    contextPath: window.contextPath || "",
    userId: ""
};

/**
 * 2. DOM 요소 참조
 */
const nodes = {
    targetUserId: document.getElementById("targetUserId"),
    newPassword: document.getElementById("newPassword"),
    confirmPassword: document.getElementById("confirmPassword"),
    pwMsg: document.getElementById("pwMatchMsg"),
    submitBtn: document.getElementById("submitBtn"),
    logoBtn: document.getElementById("logoBtn")
};

/**
 * 3. 기능 로직 (함수들)
 */

// URL 파라미터에서 userId 추출 및 초기화
const initPage = () => {
    const urlParams = new URLSearchParams(window.location.search);
    state.userId = urlParams.get('userId');

    // userId가 없으면 비정상적인 접근으로 간주
    if (!state.userId) {
        alert("잘못된 접근입니다. 아이디 찾기/비밀번호 찾기부터 진행해 주세요.");
        location.href = state.contextPath + "/login";
        return;
    }

    if (nodes.targetUserId) {
        nodes.targetUserId.value = state.userId;
    }
};

// 실시간 비밀번호 일치 검증
// passwordEdit.js 내의 validatePassword 함수 수정
const validatePassword = () => {
    const pw = nodes.newPassword.value;
    const confirm = nodes.confirmPassword.value;
    const pwPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$])[A-Za-z\d!@#$]{8,}$/;

    if (pw === "" && confirm === "") {
        nodes.pwMsg.textContent = "";
        nodes.submitBtn.disabled = true;
        return;
    }

    // 패턴 검증
    const isPatternValid = pwPattern.test(pw);
    const isMatch = (pw === confirm && pw.length > 0);

    if (!isPatternValid) {
        nodes.pwMsg.textContent = "8자 이상, 영문 대/소문자, 숫자, 특수문자(!@#$) 필수 포함";
        nodes.pwMsg.className = "pw-edit-msg text-start text-danger";
        nodes.submitBtn.disabled = true;
    } else if (isMatch) {
        nodes.pwMsg.textContent = "비밀번호가 일치하며 사용 가능합니다.";
        nodes.pwMsg.className = "pw-edit-msg text-start text-success";
        nodes.submitBtn.disabled = false;
    } else {
        nodes.pwMsg.textContent = "비밀번호가 일치하지 않습니다.";
        nodes.pwMsg.className = "pw-edit-msg text-start text-danger";
        nodes.submitBtn.disabled = true;
    }
};

// 서버에 비밀번호 변경 요청 전송
const updatePassword = async () => {
    const userPassword = nodes.newPassword.value.trim();

    if (!userPassword) {
        alert("새로운 비밀번호를 입력해주세요.");
        return;
    }

    try {
        const res = await fetch(state.contextPath + "/api/update-password", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
                userId: state.userId,
                userPassword: userPassword
            }),
        });

        if (res.ok) {
            alert("비밀번호가 성공적으로 변경되었습니다.\n새로운 비밀번호로 로그인해 주세요.");
            location.href = state.contextPath + "/login";
        } else {
            const data = await res.json();
            alert(data.message || "비밀번호 변경 중 오류가 발생했습니다.");
        }
    } catch (error) {
        console.error("비밀번호 변경 에러:", error);
        alert("서버와 통신하는 중 오류가 발생했습니다.");
    }
};

/**
 * 4. 이벤트 리스너 등록
 */
const bindEvents = () => {
    if (nodes.logoBtn) {
        nodes.logoBtn.addEventListener("click", () => {
            location.href = state.contextPath + "/";
        });
    }

    if (nodes.newPassword) nodes.newPassword.addEventListener("input", validatePassword);
    if (nodes.confirmPassword) nodes.confirmPassword.addEventListener("input", validatePassword);

    if (nodes.submitBtn) {
        nodes.submitBtn.addEventListener("click", updatePassword);
    }
};

// 문서 로드 완료 시 실행
document.addEventListener("DOMContentLoaded", () => {
    initPage();
    bindEvents();
});