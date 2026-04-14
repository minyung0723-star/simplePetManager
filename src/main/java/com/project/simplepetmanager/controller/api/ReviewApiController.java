package com.project.simplepetmanager.controller.api;

import com.project.simplepetmanager.model.dto.Board;
import com.project.simplepetmanager.model.dto.Review;
import com.project.simplepetmanager.model.service.ReviewService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

// TODO_1 ___________________________________________
//  HttpServletRequest 임포트 추가 필요
import jakarta.servlet.http.HttpServletRequest;
// TODO_2 ___________________________________________
//  로그인 유저 조회에 필요한 CookieUtil, JwtUtil, UserService 임포트 추가 필요
import com.project.simplepetmanager.common.CookieUtil;
import com.project.simplepetmanager.common.JwtUtil;
import com.project.simplepetmanager.model.service.UserService;
import com.project.simplepetmanager.model.dto.User;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/review")
@RequiredArgsConstructor
public class ReviewApiController {

    private final ReviewService reviewService;

    // TODO_3 ___________________________________________
    //  아래 두 필드 추가 필요 (로그인 유저 조회용)
      private final JwtUtil     jwtUtil;
      private final CookieUtil  cookieUtil;
      private final UserService userService;


    // ==================== 리뷰 목록 ====================

    /**
     * 특정 병원의 리뷰 목록 가져오기 API (GET)
     * 주소: /api/review/list?storeId=1
     */
    @GetMapping("/list")
    public List<Review> getReviewList(@RequestParam("storeId") int storeId) {
        return reviewService.getReviewList(storeId);
    }


    // ==================== 리뷰 등록 ====================

    /**
     * 리뷰 등록 API (POST)
     * 주소: /api/review/insert
     */
    @PostMapping("/insert")
    public String insertReview(@RequestBody Review review, HttpServletRequest request) {

        // TODO_4 ___________________________________________
        //  파라미터에 HttpServletRequest request 추가
        //  public String insertReview(@RequestBody Review review, HttpServletRequest request)

        // TODO_5 ___________________________________________
        //  비로그인 차단 로직 추가
          User loginUser = getLoginUser(request);
          if (loginUser == null) {
              return "unauthorized"; // 프론트에서 이 값 받으면 로그인 페이지로 이동
          }

        // TODO_6 ___________________________________________
        //  하드코딩된 userNumber 제거 후 로그인 유저 번호 주입
        //  현재는 ReviewService.registerReview() 내부에서 userNumber=1로 고정됨
        //  아래처럼 여기서 세팅해서 넘기는 방식으로 변경:
        review.setUserNumber(loginUser.getUserNumber());

        try {
            // 3. ★ 핵심: 가게 이름(store_name) 주입 ★
            // DB에 store_name이 NOT NULL이므로, 등록 전에 반드시 이름을 채워줘야 합니다.
            Board storeInfo = reviewService.getStoreDetail(review.getStoreId());
            if (storeInfo != null) {
                review.setStoreName(storeInfo.getStoreName()); // Board 객체에서 이름을 가져와 Review에 세팅
            } else {
                // 혹시라도 가게 정보가 없으면 기본값이라도 넣어 에러 방지
                review.setStoreName("알 수 없는 상호명");
            }

            String result = reviewService.registerReview(review);
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return "fail";
        }
    }


    // ==================== 리뷰 삭제 ====================

    /**
     * 리뷰 삭제 API (POST)
     * 주소: /api/review/delete?reviewId=1
     */
    @PostMapping("/delete")
    public String deleteReview(@RequestParam("reviewId") int reviewId, HttpServletRequest request) {

        // TODO_7 ___________________________________________
        //  파라미터에 HttpServletRequest request 추가
        //  public String deleteReview(@RequestParam("reviewId") int reviewId, HttpServletRequest request)

        // TODO_8 ___________________________________________
        //  비로그인 차단 + 본인 리뷰 여부 확인 로직 추가
          User loginUser = getLoginUser(request);
          if (loginUser == null) return "unauthorized";

          Review target = reviewService.getReviewById(reviewId); // TODO_9 참고
          if (target == null || target.getUserNumber() != loginUser.getUserNumber()) {
              return "forbidden"; // 남의 리뷰는 삭제 불가
          }

        try {
            return reviewService.removeReview(reviewId,loginUser.getUserNumber());
        } catch (Exception e) {
            e.printStackTrace();
            return "fail";
        }
    }


