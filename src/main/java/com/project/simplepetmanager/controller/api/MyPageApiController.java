package com.project.simplepetmanager.controller.api;

import com.project.simplepetmanager.common.CookieUtil;
import com.project.simplepetmanager.common.JwtUtil;
import com.project.simplepetmanager.model.dto.User;
import com.project.simplepetmanager.model.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/mypage")
@RequiredArgsConstructor
public class MyPageApiController {

    private final UserService userService;
    private final JwtUtil     jwtUtil;
    private final CookieUtil  cookieUtil;

    /** 업로드 저장 경로 (application.yaml 에서 주입하는 것을 권장) */
    private static final String UPLOAD_DIR = System.getProperty("user.home") + "/uploads/profile/";

    /**
     * 내 정보 조회
     * GET /mypage/info
     */
    @GetMapping("/info")
    public ResponseEntity<Map<String, Object>> getMyInfo(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();
        User user = getLoginUser(request);

        if (user == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return ResponseEntity.ok(result);
        }

        result.put("success",    true);
        result.put("userName",   user.getUserName());
        result.put("userEmail",  user.getUserEmail());
        result.put("imageUrl",   user.getImageUrl());
        return ResponseEntity.ok(result);
    }

    /**
     * 기본 정보 수정 (이름, 이메일)
     * PUT /mypage/update
     * Body: { userName, userEmail }
     */
    @PutMapping("/update")
    public ResponseEntity<Map<String, Object>> updateMyInfo(
            @RequestBody Map<String, Object> body,
            HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();
        User user = getLoginUser(request);

        if (user == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return ResponseEntity.ok(result);
        }

        body.put("userNumber", user.getUserNumber());
        return ResponseEntity.ok(userService.updateUserInfo(body));
    }

    /**
     * 비밀번호 변경
     * PUT /mypage/password
     * Body: { currentPassword, newPassword }
     */
    @PutMapping("/password")
    public ResponseEntity<Map<String, Object>> changePassword(
            @RequestBody Map<String, Object> body,
            HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();
        User user = getLoginUser(request);

        if (user == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return ResponseEntity.ok(result);
        }

        body.put("userNumber", user.getUserNumber());
        return ResponseEntity.ok(userService.changePassword(body));
    }

    /**
     * 프로필 사진 업로드
     * POST /mypage/profile-image
     * multipart/form-data: file
     */
    @PostMapping("/profile-image")
    public ResponseEntity<Map<String, Object>> uploadProfileImage(
            @RequestParam("file") MultipartFile file,
            HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();
        User user = getLoginUser(request);

        if (user == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return ResponseEntity.ok(result);
        }

        if (file.isEmpty()) {
            result.put("success", false);
            result.put("message", "파일이 없습니다.");
            return ResponseEntity.ok(result);
        }

        try {
            File dir = new File(UPLOAD_DIR);
            if (!dir.exists()) dir.mkdirs();

            String ext      = getExtension(file.getOriginalFilename());
            String fileName = UUID.randomUUID() + "." + ext;
            File   dest     = new File(UPLOAD_DIR + fileName);
            file.transferTo(dest);

            String imageUrl = "/uploads/profile/" + fileName;
            Map<String, Object> updateParam = new HashMap<>();
            updateParam.put("userNumber", user.getUserNumber());
            updateParam.put("imageUrl",   imageUrl);
            userService.updateProfileImage(updateParam);

            result.put("success",  true);
            result.put("imageUrl", imageUrl);
            result.put("message",  "프로필 사진이 변경되었습니다.");
        } catch (IOException e) {
            result.put("success", false);
            result.put("message", "파일 업로드에 실패했습니다.");
        }

        return ResponseEntity.ok(result);
    }

    /**
     * 회원 탈퇴
     * DELETE /mypage/withdraw
     * Body: { userPassword }
     */
    @DeleteMapping("/withdraw")
    public ResponseEntity<Map<String, Object>> withdraw(
            @RequestBody Map<String, Object> body,
            HttpServletRequest request,
            HttpServletResponse response) {

        Map<String, Object> result = new HashMap<>();
        User user = getLoginUser(request);

        if (user == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return ResponseEntity.ok(result);
        }

        body.put("userNumber", user.getUserNumber());
        Map<String, Object> withdrawResult = userService.withdraw(body);

        // 탈퇴 성공 시 쿠키 삭제
        if (Boolean.TRUE.equals(withdrawResult.get("success"))) {
            cookieUtil.remove(response, "access_token");
        }

        return ResponseEntity.ok(withdrawResult);
    }

    /* =====================================================
       내부 유틸: JWT 쿠키로 로그인 유저 조회
       ===================================================== */

    private User getLoginUser(HttpServletRequest request) {
        String token = cookieUtil.get(request, "access_token");
        if (token == null || !jwtUtil.isValidToken(token)) return null;
        return userService.getUserByEmail(jwtUtil.getEmail(token));
    }

    private String getExtension(String originalFilename) {
        if (originalFilename == null || !originalFilename.contains(".")) return "jpg";
        return originalFilename.substring(originalFilename.lastIndexOf('.') + 1).toLowerCase();
    }
}
