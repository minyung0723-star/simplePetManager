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
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String uri = request.getRequestURI();

        // [필수 추가] 정적 리소스(js, css, images) 요청은 인터셉터 로직을 완전히 무시하고 통과시킵니다.
        // WebConfig에서 제외해도 되지만, 여기서 한 번 더 막아주는 것이 안전합니다.
        if (uri.endsWith(".js") || uri.endsWith(".css") || uri.endsWith(".png") || uri.endsWith(".jpg")) {
            return true;
        }

        String token = cookieUtil.get(request, "access_token");
        HttpSession session = request.getSession(false);
        String verifiedUserId = (session != null) ? (String) session.getAttribute("verifiedUserId") : null;

        boolean isLoggedIn = (token != null && jwtUtil.isValidToken(token));


        // 최소한 .js 파일이 아닐 때만 작동하도록 조건을 보강합니다.
        if (uri.endsWith("/passwordEdit")) {
            String paramUserId = request.getParameter("userId");

            if (verifiedUserId != null && verifiedUserId.equals(paramUserId)) {
                return true;
            }

            response.sendRedirect(request.getContextPath() + "/?error=forbidden");
            return false;
        }

        if (!isLoggedIn) {
            return true;
        }

        // 로그인된 사용자 처리
        String email = jwtUtil.getEmail(token);
        // findByUserId를 쓰거나, login 메서드가 확실히 이메일로 작동하는지 확인하세요.
        User loginUser = userMapper.login(email);

        if (loginUser != null) {
            request.setAttribute("loginUser", loginUser);

            // 페이지 이동 제어
            if (uri.endsWith("/login") || uri.endsWith("/register") || uri.endsWith("/findUser")||
                    uri.contains("/passwordEdit")) {
                response.sendRedirect(request.getContextPath() + "/?LoggedIn=true");
                return false;
            }
        }

        return true;
    }
}