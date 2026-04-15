package com.project.simplepetmanager.controller.api;

import com.project.simplepetmanager.common.CookieUtil;
import com.project.simplepetmanager.common.JwtUtil;
import com.project.simplepetmanager.model.dto.Board;
import com.project.simplepetmanager.model.dto.Review;
import com.project.simplepetmanager.model.dto.User;
import com.project.simplepetmanager.model.service.ReviewService;
import com.project.simplepetmanager.model.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/review")
@RequiredArgsConstructor
public class ReviewApiController {

    private final ReviewService reviewService;
    private final UserService   userService;
    private final JwtUtil       jwtUtil;
    private final CookieUtil    cookieUtil;

    // ──────────────────────────────────────────────
    // 리뷰 목록
    // ──────────────────────────────────────────────

    /** GET /api/review/list?storeId=1 */
    @GetMapping("/list")
    public ResponseEntity<List<Review>> getReviewList(@RequestParam int storeId) {
        return ResponseEntity.ok(reviewService.getReviewList(storeId));
    }

    // ──────────────────────────────────────────────
    // 리뷰 등록
    // ──────────────────────────────────────────────

    /**
     * POST /api/review/insert
     * Body: { storeId, reviewContent, rating, category(선택) }
     */
    @PostMapping("/insert")
    public ResponseEntity<Map<String, Object>> insertReview(
            @RequestBody Review review,
            HttpServletRequest request) {

        User loginUser = getLoginUser(request);
        if (loginUser == null) {
            return ResponseEntity.status(401).body(Map.of("success", false, "message", "로그인이 필요합니다."));
        }

        // userNumber는 서버에서 JWT로 세팅 (클라이언트 값 무시)
        review.setUserNumber(loginUser.getUserNumber());

        reviewService.registerReview(review);
        return ResponseEntity.ok(Map.of("success", true, "message", "리뷰가 등록되었습니다."));
    }

    // ──────────────────────────────────────────────
    // 리뷰 수정
    // ──────────────────────────────────────────────

    /**
     * PUT /api/review/update
     * Body: { reviewId, reviewContent, rating, category(선택) }
     */
    @PutMapping("/update")
    public ResponseEntity<Map<String, Object>> updateReview(
            @RequestBody Review review,
            HttpServletRequest request) {

        User loginUser = getLoginUser(request);
        if (loginUser == null) {
            return ResponseEntity.status(401).body(Map.of("success", false, "message", "로그인이 필요합니다."));
        }

        // 본인 확인: DB 조회
        Review existing = reviewService.getReviewById(review.getReviewId());
        if (existing == null) {
            return ResponseEntity.status(404).body(Map.of("success", false, "message", "존재하지 않는 리뷰입니다."));
        }
        if (!existing.getUserNumber().equals(loginUser.getUserNumber())) {
            return ResponseEntity.status(403).body(Map.of("success", false, "message", "수정 권한이 없습니다."));
        }

        // userNumber 세팅 후 수정 (XML WHERE 조건 이중 보호)
        review.setUserNumber(loginUser.getUserNumber());
        reviewService.updateReview(review);
        return ResponseEntity.ok(Map.of("success", true, "message", "리뷰가 수정되었습니다."));
    }

    // ──────────────────────────────────────────────
    // 리뷰 삭제
    // ──────────────────────────────────────────────

    /**
     * DELETE /api/review/delete?reviewId=1
     */
    @DeleteMapping("/delete")
    public ResponseEntity<Map<String, Object>> deleteReview(
            @RequestParam int reviewId,
            HttpServletRequest request) {

        User loginUser = getLoginUser(request);
        if (loginUser == null) {
            return ResponseEntity.status(401).body(Map.of("success", false, "message", "로그인이 필요합니다."));
        }

        Review target = reviewService.getReviewById(reviewId);
        if (target == null) {
            return ResponseEntity.status(404).body(Map.of("success", false, "message", "존재하지 않는 리뷰입니다."));
        }
        if (!target.getUserNumber().equals(loginUser.getUserNumber())) {
            return ResponseEntity.status(403).body(Map.of("success", false, "message", "삭제 권한이 없습니다."));
        }

        reviewService.removeReview(reviewId);
        return ResponseEntity.ok(Map.of("success", true, "message", "리뷰가 삭제되었습니다."));
    }

    // ──────────────────────────────────────────────
    // 북마크
    // ──────────────────────────────────────────────

    /** POST /api/review/bookmark/toggle  Body: { storeId } */
    @PostMapping("/bookmark/toggle")
    public ResponseEntity<Map<String, Object>> toggleBookmark(
            @RequestBody Map<String, Object> body,
            HttpServletRequest request) {

        User loginUser = getLoginUser(request);
        if (loginUser == null) {
            return ResponseEntity.status(401).body(Map.of("success", false, "message", "로그인이 필요합니다."));
        }

        long storeId = Long.parseLong(body.get("storeId").toString());
        String result = reviewService.toggleBookmark(loginUser.getUserNumber(), storeId);
        return ResponseEntity.ok(Map.of("success", true, "result", result));
    }

    /** GET /api/review/bookmark/check?storeId=1 */
    @GetMapping("/bookmark/check")
    public ResponseEntity<Map<String, Object>> checkBookmark(
            @RequestParam long storeId,
            HttpServletRequest request) {

        User loginUser = getLoginUser(request);
        boolean bookmarked = loginUser != null && reviewService.isBookmarked(loginUser.getUserNumber(), storeId);
        return ResponseEntity.ok(Map.of("bookmarked", bookmarked));
    }

    // ──────────────────────────────────────────────
    // 병원 정보
    // ──────────────────────────────────────────────

    /** GET /api/review/store/info?storeId=1 */
    @GetMapping("/store/info")
    public ResponseEntity<Board> getStoreInfo(@RequestParam int storeId) {
        return ResponseEntity.ok(reviewService.getStoreDetail(storeId));
    }

    // ──────────────────────────────────────────────
    // 내부 유틸
    // ──────────────────────────────────────────────

    private User getLoginUser(HttpServletRequest request) {
        String token = cookieUtil.get(request, "access_token");
        if (token == null || !jwtUtil.isValidToken(token)) return null;
        return userService.getUserByEmail(jwtUtil.getEmail(token));
    }
}