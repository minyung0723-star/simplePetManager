package com.project.simplepetmanager.controller;

import com.project.simplepetmanager.common.CookieUtil;
import com.project.simplepetmanager.common.JwtUtil;
import com.project.simplepetmanager.model.dto.User;
import com.project.simplepetmanager.model.service.ReviewService;
import com.project.simplepetmanager.model.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/mypage")
@RequiredArgsConstructor
public class MyPageViewController {

    private final UserService   userService;
    private final ReviewService reviewService;
    private final JwtUtil       jwtUtil;
    private final CookieUtil    cookieUtil;

    /**
     * 마이페이지 메인
     * - 로그인 상태 확인 후 유저 정보 + 작성한 리뷰 목록을 Model에 담아 JSP로 전달
     * - JS 에서 div 생성 없이 JSTL 로 서버사이드 렌더링
     * /
     @GetMapping("/myPage")
     public String myPageView(HttpServletRequest request, Model model) {
     String token = cookieUtil.get(request, "access_token");

     // 비로그인 → 로그인 페이지로
     if (token == null || !jwtUtil.isValidToken(token)) {
     return "redirect:/user/login";
     }

     User user = userService.getUserByEmail(jwtUtil.getEmail(token));
     if (user == null) {
     return "redirect:/user/login";
     }

     // 작성한 리뷰 목록 (전체, 페이지네이션 없이 최신순)
     List<Map<String, Object>> myReviews = reviewService.getReviewsByUserNumber(user.getUserNumber());

     model.addAttribute("user",      user);
     model.addAttribute("myReviews", myReviews);

     return "mypage/myPage";
     }
     */
    /**
     * 마이페이지 메인
     * - 로그인 상태 확인 후 유저 정보 + 작성한 리뷰 목록을 Model에 담아 JSP로 전달
     * - JS 에서 div 생성 없이 JSTL 로 서버사이드 렌더링
     */
    @GetMapping("/myPage")
    public String myPageView(HttpServletRequest request, Model model) {
        String token = cookieUtil.get(request, "access_token");

        // 비로그인 → 목업 유저로 폴백 (토큰 없어도 마이페이지 확인 가능)
        User user = null;
        if (token != null && jwtUtil.isValidToken(token)) {
            user = userService.getUserByEmail(jwtUtil.getEmail(token));
        }

        // 목업: 토큰/유저 없을 때 임시 유저 생성
        if (user == null) {
            user = new User();
        }
        // ── 목업: DB 데이터 없을 때 임시 값 주입 ──────────────────
        // TODO: DB 연동 후 아래 블록 제거
        if (user.getUserName()  == null) user.setUserName("홍길동");
        if (user.getUserEmail() == null) user.setUserEmail("hong@petmanager.com");
        // imageUrl 이 null 이면 JSP에서 이니셜 아바타로 폴백됨 (수정 불필요)
        // ────────────────────────────────────────────────────────────

        // 작성한 리뷰 목록 (전체, 페이지네이션 없이 최신순)
        List<Map<String, Object>> myReviews;
        try {
            myReviews = reviewService.getReviewsByUserNumber(user.getUserNumber());
        } catch (Exception e) {
            // ── 목업: 리뷰 테이블 없을 때 샘플 데이터 ──────────────
            // TODO: DB 연동 후 제거
            myReviews = new java.util.ArrayList<>();
            java.util.Map<String, Object> r1 = new java.util.HashMap<>();
            r1.put("review_category", "동물병원");
            r1.put("shop_name",       "행복동물병원");
            r1.put("review_rating",   5);
            r1.put("review_content",  "선생님이 친절하고 진료가 꼼꼼해요. 강추합니다!");
            r1.put("created_date",    "2025-03-20 10:00:00");
            java.util.Map<String, Object> r2 = new java.util.HashMap<>();
            r2.put("review_category", "동물호텔");
            r2.put("shop_name",       "포근펫호텔");
            r2.put("review_rating",   4);
            r2.put("review_content",  "시설이 깨끗하고 강아지가 잘 적응했어요.");
            r2.put("created_date",    "2025-03-15 14:30:00");
            myReviews.add(r1);
            myReviews.add(r2);
            // ────────────────────────────────────────────────────────
        }

        model.addAttribute("user",      user);
        model.addAttribute("myReviews", myReviews);

        return "mypage/myPage";
    }
    /**
     * 회원정보 수정 페이지
     * - 폼 초기값은 JS fetch(/mypage/info) 로 채움 (기존 유지)
     */
    @GetMapping("/myPageEdit")
    public String myPageEditView(HttpServletRequest request) {
        // 목업: 토큰 체크 없이 바로 페이지 반환
        // TODO: DB 연동 후 아래 주석 해제
        // String token = cookieUtil.get(request, "access_token");
        // if (token == null || !jwtUtil.isValidToken(token)) {
        //     return "redirect:/user/login";
        // }
        return "mypage/myPageEdit";
    }
}