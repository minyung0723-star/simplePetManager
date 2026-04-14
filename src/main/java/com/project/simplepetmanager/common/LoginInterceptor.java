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
        String contextPath = req.getContextPath();

        // 1. 비밀번호 찾기 인증 세션 관리 (메인 페이지 "/" 진입 시 인증 세션 파기)
        if (uri.equals(contextPath + "/") || uri.equals("/")) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.removeAttribute("verifiedUserId");
            }
        }

        // 2. 보안 페이지 캐시 방지 (비밀번호 수정, 회원정보 수정 등)
        // 뒤로가기 버튼으로 인증 없이 페이지에 진입하는 것을 방지합니다.
        if (uri.contains("/passwordEdit") || uri.contains("/myPageEdit")) {
            res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            res.setHeader("Pragma", "no-cache");
            res.setDateHeader("Expires", 0);
        }

        // 3. 토큰 확인 (로그인 여부 판단)
        String token = cookieUtil.get(req, "access_token");
        boolean isLoggedIn = (token != null && jwtUtil.isValidToken(token));

        // 4. [특수 권한 체크] 비밀번호 수정 페이지 (/passwordEdit)
        if (uri.contains("/passwordEdit")) {
            if (!checkPasswordEditAccess(req)) {
                // 이메일 인증 세션이 없거나 파라미터와 불일치할 경우 차단
                res.sendRedirect(contextPath + "/?error=forbidden");
                return false;
            }
            // 권한이 있다면 유저 정보를 셋팅하여 JSP에서 사용할 수 있게 함
            setLoginUserAttribute(req, token);
            return true;
        }

        // 5. [중복 페이지 차단] 로그인 된 사용자가 로그인/회원가입/유저찾기 접근 시
        if (isLoggedIn) {
            if (uri.endsWith("/login") || uri.endsWith("/register") || uri.endsWith("/findUser")) {
                res.sendRedirect(contextPath + "/?LoggedIn=true");
                return false;
            }
            // 로그인 상태라면 공통적으로 유저 정보를 request에 셋팅 (헤더 표시용 등)
            setLoginUserAttribute(req, token);
        }

        return true;
    }

    /**
     * 비밀번호 변경 권한 검증
     * - 이메일 인증 성공 시 세션에 담긴 'verifiedUserId'와
     * - 현재 URL의 'userId' 파라미터가 동일한지 대조합니다.
     */
    private boolean checkPasswordEditAccess(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return false;

        String verifiedId = (String) session.getAttribute("verifiedUserId");
        String paramId = req.getParameter("userId");

        return verifiedId != null && verifiedId.equals(paramId);
    }

    /**
     * 로그인 사용자 정보를 Request Attribute에 저장
     * - 중복 조회를 방지하며, JSP에서 ${loginUser}로 접근 가능하게 합니다.
     */
    private void setLoginUserAttribute(HttpServletRequest req, String token) {
        if (token != null && req.getAttribute("loginUser") == null) {
            String email = jwtUtil.getEmail(token);
            User loginUser = userMapper.login(email);
            if (loginUser != null) {
                req.setAttribute("loginUser", loginUser);
            }
        }
    }
}