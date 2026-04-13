/**
 * 1. 상태 및 공통 관리
 */
const state = {
    contextPath: window.contextPath || "",
    isPwEmailVerified: false, // 비밀번호 찾기 인증 상태
    pwEmailTimer: null
};

/**
 * 2. DOM 요소 참조
 */
const nodes = {
    // Tabs
    tabId: document.getElementById('tabFindId'),
    tabPw: document.getElementById('tabFindPw'),
    // Sections
    secFindId: document.getElementById('sectionFindId'),
    secFindPw: document.getElementById('sectionFindPw'),
    secResult: document.getElementById('sectionIdResult'),
    // ID Find Inputs
    idName: document.getElementById("idName"),
    idPrefix: document.getElementById("idEmailPrefix"),
    idDomain: document.getElementById("idEmailDomain"),
    idDirect: document.getElementById("idDirect"),
    displayUserId: document.getElementById("displayUserId"),
    // PW Find Inputs
    pwUserId: document.getElementById("pwUserId"),
    pwPrefix: document.getElementById("pwEmailPrefix"),
    pwDomain: document.getElementById("pwEmailDomain"),
    pwDirect: document.getElementById("pwDirect"),
    pwEmailCode: document.getElementById("pwEmailCode"),
    pwTimerSpan: document.getElementById("pwTimerSpan"),
    pwEmailStatusMsg: document.getElementById("pwEmailStatusMsg"),
    // Buttons
    btnPwRequestAuth: document.getElementById("btnPwRequestAuth"),
    btnPwVerifyCode: document.getElementById("btnPwVerifyCode"),
    logoBtn: document.getElementById("logoBtn"),
    btnId: document.getElementById("btnProcessFindId"),
    btnPw: document.getElementById("btnProcessFindPw"),
    btnResPw: document.getElementById("btnGoToFindPw"),
    btnResLogin: document.getElementById("btnGoToLogin")
};

/**
 * 3. 기능 로직 (함수들)
 */

// [통합 초기화] 아이디, 이메일, 인증번호 등 모든 입력을 리셋하고 포커스를 아이디로 이동
const resetPwInputs = () => {
    state.isPwEmailVerified = false;

    // 모든 필드 값 초기화
    nodes.pwUserId.value = "";
    nodes.pwPrefix.value = "";
    nodes.pwDirect.value = "";
    nodes.pwEmailCode.value = "";

    // 잠금 해제
    nodes.pwUserId.readOnly = false;
    nodes.pwPrefix.readOnly = false;
    nodes.pwDomain.disabled = false;
    nodes.pwDirect.readOnly = false;
    nodes.pwEmailCode.readOnly = false;

    // 도메인 직접입력 필드 상태 복구
    if (nodes.pwDomain.value !== "") {
        nodes.pwDirect.classList.add('d-none');
    }

    // 버튼 및 메시지 초기화
    if (nodes.btnPw) nodes.btnPw.disabled = true;
    if (nodes.btnPwRequestAuth) nodes.btnPwRequestAuth.disabled = false;
    if (nodes.pwEmailStatusMsg) {
        nodes.pwEmailStatusMsg.textContent = "";
        nodes.pwEmailStatusMsg.classList.add("d-none");
    }

    if (state.pwEmailTimer) clearInterval(state.pwEmailTimer);
    nodes.pwTimerSpan.style.display = "none";

    // 포커스를 아이디 입력창으로 이동
    nodes.pwUserId.focus();
};

// 탭 전환
const switchTab = (type) => {
    const isId = (type === 'id');
    if (nodes.tabId) nodes.tabId.classList.toggle('active', isId);
    if (nodes.tabPw) nodes.tabPw.classList.toggle('active', !isId);
    if (nodes.secFindId) nodes.secFindId.classList.toggle('d-none', !isId);
    if (nodes.secFindPw) nodes.secFindPw.classList.toggle('d-none', isId);
    if (nodes.secResult) nodes.secResult.classList.add('d-none');
};

