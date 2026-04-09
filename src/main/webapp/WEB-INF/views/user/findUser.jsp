<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>아이디/비밀번호 찾기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header_design.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/findUser.css">
</head>
<body>

<div class="user-login-container">
    <img src="${pageContext.request.contextPath}/images/petlogo.png"
         class="user-login-logo" id="logoBtn" alt="로고">

    <div class="user-login-card">
        <div class="find-nav-tabs">
            <div id="tabFindId" class="find-nav-link active">아이디 찾기</div>
            <div id="tabFindPw" class="find-nav-link">비밀번호 찾기</div>
        </div>

        <div id="sectionFindId">
            <h5 class="text-start mb-3 fw-bold">회원 아이디 찾기</h5>
            <input type="text" id="idName" class="form-control user-login-input" placeholder="이름">

            <div class="find-email-group mb-2">
                <input type="text" id="idEmailPrefix" class="form-control user-login-input" placeholder="가입메일주소">
                <span class="email-at">@</span>
                <select id="idEmailDomain" class="form-select user-login-input">
                    <option value="naver.com">naver.com</option>
                    <option value="gmail.com">gmail.com</option>
                    <option value="hanmail.net">hanmail.net</option>
                    <option value="daum.net">daum.net</option>
                    <option value="">직접입력</option>
                </select>
            </div>
            <input type="text" id="idDirect" class="form-control user-login-input d-none" placeholder="도메인 직접 입력">
            <button type="button" id="btnProcessFindId" class="user-login-btn mt-3">아이디 찾기</button>
        </div>

        <div id="sectionFindPw" class="d-none">
            <h5 class="text-start mb-1 fw-bold">아이디 입력</h5>
            <p class="text-start text-muted small mb-3">비밀번호를 찾고자 하는 아이디를 입력해 주세요.</p>

            <input type="text" id="pwUserId" class="form-control user-login-input" placeholder="아이디">

            <div class="find-email-group mb-2">
                <input type="text" id="pwEmailPrefix" class="form-control user-login-input" placeholder="가입메일주소">
                <span class="email-at">@</span>
                <select id="pwEmailDomain" class="form-select user-login-input">
                    <option value="naver.com">naver.com</option>
                    <option value="gmail.com">gmail.com</option>
                    <option value="hanmail.net">hanmail.net</option>
                    <option value="daum.net">daum.net</option>
                    <option value="">직접입력</option>
                </select>
                <button type="button" id="btnPwRequestAuth" class="btn btn-outline-secondary btn-auth">인증요청</button>
            </div>
            <input type="text" id="pwDirect" class="form-control user-login-input find-direct-input d-none" placeholder="도메인 직접 입력">

            <div class="auth-group mt-2">
                <div class="position-relative flex-grow-1">
                    <input type="text" id="pwEmailCode" class="form-control user-login-input"
                           placeholder="인증번호 입력" autocomplete="off"
                           inputmode="numeric" maxlength="6">
                    <span id="pwTimerSpan">05:00</span>
                </div>
                <button type="button" id="btnPwVerifyCode" class="btn btn-outline-success btn-auth">확인</button>
            </div>
            <span id="pwEmailStatusMsg" class="small d-none"></span>

            <button type="button" id="btnProcessFindPw" class="user-login-btn mt-3" disabled>비밀번호 찾기</button>
        </div>

        <div id="sectionIdResult" class="d-none text-start">
            <h3 class="mb-2 fw-bold">아이디를 찾았어요</h3>
            <p class="text-muted small mb-4">비밀번호를 잊으셨다면 '비밀번호 찾기'를 눌러 주세요.</p>
            <div class="found-result-box mb-4 p-3 border rounded text-center bg-light">
                <img src="${pageContext.request.contextPath}/images/user.png" class="found-user-icon mb-2" alt="user">
                <div id="displayUserId" class="fw-bold fs-5"></div>
            </div>
            <div class="d-flex gap-2">
                <button type="button" id="btnGoToFindPw" class="btn btn-outline-secondary w-100 btn-half-height">비밀번호 찾기</button>
                <button type="button" id="btnGoToLogin" class="user-login-btn w-100">로그인하기</button>
            </div>
        </div>

        <div class="user-login-links mt-4">
            <a href="${pageContext.request.contextPath}/login">로그인으로 돌아가기</a>
            <span class="find-sep">|</span>
            <a href="${pageContext.request.contextPath}/register">회원가입</a>
        </div>
    </div>
</div>

<script>window.contextPath = "${pageContext.request.contextPath}";</script>
<script src="${pageContext.request.contextPath}/js/user/findUser.js"></script>
</body>
</html>