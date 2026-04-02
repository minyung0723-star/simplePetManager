<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>아이디/비밀번호 찾기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header_design.css">
</head>
<body>

<div class="user-login-container">
    <img src="${pageContext.request.contextPath}/images/petlogo.png"
         class="user-login-logo"
         onclick="location.href='${pageContext.request.contextPath}/'" style="cursor:pointer;">

    <div class="user-login-card">
        <div class="find-nav-tabs">
            <div id="tabFindId" class="find-nav-link active" onclick="switchTab('id')">아이디 찾기</div>
            <div id="tabFindPw" class="find-nav-link" onclick="switchTab('pw')">비밀번호 찾기</div>
        </div>

        <div id="sectionFindId">
            <h5 class="text-start mb-3" style="font-weight: bold;">회원 아이디 찾기</h5>
            <input type="text" id="idName" class="form-control user-login-input" placeholder="이름">

            <div class="find-email-group mb-2">
                <input type="text" id="idEmailPrefix" class="form-control user-login-input" placeholder="가입메일주소" style="flex: 2;">
                <span class="mb-2">@</span>
                <select id="idEmailDomain" class="form-select user-login-input" style="flex: 2;" onchange="toggleDirectInput(this, 'idDirect')">
                    <option value="naver.com">naver.com</option>
                    <option value="gmail.com">gmail.com</option>
                    <option value="hanmail.net">hanmail.net</option>
                    <option value="daum.net">daum.net</option>
                    <option value="">직접입력</option>
                </select>
            </div>
            <input type="text" id="idDirect" class="form-control user-login-input find-direct-input d-none" placeholder="도메인 직접 입력 (ex: nate.com)">

            <button class="user-login-btn mt-3" onclick="processFindId()">아이디 찾기</button>
        </div>

        <div id="sectionFindPw" class="d-none">
            <h5 class="text-start mb-1" style="font-weight: bold;">아이디 입력</h5>
            <p class="text-start text-muted small mb-3">비밀번호를 찾고자 하는 아이디를 입력해 주세요.</p>

            <input type="text" id="pwUserId" class="form-control user-login-input" placeholder="아이디">

            <div class="find-email-group mb-2">
                <input type="text" id="pwEmailPrefix" class="form-control user-login-input" placeholder="가입메일주소" style="flex: 2;">
                <span class="mb-2">@</span>
                <select id="pwEmailDomain" class="form-select user-login-input" style="flex: 2;" onchange="toggleDirectInput(this, 'pwDirect')">
                    <option value="naver.com">naver.com</option>
                    <option value="gmail.com">gmail.com</option>
                    <option value="hanmail.net">hanmail.net</option>
                    <option value="">직접입력</option>
                </select>
            </div>
            <input type="text" id="pwDirect" class="form-control user-login-input find-direct-input d-none" placeholder="도메인 직접 입력">

            <button class="user-login-btn mt-3" onclick="processFindPw()">비밀번호 찾기</button>
        </div>

        <div id="sectionIdResult" class="d-none text-start">
            <h3 style="font-weight: bold;">아이디를 찾았어요</h3>
            <p class="text-muted">비밀번호를 잊으셨다면 '비밀번호 찾기'를 눌러 주세요.</p>

            <div class="found-result-box">
                <img src="${pageContext.request.contextPath}/images/user.png" class="found-user-icon" alt="user">
                <span id="displayUserId"></span>
            </div>

            <div class="d-flex gap-2">
                <button class="btn btn-outline-secondary w-100" style="height: 50px; border-radius: 8px;" onclick="switchTab('pw')">비밀번호 찾기</button>
                <button class="user-login-btn w-100" onclick="location.href='${pageContext.request.contextPath}/login'">로그인하기</button>
            </div>
        </div>

        <div class="user-login-links mt-4">
            <a href="${pageContext.request.contextPath}/login">로그인으로 돌아가기</a> |
            <a href="${pageContext.request.contextPath}/register">회원가입</a>
        </div>
    </div>
</div>

