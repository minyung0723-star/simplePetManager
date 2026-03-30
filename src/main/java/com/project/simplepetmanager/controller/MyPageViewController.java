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
//@RequestMapping("/mypage")
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
     */
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

    /**
     * 회원정보 수정 페이지
     * - 폼 초기값은 JS fetch(/mypage/info) 로 채움 (기존 유지)
     */
    @GetMapping("/myPageEdit")
    public String myPageEditView(HttpServletRequest request) {
        String token = cookieUtil.get(request, "access_token");
        if (token == null || !jwtUtil.isValidToken(token)) {
            return "redirect:/user/login";
        }
        return "mypage/myPageEdit";
    }
}