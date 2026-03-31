<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>아이디/비밀번호 찾기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header_design.css">

    <style>
        body { background-color: #f5f6f8; }
        .find-nav-tabs { display: flex; border-bottom: 2px solid #eee; margin-bottom: 25px; }
        .find-nav-link {
            flex: 1; text-align: center; padding: 15px; cursor: pointer;
            color: #888; font-weight: bold; transition: 0.3s;
        }
        .find-nav-link.active { color: #3b6ef5; border-bottom: 2px solid #3b6ef5; }
        .email-group { display: flex; gap: 5px; align-items: center; }
        .found-id-box {
            background: #f8f9fa; border: 1px solid #e9ecef; border-radius: 12px;
            padding: 25px; font-size: 20px; font-weight: bold; margin: 20px 0;
            display: flex; align-items: center; justify-content: center; gap: 12px;
        }
        .user-icon { width: 30px; height: 30px; opacity: 0.4; }
    </style>
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

            <div class="email-group mb-2">
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
            <input type="text" id="idDirect" class="form-control user-login-input d-none" placeholder="도메인 직접 입력 (ex: nate.com)">

            <button class="user-login-btn mt-3" onclick="processFindId()">아이디 찾기</button>
        </div>

        <div id="sectionFindPw" class="d-none">
            <h5 class="text-start mb-1" style="font-weight: bold;">아이디 입력</h5>
            <p class="text-start text-muted small mb-3">비밀번호를 찾고자 하는 아이디를 입력해 주세요.</p>

            <input type="text" id="pwUserId" class="form-control user-login-input" placeholder="아이디">

            <div class="email-group mb-2">
                <input type="text" id="pwEmailPrefix" class="form-control user-login-input" placeholder="가입메일주소" style="flex: 2;">
                <span class="mb-2">@</span>
                <select id="pwEmailDomain" class="form-select user-login-input" style="flex: 2;" onchange="toggleDirectInput(this, 'pwDirect')">
                    <option value="naver.com">naver.com</option>
                    <option value="gmail.com">gmail.com</option>
                    <option value="hanmail.net">hanmail.net</option>
                    <option value="">직접입력</option>
                </select>
            </div>
            <input type="text" id="pwDirect" class="form-control user-login-input d-none" placeholder="도메인 직접 입력">

            <button class="user-login-btn mt-3" onclick="processFindPw()">비밀번호 찾기</button>
        </div>

        <div id="sectionIdResult" class="d-none text-start">
            <h3 style="font-weight: bold;">아이디를 찾았어요</h3>
            <p class="text-muted">비밀번호를 잊으셨다면 '비밀번호 찾기'를 눌러 주세요.</p>

            <div class="found-id-box">
                <img src="${pageContext.request.contextPath}/images/user.png" class="user-icon" alt="user">
                <span id="displayUserId"></span>
            </div>

            <div class="d-flex gap-2">
                <button class="btn btn-outline-secondary w-100" style="height: 50px; border-radius: 8px;" onclick="switchTab('pw')">비밀번호 찾기</button>
                <button class="user-login-btn w-100" onclick="location.href='${pageContext.request.contextPath}/user/login'">로그인하기</button>
            </div>
        </div>

        <div class="user-login-links mt-4">
            <a href="${pageContext.request.contextPath}/user/login">로그인으로 돌아가기</a> |
            <a href="${pageContext.request.contextPath}/user/register">회원가입</a>
        </div>
    </div>
</div>

<script>
    window.onload = function() {
        const urlParams = new URLSearchParams(window.location.search);
        const mode = urlParams.get('mode');
        if (mode === 'pw') switchTab('pw');
        else switchTab('id');
    };

    function switchTab(type) {
        const isId = (type === 'id');
        document.getElementById('tabFindId').classList.toggle('active', isId);
        document.getElementById('tabFindPw').classList.toggle('active', !isId);
        document.getElementById('sectionFindId').classList.toggle('d-none', !isId);
        document.getElementById('sectionFindPw').classList.toggle('d-none', isId);
        document.getElementById('sectionIdResult').classList.add('d-none');
    }

    function toggleDirectInput(select, inputId) {
        const directInput = document.getElementById(inputId);
        if (select.value === "") {
            directInput.classList.remove('d-none');
            directInput.focus();
        } else {
            directInput.classList.add('d-none');
            directInput.value = ""; // 직접 입력값 초기화
        }
    }

    // 아이디 찾기 로직
    async function processFindId() {
        const name = document.getElementById("idName").value.trim();
        const prefix = document.getElementById("idEmailPrefix").value.trim();
        const domainSelect = document.getElementById("idEmailDomain").value;
        const domainDirect = document.getElementById("idDirect").value.trim();

        // 도메인 결정 로직 수정
        const domain = (domainSelect === "") ? domainDirect : domainSelect;
        const email = prefix + "@" + domain;

        console.log("아이디 찾기 요청 데이터:", { userName: name, userEmail: email });

        if (!name || !prefix || !domain) {
            alert("모든 정보를 입력해주세요.");
            return;
        }

        try {
            const res = await fetch("${pageContext.request.contextPath}/user/find-id", {
                method: "POST",
                headers: {"Content-Type": "application/json"},
                body: JSON.stringify({ userName: name, userEmail: email }),
            });

            if (res.ok) {
                const data = await res.json();
                document.getElementById("sectionFindId").classList.add("d-none");
                document.getElementById("sectionIdResult").classList.remove("d-none");
                document.getElementById("displayUserId").textContent = data.userId;
            } else {
                const errorData = await res.json();
                alert(errorData.message || "일치하는 정보가 없습니다.");
            }
        } catch (error) {
            console.error("Fetch Error:", error);
            alert("서버 통신 중 오류가 발생했습니다.");
        }
    }

    // 비밀번호 찾기 로직
    async function processFindPw() {
        const userId = document.getElementById("pwUserId").value.trim();
        const prefix = document.getElementById("pwEmailPrefix").value.trim();
        const domainSelect = document.getElementById("pwEmailDomain").value;
        const domainDirect = document.getElementById("pwDirect").value.trim();

        const domain = (domainSelect === "") ? domainDirect : domainSelect;
        const email = prefix + "@" + domain;

        console.log("비번 검증 요청 데이터:", { userId: userId, userEmail: email });

        if (!userId || !prefix || !domain) {
            alert("모든 정보를 입력해주세요.");
            return;
        }

        try {
            const res = await fetch("${pageContext.request.contextPath}/user/verify-for-pw", {
                method: "POST",
                headers: {"Content-Type": "application/json"},
                body: JSON.stringify({ userId: userId, userEmail: email }),
            });

            if (res.ok) {
                // 검증 성공 시 userId를 쿼리 스트링으로 전달하여 수정 페이지 이동
                location.href = "${pageContext.request.contextPath}/user/passwordEdit?userId=" + encodeURIComponent(userId);
            } else {
                const errorData = await res.json();
                alert(errorData.message || "아이디 또는 이메일 정보가 일치하지 않습니다.");
            }
        } catch (error) {
            console.error("Fetch Error:", error);
            alert("서버 통신 중 오류가 발생했습니다.");
        }
    }
</script>

</body>
</html>