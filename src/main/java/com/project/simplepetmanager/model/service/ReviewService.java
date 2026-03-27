package com.project.simplepetmanager.model.service;

import com.project.simplepetmanager.model.dto.Review;
import com.project.simplepetmanager.model.mapper.ReviewMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ReviewService {

    @Autowired
    private ReviewMapper reviewMapper; // 외부에서 함부로 조작 못하게 private으로 선언!

    /**
     * 새로운 리뷰를 등록하는 기능 (public: 컨트롤러가 호출 가능)
     * @param review 사용자가 입력한 데이터가 담긴 바구니
     */
    public void registerReview(Review review) {
        // 나중에 "이미 리뷰를 쓴 사용자인지 확인" 같은 로직이 들어올 수 잇음.
        reviewMapper.insertReview(review);
    }

    /**
     * 특정 병원의 리뷰 목록을 가져오는 기능 (public: 컨트롤러가 호출 가능)
     * @param storeId 병원 번호
     * @return 작성자 정보가 포함된 리뷰 리스트
     */
    public List<Review> getReviewList(int storeId) {
        return reviewMapper.getReviewList(storeId);
    }
}