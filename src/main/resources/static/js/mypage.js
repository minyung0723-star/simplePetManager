/**
 * mypage.js – 마이페이지 메인 전용 스크립트
 */

/* ── 리뷰 상세 모달 ── */
function initReviewDetailModal() {
    const overlay  = document.getElementById('review-detail-modal');
    const closeBtn = document.getElementById('btn-rdm-close');
    if (!overlay) return;

    closeBtn.addEventListener('click', () => overlay.classList.remove('open'));
    overlay.addEventListener('click', (e) => {
        if (e.target === overlay) overlay.classList.remove('open');
    });
}

window.openReviewDetail = function(el) {
    const overlay = document.getElementById('review-detail-modal');
    if (!overlay) return;

    const rating = parseInt(el.dataset.rating) || 0;

    document.getElementById('rdm-shop').textContent    = el.dataset.shop    || '';
    document.getElementById('rdm-stars').textContent   = '★'.repeat(rating) + '☆'.repeat(5 - rating);
    document.getElementById('rdm-date').textContent    = el.dataset.date    || '';
    document.getElementById('rdm-content').textContent = el.dataset.content || '';

    overlay.classList.add('open');
};

/* ── 탈퇴 모달 ── */
function initWithdrawModal() {
    const modal   = document.getElementById('withdraw-modal');
    const pwInput = document.getElementById('modal-withdraw-pw');
    if (!modal || !pwInput) return;

    const openBtn    = document.getElementById('btn-withdraw-open');
    const cancelBtn  = document.getElementById('btn-modal-cancel');
    const confirmBtn = document.getElementById('btn-modal-confirm');

    if (openBtn)   openBtn.addEventListener('click',  () => modal.classList.add('open'));
    if (cancelBtn) cancelBtn.addEventListener('click', () => { modal.classList.remove('open'); pwInput.value = ''; });

    modal.addEventListener('click', function(e) {
        if (e.target === this) { this.classList.remove('open'); pwInput.value = ''; }
    });

    if (confirmBtn) {
        confirmBtn.addEventListener('click', async () => {
            const pw = pwInput.value;
            if (!pw) { alert('비밀번호를 입력해주세요.'); return; }

            const res  = await fetch((window.contextPath || '') + '/mypage/withdraw', {
                method: 'DELETE',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ userPassword: pw })
            });
            const data = await res.json();

            if (data.success) {
                alert('탈퇴가 완료되었습니다.');
                // ★ 수정: localStorage 더 이상 사용 안 함 (헤더는 /mypage/info로 상태 확인)
                location.href = (window.contextPath || '') + '/';
            } else {
                alert(data.message);
                pwInput.value = '';
            }
        });
    }
}
window.deleteMyReview = async function(reviewId) {
    if (!confirm('정말 이 리뷰를 삭제하시겠습니까?')) return;

    try {
        const res  = await fetch('/api/review/delete?reviewId=' + reviewId, { method: 'DELETE' });
        const data = await res.json();

        if (data.success) {
            alert('리뷰가 삭제되었습니다.');
            location.reload();
        } else {
            alert('삭제 실패: ' + data.message);
        }
    } catch (err) {
        console.error('리뷰 삭제 오류:', err);
        alert('서버와 통신 중 오류가 발생했습니다.');
    }
};

document.addEventListener('DOMContentLoaded', () => {
    initReviewDetailModal();
    initWithdrawModal();
});