// 이메일 직접 입력 필드 토글
const handleDomainChange = (e, directNode) => {
    if (e.target.value === "") {
        directNode.classList.remove('d-none');
        directNode.focus();
    } else {
        directNode.classList.add('d-none');
        directNode.value = "";
    }
};

// 이메일 합치기 헬퍼
const getPwFullEmail = () => {
    const prefix = nodes.pwPrefix.value.trim();
    const domainSelect = nodes.pwDomain.value;
    const domainDirect = nodes.pwDirect.value.trim();
    const finalDomain = (domainSelect === "") ? domainDirect : domainSelect;
    return (prefix && finalDomain) ? `${prefix}@${finalDomain}` : "";
};

// 아이디 찾기 처리
const processFindId = async () => {
    const domain = (nodes.idDomain.value === "") ? nodes.idDirect.value.trim() : nodes.idDomain.value;
    const email = nodes.idPrefix.value.trim() + "@" + domain;
    const name = nodes.idName.value.trim();

    if (!name || !nodes.idPrefix.value.trim() || !domain) {
        return alert("모든 정보를 정확히 입력해주세요.");
    }

    try {
        const res = await fetch(state.contextPath + "/api/find-id", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ userName: name, userEmail: email }),
        });

        if (res.ok) {
            const data = await res.json();
            nodes.secFindId.classList.add("d-none");
            nodes.secResult.classList.remove("d-none");
            nodes.displayUserId.textContent = data.userId;
        } else {
            const errorData = await res.json();
            alert(errorData.message || "일치하는 정보가 없습니다.");
        }
    } catch (e) { console.error(e); }
};

// 타이머 함수
const startPwEmailTimer = (duration) => {
    if (state.pwEmailTimer) clearInterval(state.pwEmailTimer);
    nodes.pwTimerSpan.style.display = "block";
    let timeLeft = duration;

    state.pwEmailTimer = setInterval(() => {
        let min = Math.floor(timeLeft / 60);
        let sec = timeLeft % 60;
        nodes.pwTimerSpan.textContent = `${min < 10 ? '0' + min : min}:${sec < 10 ? '0' + sec : sec}`;

        if (--timeLeft < 0) {
            clearInterval(state.pwEmailTimer);
            nodes.pwTimerSpan.textContent = "만료";
            alert("인증 시간이 만료되었습니다. 다시 요청해 주세요.");
            resetPwInputs();
        }
    }, 1000);
};

// [수정] 인증번호 발송 요청: 정보가 없으면 아이디/이메일 모두 초기화
const requestPwEmailAuth = async () => {
    const email = getPwFullEmail();
    const userId = nodes.pwUserId.value.trim();

    if (!userId) return alert("아이디를 먼저 입력해 주세요.");
    if (!email) return alert("이메일 주소를 완성해 주세요.");

    try {
        const res = await fetch(state.contextPath + "/api/email-auth", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
                userEmail: email,
                userId: userId,
                mode: "findPw"
            })
        });

        if (res.ok) {
            alert("인증번호가 발송되었습니다. 5분 이내에 입력해주세요.");

            // 전송 성공 시 입력창 잠금
            nodes.pwUserId.readOnly = true;
            nodes.pwPrefix.readOnly = true;
            nodes.pwDomain.disabled = true;
            nodes.pwDirect.readOnly = true;

            startPwEmailTimer(300);
        } else {
            // [핵심 변경] DB에 일치하는 정보가 없어 서버가 에러(400 등)를 보낸 경우
            const data = await res.json();
            alert(data.message || "입력하신 아이디 또는 이메일 정보가 일치하지 않습니다.");

            // 모든 입력창 초기화 (아이디 포함)
            resetPwInputs();
        }
    } catch (e) {
        console.error("인증 요청 에러:", e);
        alert("서버 통신 중 오류가 발생했습니다.");
    }
};

