package com.project.simplepetmanager.controller.api;

import com.project.simplepetmanager.common.CookieUtil;
import com.project.simplepetmanager.common.EmailCodeService;
import com.project.simplepetmanager.common.JwtUtil;
import com.project.simplepetmanager.model.dto.User;
import com.project.simplepetmanager.model.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequiredArgsConstructor
public class UserApiController {

    private final UserService      userService;
    private final CookieUtil       cookieUtil;
    private final JwtUtil          jwtUtil;
    private final EmailCodeService emailCodeService;

    // ──────────────────────────────────────────────
    // 회원가입
    // ──────────────────────────────────────────────

    @PostMapping("/api/register")
    public ResponseEntity<?> register(@RequestBody User user) {
        userService.register(user);
        return ResponseEntity.ok(Map.of("message", "회원가입이 완료되었습니다."));
    }

    // ──────────────────────────────────────────────
    // 로그인
    // ──────────────────────────────────────────────

    @PostMapping("/api/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> body,
                                   HttpServletResponse response) {

        String userId       = body.get("userId");
        String userPassword = body.get("userPassword");

        Map<String, String> tokens = userService.login(userId, userPassword);
        if (tokens == null) {
            return ResponseEntity.badRequest()
                    .body(Map.of("message", "아이디 또는 비밀번호가 올바르지 않습니다."));
        }

        // 로그인한 유저 정보는 Service를 통해 조회 (Mapper 직접 호출 금지)
        User loginUser = userService.findByUserId(userId);

        cookieUtil.add(response, "access_token",  tokens.get("accessToken"),  60 * 30);
        cookieUtil.add(response, "refresh_token", tokens.get("refreshToken"), 60 * 60 * 24 * 14);

        Map<String, Object> responseBody = new HashMap<>();
        responseBody.put("message",    "로그인 성공");
        responseBody.put("userName",   loginUser.getUserName());
        responseBody.put("userNumber", loginUser.getUserNumber());
        return ResponseEntity.ok(responseBody);
    }

    // ──────────────────────────────────────────────
    // 로그아웃
    // ──────────────────────────────────────────────

    @PostMapping("/api/logout")
    public ResponseEntity<?> logout(HttpServletRequest request, HttpServletResponse response) {
        String token = cookieUtil.get(request, "access_token");
        if (token != null && jwtUtil.isValidToken(token)) {
            userService.logout(jwtUtil.getEmail(token));
        }
        cookieUtil.delete(response, "access_token");
        cookieUtil.delete(response, "refresh_token");
        return ResponseEntity.ok(Map.of("message", "로그아웃 완료"));
    }

    // ──────────────────────────────────────────────
    // 토큰 재발급
    // ──────────────────────────────────────────────

    @PostMapping("/api/token/refresh")
    public ResponseEntity<?> refreshToken(HttpServletRequest request, HttpServletResponse response) {
        String refreshToken = cookieUtil.get(request, "refresh_token");
        if (refreshToken == null) {
            return ResponseEntity.badRequest().body(Map.of("message", "다시 로그인해주세요."));
        }

        String newAccessToken = userService.tokenRefresh(refreshToken);
        if (newAccessToken == null) {
            return ResponseEntity.status(401).body(Map.of("message", "세션이 만료되었습니다. 다시 로그인해주세요."));
        }

        cookieUtil.add(response, "access_token", newAccessToken, 60 * 30);
        return ResponseEntity.ok(Map.of("message", "토큰 재발급 완료"));
    }

    // ──────────────────────────────────────────────
    // 아이디 찾기
    // ──────────────────────────────────────────────

