package com.project.simplepetmanager.controller.api;

import com.project.simplepetmanager.model.dto.BookMark;
import com.project.simplepetmanager.model.service.BookmarkService;
import lombok.RequiredArgsConstructor;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 즐겨찾기 관련 REST API 만 담당
 * @RestController → JSON 응답 전용
 * 뷰(JSP) 렌더링이 필요한 boardList, boardDetail 은 BoardViewController 로 분리
 */
@RequiredArgsConstructor
@RestController
public class BoardApiController {

    private final BookmarkService bookmarkService;

    /**
     * 즐겨찾기 토글
     * POST /api/bookmark/add
     * 응답: { "bookmarked": true/false }
     */
    @PostMapping("/api/bookmark/add")
    public ResponseEntity<Map<String, Object>> toggleBookmark(
            @RequestParam int userNumber,
            @RequestParam int storeId) {

        boolean isBookmarked = bookmarkService.confirmBookmark(userNumber, storeId);

        if (isBookmarked) {
            bookmarkService.deleteBookmark(userNumber, storeId);
        } else {
            BookMark bookMark = new BookMark();
            bookMark.setUserNumber(userNumber);
            bookMark.setStoreId(storeId);
            bookmarkService.insertBookmark(bookMark);
        }

        Map<String, Object> result = new HashMap<>();
        result.put("bookmarked", !isBookmarked);
        return ResponseEntity.ok(result);
    }

    /** 즐겨찾기 삭제 */
    @DeleteMapping("/api/bookmark/delete")
    public ResponseEntity<String> deleteBookmark(
            @RequestParam int userNumber,
            @RequestParam int storeId) {
        bookmarkService.deleteBookmark(userNumber, storeId);
        return ResponseEntity.ok("즐겨찾기 삭제 완료");
    }

    /** 즐겨찾기 목록 조회 */
    @GetMapping("/api/bookmark/list")
    public List<BookMark> getBookmarkList(@RequestParam int userNumber) {
        return bookmarkService.findBookMarkListByUser(userNumber);
    }
}
