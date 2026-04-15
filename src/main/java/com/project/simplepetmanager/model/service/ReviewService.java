package com.project.simplepetmanager.model.service;

import com.project.simplepetmanager.model.dto.Board;
import com.project.simplepetmanager.model.dto.Review;
import com.project.simplepetmanager.model.mapper.ReviewMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class ReviewService {

    private final ReviewMapper reviewMapper;

    // ===================== 리뷰 조회 =====================

    /** 특정 병원의 리뷰 목록 조회 */
    @Transactional(readOnly = true)
    public List<Review> getReviewList(int storeId) {
        return reviewMapper.getReviewList(storeId);
    }

    /** 마이페이지 - 내가 작성한 리뷰 목록 조회 */
    @Transactional(readOnly = true)
    public List<Map<String, Object>> getReviewsByUserNumber(long userNumber) {
        return reviewMapper.getReviewsByUserNumber(userNumber);
    }

    /** 단건 리뷰 조회 */
    @Transactional(readOnly = true)
    public Review getReviewById(int reviewId) {
        return reviewMapper.getReviewById(reviewId);
    }

    // ===================== 리뷰 등록 =====================

    /**
     * 리뷰 등록
     * - storeId, userNumber, rating, category 기본값은 Controller에서 넘어온 값을 그대로 사용
     * - 예외는 Controller 레벨에서 처리하도록 그대로 던짐 (서비스에서 catch·은폐 금지)
     */
    @Transactional
    public void registerReview(Review review) {
        if (review.getCategory() == null || review.getCategory().isBlank()) {
            review.setCategory("일반");
        }
        reviewMapper.registerReview(review);
    }

    // ===================== 리뷰 수정 =====================

    /**
     * 리뷰 수정
     * - review에 reviewId, userNumber, reviewContent, rating, category 필수
     * - WHERE review_id = ? AND user_number = ? 조건으로 본인 확인을 DB 레벨에서 처리
     * @throws IllegalArgumentException 수정 대상이 없거나 본인 리뷰가 아닐 때
     */
    @Transactional
    public void updateReview(Review review) {
        int updated = reviewMapper.updateReview(review);
        if (updated == 0) {
            throw new IllegalArgumentException("수정할 리뷰가 없거나 수정 권한이 없습니다.");
        }
    }

    // ===================== 리뷰 삭제 =====================

    /**
     * 리뷰 삭제
     * - 본인 리뷰인지 Controller에서 확인 후 호출
     * @throws IllegalArgumentException 삭제 대상이 없을 때
     */
    @Transactional
    public void removeReview(int reviewId) {
        int deleted = reviewMapper.deleteReview(reviewId);
        if (deleted == 0) {
            throw new IllegalArgumentException("삭제할 리뷰가 없습니다.");
        }
    }

    // ===================== 북마크 =====================

    /** 북마크 토글 (등록/해제) */
    @Transactional
    public String toggleBookmark(long userNumber, long storeId) {
        int count = reviewMapper.checkBookmark(userNumber, storeId);
        if (count == 0) {
            reviewMapper.insertBookmark(userNumber, storeId);
            return "inserted";
        } else {
            reviewMapper.deleteBookmark(userNumber, storeId);
            return "deleted";
        }
    }

    /** 북마크 상태 확인 */
    @Transactional(readOnly = true)
    public boolean isBookmarked(long userNumber, long storeId) {
        return reviewMapper.checkBookmark(userNumber, storeId) > 0;
    }

    // ===================== 병원 정보 =====================

    /** 병원(가게) 상세 정보 조회 */
    @Transactional(readOnly = true)
    public Board getStoreDetail(int storeId) {
        return reviewMapper.getStoreDetail(storeId);
    }
}