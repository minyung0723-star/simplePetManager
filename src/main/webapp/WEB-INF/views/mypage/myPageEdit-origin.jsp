<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원정보 수정 - SimplePetManager</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header_design.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypage-design.css">
</head>
<body>

<%@ include file="../common/header.jsp" %>

<div class="mypage-edit-container">

    <!-- 전역 메시지 -->
    <div id="global-msg" class="global-msg"></div>

    <!-- 프로필 사진 섹션 -->
    <div class="profile-section">
        <div class="profile-avatar" id="profile-avatar"
             onclick="document.getElementById('profile-img-input').click()">
            <span id="profile-initial">?</span>
        </div>
        <label class="profile-img-label"
               onclick="document.getElementById('profile-img-input').click()">
            프로필 사진 변경
        </label>
        <input type="file" id="profile-img-input" class="profile-img-input" accept="image/*">
        <div id="msg-img" class="msg"></div>
    </div>

    <hr class="divider">

    <!-- 기본 정보 -->
    <div class="form-group">
        <label for="user-name">이름</label>
        <input type="text" id="user-name" placeholder="이름을 입력하세요" maxlength="30">
    </div>

    <div class="form-group">
        <label for="user-email">이메일</label>
        <input type="email" id="user-email" placeholder="이메일을 입력하세요" maxlength="100">
    </div>

    <hr class="divider-bottom">

    <!-- 비밀번호 변경 -->
    <div class="form-group">
        <label for="current-pw">현재 비밀번호</label>
        <input type="password" id="current-pw" placeholder="현재 비밀번호 입력" maxlength="100">
    </div>

    <div class="form-group">
        <label for="new-pw">새 비밀번호</label>
        <input type="password" id="new-pw" placeholder="새 비밀번호 (8자 이상)" maxlength="100">
    </div>

    <div class="form-group">
        <label for="new-pw-confirm">새 비밀번호 확인</label>
        <input type="password" id="new-pw-confirm" placeholder="새 비밀번호 재입력" maxlength="100">
        <div id="msg-pw" class="msg"></div>
    </div>

    <!-- 버튼 -->
    <div class="btn-actions">
        <button class="btn-cancel" id="btn-cancel">취소</button>
        <button class="btn-save"   id="btn-save">저장하기</button>
    </div>

</div>

<%@ include file="../common/footer.jsp" %>

<script src="${pageContext.request.contextPath}/js/mypage-edit.js"></script>

</body>
</html>
