package com.project.simplepetmanager.common;

import com.project.simplepetmanager.model.dto.User;
import com.project.simplepetmanager.model.mapper.UserMapper;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
@RequiredArgsConstructor
public class LoginInterceptor implements HandlerInterceptor {

    private final JwtUtil jwtUtil;
    private final CookieUtil cookieUtil;
    private final UserMapper userMapper;

    @Override
    public boolean preHandle(HttpServletRequest req,
                             HttpServletResponse res,
                             Object handler) throws Exception {

        String uri = req.getRequestURI();

        // 1. 정적 리소스 통과
        if (uri.endsWith(".js") || uri.endsWith(".css") ||
                uri.endsWith(".png") || uri.endsWith(".jpg")) {
            return true;
        }

        // 2. 인증 정보 확인
        String token = cookieUtil.get(req, "access_token");
        boolean isLoggedIn = (token != null && jwtUtil.isValidToken(token));

        // 3. 비로그인 사용자 처리
        if (!isLoggedIn) {
            // (1) 리뷰 작성 페이지는 무조건 로그인 필요
            if (uri.contains("/review/create")) {
                res.sendRedirect(req.getContextPath() + "/login");
                return false;
            }

            // (2) 비밀번호 수정 페이지: '인증 세션'과 '파라미터'가 일치할 때만 허용
            if (uri.contains("/passwordEdit")) {
                if (checkPasswordEditAccess(req)) {
                    return true; // 인증된 비로그인 사용자만 통과
                }
                // 인증 안 된 사용자가 주소창 입력 시 로그인으로 차단
                res.sendRedirect(req.getContextPath() + "/login");
                return false;
            }

            return true; // 그 외 일반 페이지 허용
        }

        // 4. 로그인 된 사용자: 비밀번호 변경 페이지 권한 체크
        if (uri.endsWith("/passwordEdit")) {
            if (!checkPasswordEditAccess(req)) {
                res.sendRedirect(req.getContextPath() + "/?error=forbidden");
                return false;
            }
            return true;
        }

        // 5. 로그인 된 사용자: 정보 세팅 및 중복 페이지 차단
        return handleLoggedInUser(req, res, token, uri);
    }

    /**
     * 비밀번호 변경 권한 검증: 세션의 ID와 URL의 userId 파라미터가 같아야 함
     */
    private boolean checkPasswordEditAccess(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return false;

        String verifiedId = (String) session.getAttribute("verifiedUserId");
        String paramId = req.getParameter("userId");

        // 세션에 값이 있고, 그 값이 현재 페이지의 userId 파라미터와 같아야만 true
        return verifiedId != null && verifiedId.equals(paramId);
    }

    /**
     * 로그인 사용자 세션 처리 및 접근 제한
     */
    private boolean handleLoggedInUser(HttpServletRequest req,
                                       HttpServletResponse res,
                                       String token,
                                       String uri) throws Exception {

        String email = jwtUtil.getEmail(token);
        User loginUser = userMapper.login(email);

        if (loginUser != null) {
            req.setAttribute("loginUser", loginUser);

            if (uri.endsWith("/login") ||
                    uri.endsWith("/register") ||
                    uri.endsWith("/findUser")) {

                res.sendRedirect(req.getContextPath() + "/?LoggedIn=true");
                return false;
            }
        }
        return true;
    }
}