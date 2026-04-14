/**
 * mypage.js
 * 마이페이지 메인 전용 스크립트
 */

function initWithdrawModal() {
    const modal   = document.getElementById('withdraw-modal');
    const pwInput = document.getElementById('modal-withdraw-pw');

    if (document.getElementById('btn-withdraw-open')) {
        document.getElementById('btn-withdraw-open').addEventListener('click', () => {
            modal.classList.add('open');
        });
    }

    if (document.getElementById('btn-modal-cancel')) {
        document.getElementById('btn-modal-cancel').addEventListener('click', () => {
            modal.classList.remove('open');
            pwInput.value = '';
        });
    }

    modal.addEventListener('click', function (e) {
        if (e.target === this) {
            this.classList.remove('open');
            pwInput.value = '';
        }
    });

    if (document.getElementById('btn-modal-confirm')) {
        document.getElementById('btn-modal-confirm').addEventListener('click', async () => {
            const pw = pwInput.value;
            if (!pw) { alert('비밀번호를 입력해주세요.'); return; }

            const res  = await fetch(window.contextPath + '/mypage/withdraw', {
                method: 'DELETE',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ userPassword: pw })
            });
            const data = await res.json();

            if (data.success) {
                alert('탈퇴가 완료되었습니다.');
                localStorage.removeItem("isLoggedIn");
                localStorage.removeItem("userName");
                location.href = window.contextPath + '/';
            } else {
                alert(data.message);
                pwInput.value = '';
            }
        });
    }
}

/**
 * 리뷰 삭제 함수
 * window 객체에 등록하여 JSP의 inline onclick에서 호출 가능하게 함
 */
window.deleteMyReview = function(reviewId) {
    if (!confirm("정말 이 리뷰를 삭제하시겠습니까?")) return;

    // [수정] 컨트롤러의 @RequestMapping("/api/review") + @PostMapping("/delete") 조합에 맞춰 경로 수정
    const url = window.contextPath + "/api/review/delete?reviewId=" + reviewId;

    fetch(url, {
        method: 'POST'
    })
        .then(response => response.text())
        .then(data => {
            if (data === "success") {
                alert("리뷰가 성공적으로 삭제되었습니다.");
                location.reload();
            } else if (data === "unauthorized") {
                alert("로그인이 필요합니다.");
            } else if (data === "forbidden") {
                alert("본인이 작성한 리뷰만 삭제할 수 있습니다.");
            } else {
                alert("삭제 실패: " + data);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert("서버와 통신 중 오류가 발생했습니다.");
        });
};

document.addEventListener('DOMContentLoaded', function () {
    initWithdrawModal();
});