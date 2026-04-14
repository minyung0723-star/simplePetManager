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

    /** 리뷰 상세 조회 (삭제 전 본인 확인용) */
    public Review getReviewById(int reviewId) {
        return reviewMapper.getReviewById(reviewId);
    }

    /** * 리뷰 삭제
     * loginUserNumber: 현재 로그인한 사용자의 고유 번호
     */
    public String removeReview(int reviewId, int loginUserNumber) {
        // 1. DB에서 삭제할 리뷰를 미리 가져옵니다.
        Review review = reviewMapper.getReviewById(reviewId);

        // 2. 검증: 리뷰가 존재하고, 리뷰 작성자 번호와 로그인한 유저 번호가 같을 때만 삭제
        if (review != null && review.getUserNumber() == loginUserNumber) {
            int result = reviewMapper.deleteReview(reviewId);
            return (result > 0) ? "success" : "fail";
        }

        // 3. 본인이 아니거나 리뷰가 없는 경우
        return "unauthorized";
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