// 인증번호 검증
const verifyPwEmailCode = async () => {
    const email = getPwFullEmail();
    const code = nodes.pwEmailCode.value.trim();
    if (!code) return alert("인증번호를 입력해주세요.");

    try {
        const res = await fetch(state.contextPath + "/api/email-verify", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
                userEmail: email,
                emailCode: code,
                userId: nodes.pwUserId.value.trim()
            })
        });

        if (nodes.pwEmailStatusMsg) nodes.pwEmailStatusMsg.classList.remove("d-none");

        if (res.ok) {
            state.isPwEmailVerified = true;
            nodes.pwEmailStatusMsg.textContent = "이메일 인증이 완료되었습니다.";
            nodes.pwEmailStatusMsg.className = "small text-success mt-1 mb-2 text-start";

            nodes.pwEmailCode.readOnly = true;

            if (nodes.btnPw) nodes.btnPw.disabled = false;
            if (state.pwEmailTimer) clearInterval(state.pwEmailTimer);
            nodes.pwTimerSpan.style.display = "none";
        } else {
            alert("인증번호가 틀렸거나 만료되었습니다. 다시 시도해주세요.");
            resetPwInputs();
        }
    } catch (e) { console.error("인증 확인 에러:", e); }
};

// 최종 비밀번호 찾기 처리
const processFindPw = async () => {
    if (!state.isPwEmailVerified) {
        return alert("이메일 인증을 먼저 완료해 주세요.");
    }

    const domain = (nodes.pwDomain.value === "") ? nodes.pwDirect.value.trim() : nodes.pwDomain.value;
    const email = nodes.pwPrefix.value.trim() + "@" + domain;
    const userId = nodes.pwUserId.value.trim();

    try {
        const res = await fetch(state.contextPath + "/api/verify-for-pw", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ userId: userId, userEmail: email }),
        });

        if (res.ok) {
            location.href = state.contextPath + "/passwordEdit?userId=" + encodeURIComponent(userId);
        } else {
            const errorData = await res.json();
            alert(errorData.message || "아이디 또는 이메일 정보가 일치하지 않습니다.");
            resetPwInputs();
        }
    } catch (e) { console.error(e); }
};

/**
 * 4. 이벤트 바인딩 (init)
 */
const init = () => {
    if (nodes.logoBtn) nodes.logoBtn.addEventListener("click", () => location.href = state.contextPath + "/");
    if (nodes.btnResLogin) nodes.btnResLogin.addEventListener("click", () => location.href = state.contextPath + "/login");
    if (nodes.tabId) nodes.tabId.addEventListener("click", () => switchTab('id'));
    if (nodes.tabPw) nodes.tabPw.addEventListener("click", () => switchTab('pw'));
    if (nodes.btnResPw) nodes.btnResPw.addEventListener("click", () => switchTab('pw'));
    if (nodes.idDomain) nodes.idDomain.addEventListener("change", (e) => handleDomainChange(e, nodes.idDirect));
    if (nodes.pwDomain) nodes.pwDomain.addEventListener("change", (e) => handleDomainChange(e, nodes.pwDirect));
    if (nodes.btnId) nodes.btnId.addEventListener("click", processFindId);
    if (nodes.btnPw) nodes.btnPw.addEventListener("click", processFindPw);
    if (nodes.btnPwRequestAuth) nodes.btnPwRequestAuth.addEventListener("click", requestPwEmailAuth);
    if (nodes.btnPwVerifyCode) nodes.btnPwVerifyCode.addEventListener("click", verifyPwEmailCode);

    if (nodes.pwUserId) {
        nodes.pwUserId.addEventListener("input", (e) => {
            const regex = /^[a-zA-Z0-9]*$/;
            if (!regex.test(e.target.value)) {
                e.target.value = e.target.value.replace(/[^a-zA-Z0-9]/g, "");
            }
        });
    }

    if (nodes.pwEmailCode) {
        nodes.pwEmailCode.addEventListener("input", (e) => {
            e.target.value = e.target.value.replace(/[^0-9]/g, "");
        });
    }

    const urlParams = new URLSearchParams(window.location.search);
    switchTab(urlParams.get('mode') === 'pw' ? 'pw' : 'id');
};

document.addEventListener("DOMContentLoaded", init);