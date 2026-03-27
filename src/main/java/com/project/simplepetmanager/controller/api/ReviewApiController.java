package com.project.simplepetmanager.controller.api;

import com.project.simplepetmanager.model.dto.Review;
import com.project.simplepetmanager.model.service.ReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController // 데이터를 반환하는 전용 컨트롤러임을 선언!
@RequestMapping("/api/reviews") // 이 컨트롤러의 모든 주소는 /api/reviews로 시작합니다.
public class ReviewApiController {

    @Autowired
    private ReviewService reviewService;

    /**
     * 1. 리뷰 등록 API (POST 방식)
     * 사용자가 입력한 데이터를 JSON 형태로 받아 DB에 저장합니다.
     */
    @PostMapping("/insert")
    public String insertReview(@RequestBody Review review) {
        // @RequestBody: 화면에서 보낸 JSON 데이터를 Review 객체로 자동 변환해줍니다.
        try {
            reviewService.registerReview(review);
            return "success"; // 성공 시 문자열 반환
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