// =====================================================
//  app-common.js  |  전체 페이지 공통 유틸
//  - 로그인 상태 확인 (/mypage/info 래퍼)
//  - review-common.js 의 generateStars 는 리뷰 전용이므로 그쪽에 유지
// =====================================================

/**
 * 현재 로그인 상태와 유저 정보를 반환합니다.
 * 모든 페이지에서 /mypage/info 를 직접 fetch 하는 중복 코드를 대체합니다.
 *
 * @returns {Promise<{success: boolean, userName?: string, userEmail?: string,
 *                    userNumber?: number, imageUrl?: string}>}
 *
 * 사용 예)
 *   const info = await fetchMyInfo();
 *   if (!info.success) { location.href = '/login'; return; }
 *   console.log(info.userName);
 */
const fetchMyInfo = async () => {
    try {
        const res  = await fetch('/mypage/info');
        return await res.json();
    } catch (e) {
        console.error('fetchMyInfo 오류:', e);
        return { success: false };
    }
};

/**
 * 로그인 여부만 확인합니다. (userNumber 등 세부 정보 불필요할 때)
 * @returns {Promise<boolean>}
 */
const isLoggedIn = async () => {
    const info = await fetchMyInfo();
    return info.success === true;
};
