package com.project.simplepetmanager.controller.api;

import com.project.simplepetmanager.model.dto.Board;
import com.project.simplepetmanager.model.dto.Review;
import com.project.simplepetmanager.model.service.ReviewService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController // 데이터를 반환하는 전용 컨트롤러임을 선언!
@RequestMapping("/review") // 이 컨트롤러의 모든 주소는 /api/reviews로 시작합니다.
@RequiredArgsConstructor
public class ReviewApiController {
    private final ReviewService reviewService;

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

    @PostMapping("/bookmark/toggle")
    public String toggleBookmark(@RequestBody Map<String, Object> params) {
        try {
            if (params.get("storeId") == null) {
                return "fail";
            }

            long storeId = Long.parseLong(params.get("storeId").toString());
            long userNumber = 1L; // [중요] 나중에 세션에서 가져와야 하지만, 일단 1번 유저로 테스트!

            // 3. ⭐⭐⭐ 드디어 서비스 호출! (여기가 진짜 DB랑 싸우는 곳) ⭐⭐⭐
            String result = reviewService.toggleBookmark(userNumber, storeId);

            System.out.println("결과: " + result); // 콘솔에 inserted 또는 deleted가 찍혀야 성공!
            return result; // 프론트에 상태를 알려줍니다.

        } catch (Exception e) {
            e.printStackTrace();
            return "fail";
        }
    }

    @GetMapping("/bookmark/check") // 최종 주소: /review/bookmark/check
    public boolean checkBookmark(@RequestParam("storeId") long storeId) {
        // 1. 임시 유저 번호 설정 (나중에 세션에서!)
        long userNumber = 1L;

        // 2. 서비스의 checkBookmark 메서드 호출!
        // (결과가 1이면 true, 0이면 false를 반환하게 로직을 짜면 JS가 편해요)
        int count = reviewService.checkBookmark(userNumber, storeId);

        return count > 0;
    }

    @GetMapping("/store/info")
    public Board getStoreInfo(@RequestParam("storeId") int storeId) {
        // DB에서 병원(Board) 정보를 가져와서 리턴!
        return reviewService.getStoreDetail(storeId);
    }

}