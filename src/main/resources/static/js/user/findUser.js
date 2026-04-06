/**
 * 1. 상태 및 공통 관리
 */
const state = {
    contextPath: window.contextPath || ""
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
    // Buttons
    logoBtn: document.getElementById("logoBtn"),
    btnId: document.getElementById("btnProcessFindId"),
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

// 비밀번호 찾기(검증) 처리
const processFindPw = async () => {
    const domain = (nodes.pwDomain.value === "") ? nodes.pwDirect.value.trim() : nodes.pwDomain.value;
    const email = nodes.pwPrefix.value.trim() + "@" + domain;
    const userId = nodes.pwUserId.value.trim();

    if (!userId || !nodes.pwPrefix.value.trim() || !domain) {
        return alert("모든 정보를 입력해주세요.");
    }

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
            alert(errorData.message || "정보가 일치하지 않습니다.");
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

    // URL 모드 초기화
    const urlParams = new URLSearchParams(window.location.search);
    switchTab(urlParams.get('mode') === 'pw' ? 'pw' : 'id');
};

document.addEventListener("DOMContentLoaded", init);