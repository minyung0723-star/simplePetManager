/**
 * mypage-edit.js
 * 회원정보 수정 페이지 (myPageEdit.jsp) 전용 스크립트
 */

/* =====================================================
   유틸 함수
   ===================================================== */

function showMsg(id, msg, type) {
    const el = document.getElementById(id);
    el.textContent = msg;
    el.className = 'msg ' + type;
    setTimeout(() => { el.className = 'msg'; }, 4000);
}

function showGlobal(msg, type) {
    const el = document.getElementById('global-msg');
    el.textContent = msg;
    el.className = 'global-msg ' + type;
    setTimeout(() => { el.className = 'global-msg'; }, 4000);
}

/* =====================================================
   데이터 로드 (내 정보 불러오기)
   ===================================================== */

async function loadInfo() {
    const res  = await fetch('/mypage/info');
    const data = await res.json();

    if (!data.success) {
        location.href = '/user/login';
        return;
    }

    document.getElementById('user-name').value  = data.userName  || '';
    document.getElementById('user-email').value = data.userEmail || '';
    document.getElementById('profile-initial').textContent = (data.userName || '?').charAt(0);

    if (data.imageUrl) {
        document.getElementById('profile-avatar').innerHTML =
            `<img src="${data.imageUrl}" alt="프로필">`;
    }
}

/* =====================================================
   프로필 사진 변경
   ===================================================== */

function initProfileImageUpload() {
    document.getElementById('profile-img-input').addEventListener('change', async function () {
        if (!this.files[0]) return;

        // 미리보기
        const reader = new FileReader();
        reader.onload = e => {
            document.getElementById('profile-avatar').innerHTML =
                `<img src="${e.target.result}" alt="프로필">`;
        };
        reader.readAsDataURL(this.files[0]);

        // 업로드
        const fd = new FormData();
        fd.append('file', this.files[0]);

        const res  = await fetch('/mypage/profile-image', { method: 'POST', body: fd });
        const data = await res.json();
        showMsg('msg-img', data.message, data.success ? 'success' : 'error');
    });
}

/* =====================================================
   저장 처리 (기본 정보 + 비밀번호 변경)
   ===================================================== */

function initSaveButton() {
    document.getElementById('btn-save').addEventListener('click', async () => {
        const userName  = document.getElementById('user-name').value.trim();
        const userEmail = document.getElementById('user-email').value.trim();
        const currentPw = document.getElementById('current-pw').value;
        const newPw     = document.getElementById('new-pw').value;
        const confirmPw = document.getElementById('new-pw-confirm').value;

        if (!userName || !userEmail) {
            return showGlobal('이름과 이메일을 입력해주세요.', 'error');
        }

        // 기본 정보 수정
        const infoRes  = await fetch('/mypage/update', {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ userName, userEmail })
        });
        const infoData = await infoRes.json();
        if (!infoData.success) return showGlobal(infoData.message, 'error');

        // 비밀번호 변경 (입력한 경우만)
        if (newPw || confirmPw || currentPw) {
            if (!currentPw) return showGlobal('현재 비밀번호를 입력해주세요.', 'error');
            if (newPw.length < 8) return showMsg('msg-pw', '새 비밀번호는 8자 이상이어야 합니다.', 'error');
            if (newPw !== confirmPw) return showMsg('msg-pw', '새 비밀번호가 일치하지 않습니다.', 'error');

            const pwRes  = await fetch('/mypage/password', {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ currentPassword: currentPw, newPassword: newPw })
            });
            const pwData = await pwRes.json();
            if (!pwData.success) return showMsg('msg-pw', pwData.message, 'error');

            // 성공 시 비밀번호 필드 초기화
            document.getElementById('current-pw').value     = '';
            document.getElementById('new-pw').value         = '';
            document.getElementById('new-pw-confirm').value = '';
        }

        showGlobal('저장되었습니다.', 'success');
    });
}

/* =====================================================
   취소 버튼
   ===================================================== */

function initCancelButton() {
    document.getElementById('btn-cancel').addEventListener('click', () => {
        location.href = '/mypage/myPage';
    });
}

/* =====================================================
   초기 실행
   ===================================================== */

document.addEventListener('DOMContentLoaded', function () {
    loadInfo();
    initProfileImageUpload();
    initSaveButton();
    initCancelButton();
});