<script>
    // 1. 탭 전환 함수
    const switchTab = (type) => {
        const isId = (type === 'id');

        document.getElementById('tabFindId').classList.toggle('active', isId);
        document.getElementById('tabFindPw').classList.toggle('active', !isId);
        document.getElementById('sectionFindId').classList.toggle('d-none', !isId);
        document.getElementById('sectionFindPw').classList.toggle('d-none', isId);

        const resultSection = document.getElementById('sectionIdResult');
        if (resultSection) resultSection.classList.add('d-none');
    };

    // 2. 이메일 직접 입력 필드 토글
    const toggleDirectInput = (select, inputId) => {
        const directInput = document.getElementById(inputId);
        if (!directInput) return;

        if (select.value === "") {
            directInput.classList.remove('d-none');
            directInput.focus();
        } else {
            directInput.classList.add('d-none');
            directInput.value = "";
        }
    };

    // 3. 아이디 찾기 로직
    const processFindId = async () => {
        const name = document.getElementById("idName").value.trim();
        const prefix = document.getElementById("idEmailPrefix").value.trim();
        const domainSelect = document.getElementById("idEmailDomain").value;
        const domainDirect = document.getElementById("idDirect").value.trim();

        // 도메인 결정 로직 보완
        const domain = (domainSelect === "") ? domainDirect : domainSelect;
        const email = prefix + "@" + domain;

        // 유효성 검사 강화 (prefix나 domain이 비었을 때 체크)
        if (!name || !prefix || !domain) {
            alert("이름과 이메일 주소를 모두 정확히 입력해주세요.");
            return;
        }

        try {
            // 주소에 /api 추가: /user/find-id -> /user/api/find-id
            const res = await fetch("${pageContext.request.contextPath}/api/find-id", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ userName: name, userEmail: email }),
            });

            if (res.ok) {
                const data = await res.json();
                document.getElementById("sectionFindId").classList.add("d-none");
                document.getElementById("sectionIdResult").classList.remove("d-none");
                document.getElementById("displayUserId").textContent = data.userId;
            } else {
                // 404나 500 에러 시 서버에서 보낸 메시지 출력
                const errorData = await res.json();
                alert(errorData.message || "일치하는 정보가 없습니다.");
            }
        } catch (error) {
            console.error("아이디 찾기 에러:", error);
            alert("서버 통신 중 오류가 발생했습니다.");
        }
    };

    // 4. 비밀번호 찾기(검증) 로직
    const processFindPw = async () => {
        const userId = document.getElementById("pwUserId").value.trim();
        const prefix = document.getElementById("pwEmailPrefix").value.trim();
        const domainSelect = document.getElementById("pwEmailDomain").value;
        const domainDirect = document.getElementById("pwDirect").value.trim();

        const domain = (domainSelect === "") ? domainDirect : domainSelect;
        const email = prefix + "@" + domain;

        if (!userId || !prefix || !domain) {
            alert("아이디와 이메일 주소를 모두 입력해주세요.");
            return;
        }

        try {
            // 주소에 /api 추가: /user/verify-for-pw -> /user/api/verify-for-pw
            const res = await fetch("${pageContext.request.contextPath}/api/verify-for-pw", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ userId: userId, userEmail: email }),
            });

            if (res.ok) {
                // 검증 성공 시 비밀번호 수정 페이지로 이동
                location.href = "${pageContext.request.contextPath}/passwordEdit?userId=" + encodeURIComponent(userId);
            } else {
                const errorData = await res.json();
                alert(errorData.message || "아이디 또는 이메일 정보가 일치하지 않습니다.");
            }
        } catch (error) {
            console.error("비밀번호 찾기 검증 에러:", error);
            alert("서버 통신 중 오류가 발생했습니다.");
        }
    };

    // 5. 페이지 로드 시 초기 실행
    window.onload = () => {
        const urlParams = new URLSearchParams(window.location.search);
        const mode = urlParams.get('mode');
        if (mode === 'pw') switchTab('pw');
        else switchTab('id');
    };
</script>

</body>
</html>