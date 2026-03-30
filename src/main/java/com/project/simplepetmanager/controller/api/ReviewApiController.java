package com.project.simplepetmanager.controller.api;

import com.project.simplepetmanager.model.dto.Review;
import com.project.simplepetmanager.model.service.ReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController // 데이터를 반환하는 전용 컨트롤러임을 선언!
@RequestMapping("/review") // 이 컨트롤러의 모든 주소는 /api/reviews로 시작합니다.
public class ReviewApiController {

    @Autowired
    private ReviewService reviewService;

    /**
     * 1. 리뷰 등록 API (POST 방식)
     * 사용자가 입력한 데이터를 JSON 형태로 받아 DB에 저장합니다.
     */
//    @PostMapping("/insertReview")
//    public String insertReview(Review review) {
//        try {
//            reviewService.registerReview(review);
//            return "success"; // 성공 시 문자열 반환
//        } catch (Exception e) {
//            e.printStackTrace();
//            return "fail";
//        }
//    }
    @PostMapping("/insertReview")
    public String insertReview(Review review) {
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
            reviewService.registerReview(review);
            return "success";
        } catch (Exception e) {
            e.printStackTrace();
            return "fail";
        }
    }

    /**
     * 2. 특정 병원의 리뷰 목록 가져오기 API (GET 방식)
     * 주소 예시: /api/reviews/list?storeId=10
     */
    @GetMapping("/list")
    public List<Review> getReviewList(@RequestParam("storeId") int storeId) {
        // List를 반환하면 스프링이 알아서 JSON 배열([{}, {}]) 모양으로 바꿔서 보내줍니다.
        return reviewService.getReviewList(storeId);
    }


}