    @PostMapping("/api/find-id")
    public ResponseEntity<?> findId(@RequestBody Map<String, String> body) {
        String foundId = userService.findUserId(body.get("userName"), body.get("userEmail"));
        if (foundId == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("message", "일치하는 정보가 없습니다."));
        }
        return ResponseEntity.ok(Map.of("userId", foundId));
    }

    // ──────────────────────────────────────────────
    // 비밀번호 찾기 전 사용자 검증
    // ──────────────────────────────────────────────

    @PostMapping("/api/verify-for-pw")
    public ResponseEntity<?> verifyForPw(@RequestBody Map<String, String> body, HttpSession session) {
        String userId    = body.get("userId");
        String userEmail = body.get("userEmail");

        if (!userService.verifyUser(userId, userEmail)) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("message", "정보가 일치하지 않습니다."));
        }

        session.setAttribute("verifiedUserId", userId);
        session.setMaxInactiveInterval(300); // 5분
        return ResponseEntity.ok(Map.of("message", "인증 완료"));
    }

    // ──────────────────────────────────────────────
    // 비밀번호 재설정
    // ──────────────────────────────────────────────

    @PostMapping("/api/update-password")
    public ResponseEntity<?> updatePassword(@RequestBody Map<String, String> body, HttpSession session) {
        String userId       = body.get("userId");
        String userPassword = body.get("userPassword");
        String verifiedId   = (String) session.getAttribute("verifiedUserId");

        if (verifiedId == null || !verifiedId.equals(userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(Map.of("message", "권한이 없거나 인증 세션이 만료되었습니다."));
        }
        if (userPassword == null || userPassword.trim().isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of("message", "유효하지 않은 요청입니다."));
        }
        if (!userService.updatePassword(userId, userPassword)) {
            return ResponseEntity.badRequest()
                    .body(Map.of("message", "비밀번호 형식이 올바르지 않거나 기존 비밀번호와 동일합니다."));
        }

        session.removeAttribute("verifiedUserId");
        return ResponseEntity.ok(Map.of("message", "비밀번호가 변경되었습니다."));
    }

    // ──────────────────────────────────────────────
    // 비밀번호 수정 권한 조기 만료
    // ──────────────────────────────────────────────

    @PostMapping("/api/clear-password-auth")
    public ResponseEntity<?> clearPasswordAuth(HttpSession session) {
        if (session != null) session.removeAttribute("verifiedUserId");
        return ResponseEntity.ok(Map.of("message", "인증 세션이 만료되었습니다."));
    }

    // ──────────────────────────────────────────────
    // 이메일 인증번호 발송
    // ──────────────────────────────────────────────

    @PostMapping("/api/email-auth")
    public ResponseEntity<?> sendEmailCode(@RequestBody Map<String, String> body) {
        String email = body.get("userEmail");
        String mode  = body.get("mode");

        if ("findPw".equals(mode)) {
            if (!userService.isEmailDuplicate(email)) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(Map.of("message", "등록되지 않은 이메일 주소입니다."));
            }
        } else {
            if (userService.isEmailDuplicate(email)) {
                return ResponseEntity.status(HttpStatus.CONFLICT)
                        .body(Map.of("message", "이미 사용 중인 이메일입니다."));
            }
        }

        emailCodeService.sendVerificationCode(email);
        return ResponseEntity.ok(Map.of("message", "인증번호 발송 완료"));
    }

    // ──────────────────────────────────────────────
    // 이메일 인증번호 검증
    // ──────────────────────────────────────────────

    @PostMapping("/api/email-verify")
    public ResponseEntity<?> verifyEmailCode(@RequestBody Map<String, String> body, HttpSession session) {
        String email  = body.get("userEmail");
        String code   = body.get("emailCode");
        String userId = body.get("userId");

        if (!emailCodeService.verifyCode(email, code)) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Map.of("message", "인증번호 불일치"));
        }

        session.setAttribute("verifiedUserId", userId);
        session.setMaxInactiveInterval(180); // 3분
        return ResponseEntity.ok(Map.of("message", "인증 성공"));
    }

    // ──────────────────────────────────────────────
    // 아이디 중복 체크
    // ──────────────────────────────────────────────

    @GetMapping("/api/check-id")
    public ResponseEntity<?> checkId(@RequestParam String userId) {
        return ResponseEntity.ok(Map.of("isDuplicate", userService.isIdDuplicate(userId)));
    }
}