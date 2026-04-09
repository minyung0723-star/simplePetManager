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
    // ★ 중요: HTML의 비밀번호 찾기 버튼 ID와 일치시켜야 합니다.
    btnPw: document.getElementById("btnProcessFindPw"),
    btnResPw: document.getElementById("btnGoToFindPw"),
    btnResLogin: document.getElementById("btnGoToLogin")
};

/**
 * 3. 기능 로직 (함수들)
 */

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

// 이메일 합치기 헬퍼 (비밀번호 찾기용)
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

// 타이머 함수 (register.js와 동일한 UX)
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
            nodes.pwEmailCode.value = "";
            alert("인증 시간이 만료되었습니다. 다시 요청해 주세요.");
        }
    }, 1000);
};

// 인증번호 발송 요청
const requestPwEmailAuth = async () => {
    const email = getPwFullEmail();
    const userId = nodes.pwUserId.value.trim();

    if (!userId) return alert("아이디를 먼저 입력해 주세요.");
    if (!email) return alert("이메일 주소를 완성해 주세요.");

    try {
        const res = await fetch(state.contextPath + "/api/email-auth", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ userEmail: email, mode: "findPw" }) // mode 전달로 중복체크 우회
        });

        if (res.ok) {
            alert("인증번호가 발송되었습니다. 5분 이내에 입력해주세요.");
            startPwEmailTimer(300);
        } else {
            const data = await res.json();
            alert(data.message || "인증번호 발송에 실패했습니다.");
        }
    } catch (e) { console.error(e); }
};

// 인증번호 검증 및 찾기 버튼 활성화
const verifyPwEmailCode = async () => {
    const email = getPwFullEmail();
    const code = nodes.pwEmailCode.value.trim();
    if (!code) return alert("인증번호를 입력해주세요.");

    try {
        const res = await fetch(state.contextPath + "/api/email-verify", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ userEmail: email, emailCode: code })
        });

        if (nodes.pwEmailStatusMsg) nodes.pwEmailStatusMsg.classList.remove("d-none");

        if (res.ok) {
            state.isPwEmailVerified = true;
            nodes.pwEmailStatusMsg.textContent = "이메일 인증이 완료되었습니다.";
            nodes.pwEmailStatusMsg.className = "small text-success mt-1 mb-2 text-start";

            // 필드 잠금
            nodes.pwUserId.readOnly = true;
            nodes.pwPrefix.readOnly = true;
            nodes.pwDomain.disabled = true;
            nodes.pwDirect.readOnly = true;
            nodes.pwEmailCode.readOnly = true;

            // ★ 비밀번호 찾기 버튼 활성화 ★
            if (nodes.btnPw) nodes.btnPw.disabled = false;

            if (state.pwEmailTimer) clearInterval(state.pwEmailTimer);
            nodes.pwTimerSpan.style.display = "none";
        } else {
            state.isPwEmailVerified = false;
            nodes.pwEmailStatusMsg.textContent = "인증번호가 틀렸거나 만료되었습니다.";
            nodes.pwEmailStatusMsg.className = "small text-danger mt-1 mb-2 text-start";
        }
    } catch (e) { console.error("인증 확인 에러:", e); }
};

// 최종 비밀번호 찾기(검증) 처리
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
            // ★ 여기서 보낸 userId가 나중에 세션에 저장되어야 합니다.
            body: JSON.stringify({ userId: userId, userEmail: email }),
        });

        if (res.ok) {
            // 이제 서버 세션에 verifiedUserId가 저장되었으므로 인터셉터가 통과시켜줍니다.
            location.href = state.contextPath + "/passwordEdit?userId=" + encodeURIComponent(userId);
        } else {
            const errorData = await res.json();
            alert(errorData.message || "정보가 일치하지 않습니다.");
        }
    } catch (e) { console.error(e); }
};

/**
 * 4. 이벤트 바인딩 (init)
 */
const init = () => {
    // 공통 및 이동
    if (nodes.logoBtn) nodes.logoBtn.addEventListener("click", () => location.href = state.contextPath + "/");
    if (nodes.btnResLogin) nodes.btnResLogin.addEventListener("click", () => location.href = state.contextPath + "/login");

    // 탭 및 모드 전환
    if (nodes.tabId) nodes.tabId.addEventListener("click", () => switchTab('id'));
    if (nodes.tabPw) nodes.tabPw.addEventListener("click", () => switchTab('pw'));
    if (nodes.btnResPw) nodes.btnResPw.addEventListener("click", () => switchTab('pw'));

    // 도메인 변경
    if (nodes.idDomain) nodes.idDomain.addEventListener("change", (e) => handleDomainChange(e, nodes.idDirect));
    if (nodes.pwDomain) nodes.pwDomain.addEventListener("change", (e) => handleDomainChange(e, nodes.pwDirect));

    // 실행 버튼
    if (nodes.btnId) nodes.btnId.addEventListener("click", processFindId);
    if (nodes.btnPw) nodes.btnPw.addEventListener("click", processFindPw);

    // 인증 관련
    if (nodes.btnPwRequestAuth) nodes.btnPwRequestAuth.addEventListener("click", requestPwEmailAuth);
    if (nodes.btnPwVerifyCode) nodes.btnPwVerifyCode.addEventListener("click", verifyPwEmailCode);

    // 입력 제한 (숫자만)
    if (nodes.pwEmailCode) {
        nodes.pwEmailCode.addEventListener("input", (e) => {
            e.target.value = e.target.value.replace(/[^0-9]/g, "");
        });
    }

    // URL 모드 초기화
    const urlParams = new URLSearchParams(window.location.search);
    switchTab(urlParams.get('mode') === 'pw' ? 'pw' : 'id');
};

document.addEventListener("DOMContentLoaded", init);