package com.project.simplepetmanager.controller.api;

import com.project.simplepetmanager.model.dto.BookMark;
import com.project.simplepetmanager.model.service.BoardService;
import com.project.simplepetmanager.model.service.BookmarkService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RequiredArgsConstructor
@RestController
public class BoardApiController {

    private final BoardService boardService;
    private final BookmarkService bookmarkService;

    @PostMapping("/api/bookmark/add")
    public String addBookmark(@RequestParam int userNumber,
                              @RequestParam int storeId) {
        BookMark bookMark = new BookMark();
        bookMark.setUser_number(___);   // TODO: 인자 채울 것
        bookMark.setStoreId(___);       // TODO: 인자 채울 것
        bookmarkService.insertBookmark(bookMark);
        return "ok";
    }

    @DeleteMapping("/api/bookmark/delete")
    public String deleteBookmark(@RequestParam int userNumber,
                                 @RequestParam int storeId) {
        bookmarkService.___(userNumber, storeId);  // TODO: 메서드명 채울 것
        return "ok";
    }

    @GetMapping("/api/bookmark/list")
    public List<BookMark> getBookmarkList(@RequestParam int userNumber) {
        return bookmarkService.___(userNumber);  // TODO: 메서드명 채울 것
    }
}