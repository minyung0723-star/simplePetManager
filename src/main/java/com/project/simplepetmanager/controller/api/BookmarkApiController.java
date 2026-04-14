package com.project.simplepetmanager.controller.api;

import com.project.simplepetmanager.model.dto.Board;
import com.project.simplepetmanager.model.dto.BookMark;
import com.project.simplepetmanager.model.service.BookmarkService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/bookmarkApiController")
public class BookmarkApiController {

    private final BookmarkService bookmarkService;

    // 즐겨찾기 목록 조회
    @GetMapping
    public ResponseEntity<List<BookMark>> getBookmarkList(
            @RequestParam int userNumber) {

        List<BookMark> bookmarkList = bookmarkService.findBookMarkListByUser(userNumber);
        return ResponseEntity.ok(bookmarkList);
    }

    // 즐겨찾기 추가
    @PostMapping
    public ResponseEntity<String> addBookmark(@RequestBody BookMark bookMark) {
        bookmarkService.insertBookmark(bookMark);
        return ResponseEntity.ok("즐겨찾기 추가 완료");
    }

    // 즐겨찾기 삭제
    @DeleteMapping("/{storeId}")
    public ResponseEntity<String> deleteBookmark(
            @RequestParam int userNumber,
            @PathVariable int storeId) {

        bookmarkService.deleteBookmark(userNumber, storeId);
        return ResponseEntity.ok("즐겨찾기 삭제 완료");
    }


}
