/**
 * mypage.js
 * 마이페이지 메인 (myPage-origin.jsp) 전용 스크립트
 *
 * 프로필/리뷰 렌더링은 MyPageViewController → JSTL 서버사이드에서 처리
 * 이 파일은 탈퇴 모달 이벤트만 담당
 */

function initWithdrawModal() {
    const modal   = document.getElementById('withdraw-modal');
    const pwInput = document.getElementById('modal-withdraw-pw');

    document.getElementById('btn-withdraw-open').addEventListener('click', () => {
        modal.classList.add('open');
    });

    document.getElementById('btn-modal-cancel').addEventListener('click', () => {
        modal.classList.remove('open');
        pwInput.value = '';
    });

    // 모달 외부 클릭 시 닫기
    modal.addEventListener('click', function (e) {
        if (e.target === this) {
            this.classList.remove('open');
            pwInput.value = '';
        }
    });

    document.getElementById('btn-modal-confirm').addEventListener('click', async () => {
        const pw = pwInput.value;
        if (!pw) { alert('비밀번호를 입력해주세요.'); return; }

        const res  = await fetch('/mypage/withdraw', {
            method: 'DELETE',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ userPassword: pw })
        });
        const data = await res.json();

        if (data.success) {
            alert('탈퇴가 완료되었습니다.');
            location.href = '/';
        } else {
            alert(data.message);
            pwInput.value = '';
        }
    });
}

document.addEventListener('DOMContentLoaded', function () {
    initWithdrawModal();
});