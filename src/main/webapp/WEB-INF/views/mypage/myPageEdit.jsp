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

<script src="${pageContext.request.contextPath}/js/app-common.js"></script>
<script src="${pageContext.request.contextPath}/js/mypage-edit.js"></script>

<%-- 페이지 로드 시 /mypage/info 로 현재 유저 정보를 가져와 폼 초기값 설정 --%>
<script>
    (async () => {
        try {
            const data = await fetchMyInfo();
            if (!data.success) return;

            // 이름 / 이메일 필드 채우기
            const nameEl  = document.getElementById('user-name');
            const emailEl = document.getElementById('user-email');
            if (nameEl)  nameEl.value  = data.userName  || '';
            if (emailEl) emailEl.value = data.userEmail || '';

            // 프로필 아바타: 이미지 있으면 img, 없으면 이니셜
            const avatarEl  = document.getElementById('profile-avatar');
            const initialEl = document.getElementById('profile-initial');
            if (data.imageUrl) {
                const img = document.createElement('img');
                img.src = data.imageUrl;
                img.alt = '프로필 사진';
                img.style.cssText = 'width:100%;height:100%;object-fit:cover;border-radius:50%;';
                avatarEl.replaceChildren(img);
            } else {
                if (initialEl) initialEl.textContent = (data.userName || '?').charAt(0);
            }
        } catch (e) {
            console.warn('프로필 로드 실패:', e.message);
        }
    })();
</script>

</body>
</html>