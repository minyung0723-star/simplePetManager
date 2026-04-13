package com.project.simplepetmanager.controller.api;

import com.project.simplepetmanager.model.dto.BookMark;
import com.project.simplepetmanager.model.service.BoardService;
import com.project.simplepetmanager.model.service.BookmarkService;
import com.project.simplepetmanager.model.dto.Board;
import lombok.RequiredArgsConstructor;

import org.springframework.ui.Model;
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
        bookMark.setUser_number(userNumber);   // TODO: 인자 채울 것
        bookMark.setStoreId(storeId);       // TODO: 인자 채울 것
        bookmarkService.insertBookmark(bookMark);
        return "ok";
    }

    @DeleteMapping("/api/bookmark/delete")
    public String deleteBookmark(@RequestParam int userNumber,
                                 @RequestParam int storeId) {
        bookmarkService.deleteBookmark(userNumber, storeId);  // TODO: 메서드명 채울 것
        return "ok";
    }

    @GetMapping("/api/bookmark/list")
    public List<BookMark> getBookmarkList(@RequestParam int userNumber) {
        return bookmarkService.findBookMarkListByUser(userNumber);  // TODO: 메서드명 채울 것
    }

    @GetMapping("/board/boardList")
    public String boardList(@RequestParam(defaultValue = "") String category,
                            @RequestParam(defaultValue = "") String keyword,
                            @RequestParam(defaultValue = "all") String searchType,
                            @RequestParam(defaultValue = "1") int page,
                            Model model) {

        int pageSize = 10;
        List<Board> storeList = boardService.findStoreList(category, keyword, searchType, page, pageSize);
        int total = boardService.countStores(category, keyword, searchType);

        model.addAttribute("storeList", storeList);   // ← 카드 목록
        model.addAttribute("total", total);            // ← 총 건수
        model.addAttribute("currentPage", page);       // ← 현재 페이지
        model.addAttribute("pageSize", pageSize);      // ← 페이지당 개수
        model.addAttribute("category", category);      // ← 카테고리 탭
        model.addAttribute("keyword", keyword);        // ← 검색어
        model.addAttribute("searchType", searchType);  // ← 검색 타입

        return "board/boardList";
    }
}