    // ==================== 북마크 ====================

    /**
     * 북마크 토글 API (POST)
     * 주소: /api/review/bookmark/toggle
     */
    @PostMapping("/bookmark/toggle")
    public String toggleBookmark(@RequestBody Map<String, Object> params,HttpServletRequest request) {

        // TODO_10 ___________________________________________
        //  파라미터에 HttpServletRequest request 추가
        //  public String toggleBookmark(@RequestBody Map<String, Object> params, HttpServletRequest request)

        // TODO_11 ___________________________________________
        //  비로그인 차단 로직 추가
          User loginUser = getLoginUser(request);
          if (loginUser == null) return "unauthorized";

        try {
            if (params.get("storeId") == null) return "fail";

            long storeId = Long.parseLong(params.get("storeId").toString());

            // TODO_12 ___________________________________________
            //  하드코딩된 userNumber 제거 후 로그인 유저 번호로 교체
            //  현재: long userNumber = 1L;  ← 이 줄 삭제
            //  변경: long userNumber = loginUser.getUserNumber();
            long userNumber = loginUser.getUserNumber(); // ← TODO_12 완료 후 삭제할 줄

            String result = reviewService.toggleBookmark(userNumber, storeId);
            System.out.println("북마크 결과: " + result);
            return result;

        } catch (Exception e) {
            e.printStackTrace();
            return "fail";
        }
    }

    /**
     * 북마크 상태 확인 API (GET)
     * 주소: /api/review/bookmark/check?storeId=1
     */
    @GetMapping("/bookmark/check")
    public boolean checkBookmark(@RequestParam("storeId") long storeId, HttpServletRequest request) {

        // TODO_13 ___________________________________________
        //  파라미터에 HttpServletRequest request 추가
        //  public boolean checkBookmark(@RequestParam("storeId") long storeId, HttpServletRequest request)

        // TODO_14 ___________________________________________
        //  비로그인 시 false 반환 (북마크 안 된 상태)
          User loginUser = getLoginUser(request);
          if (loginUser == null) return false;

        // TODO_15 ___________________________________________
        //  하드코딩된 userNumber 제거 후 로그인 유저 번호로 교체
        //  현재: long userNumber = 1L;  ← 이 줄 삭제
        //  변경: long userNumber = loginUser.getUserNumber();
        long userNumber = loginUser.getUserNumber(); // ← TODO_15 완료 후 삭제할 줄 (변경)

        int count = reviewService.checkBookmark(userNumber, storeId);
        return count > 0;
    }


    // ==================== 병원 정보 ====================

    /**
     * 병원(가게) 정보 조회 API (GET)
     * 주소: /api/review/store/info?storeId=1
     */
    @GetMapping("/store/info")
    public Board getStoreInfo(@RequestParam("storeId") int storeId) {
        return reviewService.getStoreDetail(storeId);
    }


    // ==================== 내부 유틸 ====================

    // TODO_16 ___________________________________________
    //  아래 헬퍼 메서드 추가 (MyPageApiController와 동일한 방식)
    //  JWT 쿠키에서 로그인 유저를 꺼내는 공통 유틸

      private User getLoginUser(HttpServletRequest request) {
          String token = cookieUtil.get(request, "access_token");
          if (token == null || !jwtUtil.isValidToken(token)) return null;
          return userService.getUserByEmail(jwtUtil.getEmail(token));
      }

}