package com.project.simplepetmanager.model.service;

import com.project.simplepetmanager.model.dto.Board;
import com.project.simplepetmanager.model.dto.Review;
import com.project.simplepetmanager.model.mapper.ReviewMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class ReviewService {


    private final ReviewMapper reviewMapper; // 외부에서 함부로 조작 못하게 private으로 선언!

    /**
     * 특정 병원의 리뷰 목록을 가져오는 기능 (public: 컨트롤러가 호출 가능)
     * @param storeId 병원 번호
     * @return 작성자 정보가 포함된 리뷰 리스트
     */
    public List<Review> getReviewList(int storeId) {
        return reviewMapper.getReviewList(storeId);
    }


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

    // 2. [추가] 컨트롤러가 "이거 찜 되어 있어?"라고 물어볼 때 답해줄 메서드!
    public int checkBookmark(long userNumber, long storeId) {
        // 매퍼에게 직접 물어봐서 결과를 리턴해줍니다.
        return reviewMapper.checkBookmark(userNumber, storeId);
    }
    /**
     * 특정 병원(가게)의 상세 정보를 가져오는 서비스
     * @param storeId 병원 아이디
     * @return Board 객체 (병원 이름, 주소 등 포함)
     */
    public Board getStoreDetail(int storeId) {
        // 매퍼에게 DB에서 데이터를 가져오라고 시킵니다.
        return reviewMapper.getStoreDetail(storeId);
    }

    /**
     * 과제 문제 서비스로 옮기기
     */
    public String registerReview (Review review) {
        // 1. 병원 ID (null이거나 0이면 1번으로 고정)

        if (review.getStoreId() == null || review.getStoreId() == 0) {
            review.setStoreId(1);
        }
        // 2. 유저 번호 (null이면 1번으로 고정)
        if (review.getUserNumber() == null || review.getUserNumber() == 0) {
            review.setUserNumber(1);
        }
        // 3. 별점 (이번 에러의 원인! null이면 임시로 5점 부여)
        if (review.getRating() == null) {
            review.setRating(5.0);
        }
        // 4. 카테고리 (null 방지)
        if (review.getCategory() == null) {
            review.setCategory("병원");
        }
        try {
            reviewMapper.registerReview(review);
            return "success";
        }catch (Exception e) {
            e.printStackTrace();
            return "fail";
        }
    }

    /**
     *
     */
    public String removeReview(int reviewId){
        int result = reviewMapper.deleteReview(reviewId);
        return (result > 0) ? "success" : "fail";
    }

}