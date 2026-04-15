package com.project.simplepetmanager.controller.api;

import com.project.simplepetmanager.common.CookieUtil;
import com.project.simplepetmanager.common.JwtUtil;
import com.project.simplepetmanager.model.dto.BookMark;
import com.project.simplepetmanager.model.dto.User;
import com.project.simplepetmanager.model.service.BookmarkService;
import com.project.simplepetmanager.model.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/bookmarkApiController")
public class BookmarkApiController {

    private final BookmarkService bookmarkService;
    private final UserService     userService;
    private final JwtUtil         jwtUtil;
    private final CookieUtil      cookieUtil;

    /**
     * 즐겨찾기 목록 조회
     * ★ 수정: userNumber를 파라미터로 받지 않고 JWT에서 직접 추출
     *         → 타인의 북마크를 조회하는 보안 취약점 차단
     */
    @GetMapping
    public ResponseEntity<?> getBookmarkList(HttpServletRequest request) {
        User loginUser = getLoginUser(request);
        if (loginUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }
        List<BookMark> bookmarkList = bookmarkService.findBookMarkListByUser(loginUser.getUserNumber());
        return ResponseEntity.ok(bookmarkList);
    }

    /**
     * 즐겨찾기 추가
     * ★ 수정: JWT에서 userNumber 추출하여 강제 세팅 (클라이언트 값 무시)
     */
    @PostMapping
    public ResponseEntity<String> addBookmark(@RequestBody BookMark bookMark,
                                              HttpServletRequest request) {
        User loginUser = getLoginUser(request);
        if (loginUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }
        bookMark.setUserNumber(loginUser.getUserNumber()); // 클라이언트 값 덮어쓰기
        bookmarkService.insertBookmark(bookMark);
        return ResponseEntity.ok("즐겨찾기 추가 완료");
    }

    /**
     * 즐겨찾기 삭제
     * ★ 수정: JWT에서 userNumber 추출
     */
    @DeleteMapping("/{storeId}")
    public ResponseEntity<String> deleteBookmark(@PathVariable long storeId,
                                                 HttpServletRequest request) {
        User loginUser = getLoginUser(request);
        if (loginUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }
        bookmarkService.deleteBookmark(loginUser.getUserNumber(), storeId);
        return ResponseEntity.ok("즐겨찾기 삭제 완료");
    }

    /* ── 내부 유틸 ── */
    private User getLoginUser(HttpServletRequest request) {
        String token = cookieUtil.get(request, "access_token");
        if (token == null || !jwtUtil.isValidToken(token)) return null;
        return userService.getUserByEmail(jwtUtil.getEmail(token));
    }
}