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
@RequestMapping("/api/review") // 이 컨트롤러의 모든 주소는 /api/reviews로 시작합니다.
@RequiredArgsConstructor
public class ReviewApiController {
    private final ReviewService reviewService;


    /**
     * 특정 병원의 리뷰 목록 가져오기 API (GET 방식)
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

    /**
     * 리뷰 등록 API (POST 방식)
     * 주소: /api/review/insert
     */
    @PostMapping("/insert")
    public String insertReview(@RequestBody Review review) {
        try {
            // [지니의 팁] 나중에 세션 생기면 여기서 userNumber를 넣어주면 돼!
            // 지금은 서비스 안에서 임시로 1번 유저로 설정되게 짜놨을 거야.

            // 1. 서비스 호출해서 DB에 저장!
            String result = reviewService.registerReview(review);

            // 2. 결과 리턴 ("success" 또는 "fail")
            return result;

        } catch (Exception e) {
            e.printStackTrace();
            return "fail";
        }
    }

    /**
     *  삭제버튼 (임시)
     */
    @PostMapping("/delete")
    public String deleteReview(@RequestParam("reviewId") int reviewId) {
        try {
            // [지니의 팁] 나중에 여기서 "진짜 본인인지" 체크하는 로직을 넣으면 완벽해!
            return reviewService.removeReview(reviewId);
        } catch (Exception e) {
            e.printStackTrace();
            return "fail";
        }
    }

}