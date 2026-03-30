package com.project.simplepetmanager.controller.api;

import com.project.simplepetmanager.common.CookieUtil;
import com.project.simplepetmanager.common.JwtUtil;
import com.project.simplepetmanager.model.dto.User;
import com.project.simplepetmanager.model.service.BoardService;
import com.project.simplepetmanager.model.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/board")
@RequiredArgsConstructor
public class BoardApiController {

    private final BoardService boardService;
    private final UserService  userService;
    private final JwtUtil      jwtUtil;
    private final CookieUtil   cookieUtil;

    /**
     * 게시글 목록 (검색 + 페이지네이션)
     * GET /board/list?keyword=&searchType=all&category=&page=1&pageSize=10
     */
    @GetMapping("/list")
    public ResponseEntity<Map<String, Object>> getBoardList(
            @RequestParam(defaultValue = "")    String keyword,
            @RequestParam(defaultValue = "all") String searchType,
            @RequestParam(defaultValue = "")    String category,
            @RequestParam(defaultValue = "1")   int    page,
            @RequestParam(defaultValue = "10")  int    pageSize) {

        Map<String, Object> result = boardService.getBoardList(keyword, searchType, category, page, pageSize);
        return ResponseEntity.ok(result);
    }

    /**
     * 게시글 상세
     * GET /board/{boardNumber}
     */
    @GetMapping("/{boardNumber}")
    public ResponseEntity<Map<String, Object>> getBoardDetail(@PathVariable int boardNumber) {
        Map<String, Object> result  = new HashMap<>();
        Map<String, Object> board   = boardService.getBoardDetail(boardNumber);

        if (board == null) {
            result.put("success", false);
            result.put("message", "게시글을 찾을 수 없습니다.");
            return ResponseEntity.ok(result);
        }

        result.put("success", true);
        result.put("board",   board);
        return ResponseEntity.ok(result);
    }

    /**
     * 게시글 등록 (로그인 필요)
     * POST /board/write
     * Body: { boardTitle, boardContent, boardCategory }
     */
    @PostMapping("/write")
    public ResponseEntity<Map<String, Object>> insertBoard(
            @RequestBody Map<String, Object> body,
            HttpServletRequest request) {

        Map<String, Object> authResult = getLoginUser(request);
        if (authResult == null) {
            Map<String, Object> err = new HashMap<>();
            err.put("success", false);
            err.put("message", "로그인이 필요합니다.");
            return ResponseEntity.ok(err);
        }

        body.put("userNumber", authResult.get("userNumber"));
        return ResponseEntity.ok(boardService.insertBoard(body));
    }

    /**
     * 게시글 수정 (작성자 본인만)
     * PUT /board/{boardNumber}
     * Body: { boardTitle, boardContent, boardCategory }
     */
    @PutMapping("/{boardNumber}")
    public ResponseEntity<Map<String, Object>> updateBoard(
            @PathVariable int boardNumber,
            @RequestBody  Map<String, Object> body,
            HttpServletRequest request) {

        Map<String, Object> authResult = getLoginUser(request);
        if (authResult == null) {
            Map<String, Object> err = new HashMap<>();
            err.put("success", false);
            err.put("message", "로그인이 필요합니다.");
            return ResponseEntity.ok(err);
        }

        body.put("boardNumber", boardNumber);
        body.put("userNumber",  authResult.get("userNumber"));
        return ResponseEntity.ok(boardService.updateBoard(body));
    }

    /**
     * 게시글 삭제 (작성자 본인만)
     * DELETE /board/{boardNumber}
     */
    @DeleteMapping("/{boardNumber}")
    public ResponseEntity<Map<String, Object>> deleteBoard(
            @PathVariable int boardNumber,
            HttpServletRequest request) {

        Map<String, Object> authResult = getLoginUser(request);
        if (authResult == null) {
            Map<String, Object> err = new HashMap<>();
            err.put("success", false);
            err.put("message", "로그인이 필요합니다.");
            return ResponseEntity.ok(err);
        }

        return ResponseEntity.ok(boardService.deleteBoard(boardNumber));
    }

    /* =====================================================
       내부 유틸: JWT 쿠키로 로그인 유저 조회
       ===================================================== */

    private Map<String, Object> getLoginUser(HttpServletRequest request) {
        String token = cookieUtil.get(request, "access_token");
        if (token == null || !jwtUtil.isValidToken(token)) return null;

        User user = userService.getUserByEmail(jwtUtil.getEmail(token));
        if (user == null) return null;

        Map<String, Object> info = new HashMap<>();
        info.put("userNumber", user.getUserNumber());
        info.put("userEmail",  user.getUserEmail());
        return info;
    }
}
