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
@Transactional
public class ReviewService {

    private final ReviewMapper reviewMapper;

    // ===================== 리뷰 목록 =====================

    /** 특정 병원의 리뷰 목록 조회 */
    public List<Review> getReviewList(int storeId) {
        return reviewMapper.getReviewList(storeId);
    }

    /**
     * 마이페이지 - 내가 작성한 리뷰 목록 조회
     * MyPageViewController 에서 호출
     */
    public List<Map<String, Object>> getReviewsByUserNumber(int userNumber) {
        return reviewMapper.getReviewsByUserNumber(userNumber);
    }

    // ===================== 리뷰 등록 =====================

    /** 리뷰 등록 */
    public String registerReview(Review review) {
        if (review.getStoreId() == null || review.getStoreId() == 0) {
            review.setStoreId(1);
        }
        if (review.getUserNumber() == null || review.getUserNumber() == 0) {
            review.setUserNumber(1);
        }
        if (review.getRating() == null) {
            review.setRating(5.0);
        }
        if (review.getCategory() == null) {
            review.setCategory("병원");
        }
        try {
            reviewMapper.registerReview(review);
            return "success";
        } catch (Exception e) {
            e.printStackTrace();
            return "fail";
        }
    }

    // ===================== 리뷰 삭제 =====================

    /** 리뷰 삭제 */
    public String removeReview(int reviewId) {
        int result = reviewMapper.deleteReview(reviewId);
        return (result > 0) ? "success" : "fail";
    }

    // ===================== 북마크 =====================

    /** 북마크 토글 (등록/해제) */
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
    public int checkBookmark(long userNumber, long storeId) {
        return reviewMapper.checkBookmark(userNumber, storeId);
    }

    // ===================== 병원 정보 =====================

    /** 병원(가게) 상세 정보 조회 */
    public Board getStoreDetail(int storeId) {
        return reviewMapper.getStoreDetail(storeId);
    }
}