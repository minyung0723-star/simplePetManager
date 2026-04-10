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
     * GET /mypage/myPage
     * - 비로그인 시 로그인 페이지로 리다이렉트
     * - 유저 정보 + 내가 작성한 리뷰 목록을 Model에 담아 JSP 렌더링
     */
    @GetMapping("/myPage")
    public String myPageView(HttpServletRequest request, Model model) {
        String token = cookieUtil.get(request, "access_token");

        if (token == null || !jwtUtil.isValidToken(token)) {
            return "redirect:/login";
        }

        User user = userService.getUserByEmail(jwtUtil.getEmail(token));
        if (user == null) {
            return "redirect:/login";
        }

       // List<Map<String, Object>> myReviews = reviewService.getReviewsByUserNumber(user.getUserNumber());

        model.addAttribute("user",      user);
      //  model.addAttribute("myReviews", myReviews);

        return "mypage/myPage";
    }

    /**
     * 회원정보 수정 페이지
     * GET /mypage/myPageEdit
     * - 비로그인 시 로그인 페이지로 리다이렉트
     * - 폼 초기값은 JS fetch(/mypage/info) 로 채움
     */
    @GetMapping("/myPageEdit")
    public String myPageEditView(HttpServletRequest request) {
        String token = cookieUtil.get(request, "access_token");

        if (token == null || !jwtUtil.isValidToken(token)) {
            return "redirect:/login";
        }

        return "mypage/myPageEdit";
    }
}