package com.project.simplepetmanager.controller.api;

import com.project.simplepetmanager.common.CookieUtil;
import com.project.simplepetmanager.model.dto.User;
import com.project.simplepetmanager.model.mapper.UserMapper;
import com.project.simplepetmanager.model.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/user")
public class UserApiController {

    private final UserService userService;
    private final CookieUtil cookieUtil;
    private final UserMapper userMapper;

    /**
     * 회원가입 API
     * register.jsp에서 fetch로 호출
     */
    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody User user){

        userService.register(user);

        return ResponseEntity.ok().build();
    }

    /**
     * [1. 로그인 기능]
     * 클라이언트로부터 아이디와 비밀번호를 받아 UserService에서 검증합니다.
     * 인증 성공 시 Access Token과 Refresh Token을 생성하며,
     * 보안을 위해 두 토큰 모두 HttpOnly 쿠키에 저장하여 클라이언트에 전달합니다.
     */
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> body,
                                   HttpServletResponse response) {
        String userId = body.get("userId");
        String userPassword = body.get("userPassword");

        // 1. 서비스 로직을 통해 토큰 생성 (인증 확인)
        Map<String, String> tokens = userService.login(userId, userPassword);

        if (tokens == null) {
            return ResponseEntity.badRequest()
                    .body(Map.of("message", "아이디 또는 비밀번호가 올바르지 않습니다."));
        }

        // 2. ✅ 이름(userName)을 가져오기 위해 DB에서 유저 정보 조회
        // (만약 userService.login에서 이미 User 객체를 리턴하게 수정했다면 그 객체를 써도 됩니다)
        User loginUser = userMapper.findByUserId(userId);

        // 3. 토큰 쿠키 저장
        cookieUtil.add(response, "access_token", tokens.get("accessToken"), 60 * 30);
        cookieUtil.add(response, "refresh_token", tokens.get("refreshToken"), 60 * 30 * 24 * 14);

        // 4. ✅ 응답 데이터에 userName 추가 (핵심!)
        Map<String, Object> responseBody = new HashMap<>();
        responseBody.put("message", "로그인 성공");
        responseBody.put("userName", loginUser.getUserName()); // JSP에서 data.userName으로 읽게 됨

        return ResponseEntity.ok(responseBody);
    }

    /**
     * [2. 로그아웃 기능]
     * 서버 측 보관함(Map 또는 Redis)에서 해당 유저의 리프레시 토큰을 제거합니다.
     * 브라우저에 저장된 액세스 토큰과 리프레시 토큰 쿠키를 삭제하여 세션을 종료합니다.
     */
    @PostMapping("/logout")
    public ResponseEntity<?> logout(@AuthenticationPrincipal String email, HttpServletResponse response) {
        // 서버 메모리에서 리프레시 토큰 삭제
        userService.logout(email);

        // 클라이언트 쿠키 삭제
        cookieUtil.delete(response, "access_token");
        cookieUtil.delete(response, "refresh_token");

        return ResponseEntity.ok(Map.of("message", "로그아웃 완료"));
    }

    /**
     * [3. 토큰 재발급 기능]
     * 액세스 토큰이 만료되었을 때, 쿠키에 담긴 리프레시 토큰을 확인합니다.
     * 리프레시 토큰이 유효하다면 사용자가 다시 로그인할 필요 없이
     * 새로운 액세스 토큰을 발급하여 흐름을 유지합니다.
     */
    @PostMapping("/token/refresh")
    public ResponseEntity<?> refreshToken(HttpServletRequest request, HttpServletResponse response) {
        // 쿠키에서 리프레시 토큰 추출
        String refreshToken = cookieUtil.get(request, "refresh_token");

        if (refreshToken == null) {
            return ResponseEntity.badRequest()
                    .body(Map.of("message", "다시 로그인해주세요."));
        }

        // 서비스 로직을 통해 새로운 액세스 토큰 생성 시도
        String newAccessToken = userService.tokenRefresh(refreshToken);

        if (newAccessToken == null) {
            return ResponseEntity.status(401)
                    .body(Map.of("message", "세션이 만료되었습니다. 다시 로그인해주세요."));
        }

        // 새롭게 발급된 액세스 토큰을 쿠키에 업데이트
        cookieUtil.add(response, "access_token", newAccessToken, 60 * 30);

        return ResponseEntity.ok(Map.of("message", "토큰 재발급 완료"));
    }

    /**
     * 아이디 찾기 API
     */
    @PostMapping("/find-id")
    public ResponseEntity<?> findId(@RequestBody Map<String, String> body) {
        String userName = body.get("userName");
        String userEmail = body.get("userEmail");

        String foundId = userService.findUserId(userName, userEmail);

        if (foundId == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Map.of("message", "일치하는 정보가 없습니다."));
        }

        return ResponseEntity.ok(Map.of("userId", foundId));
    }

    /**
     * 비밀번호 찾기 전 사용자 검증 API
     */
    @PostMapping("/verify-for-pw")
    public ResponseEntity<?> verifyForPw(@RequestBody Map<String, String> body) {
        String userId = body.get("userId");
        String userEmail = body.get("userEmail");

        boolean isValid = userService.verifyUser(userId, userEmail);

        if (!isValid) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Map.of("message", "정보가 일치하지 않습니다."));
        }

        return ResponseEntity.ok().build();
    }

    /**
     * 비밀번호 재설정 API
     */
    @PostMapping("/update-password")
    public ResponseEntity<?> updatePassword(@RequestBody Map<String, String> body) {
        String userId = body.get("userId");
        String userPassword = body.get("userPassword");

        if (userId == null || userPassword == null || userPassword.trim().isEmpty()) {
            return ResponseEntity.badRequest()
                    .body(Map.of("message", "유효하지 않은 요청입니다."));
        }

        boolean isUpdated = userService.updatePassword(userId, userPassword);

        if (!isUpdated) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("message", "비밀번호 변경 중 오류가 발생했습니다."));
        }

        return ResponseEntity.ok(Map.of("message", "비밀번호가 변경되었습니다."));
    }

}