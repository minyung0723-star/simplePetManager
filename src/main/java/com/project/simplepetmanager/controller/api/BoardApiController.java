package com.project.simplepetmanager.controller.api;

import com.project.simplepetmanager.model.dto.BookMark;
import com.project.simplepetmanager.model.service.BoardService;
import com.project.simplepetmanager.model.service.BookmarkService;
import com.project.simplepetmanager.model.dto.Board;
import lombok.RequiredArgsConstructor;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

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

    //수정한 코드
    @GetMapping("/board/boardList")
    public ModelAndView boardList(@RequestParam(defaultValue = "") String category,
                                  @RequestParam(defaultValue = "") String keyword,
                                  @RequestParam(defaultValue = "all") String searchType,
                                  @RequestParam(defaultValue = "1") int page) {

        int pageSize = 10;
        int offset = (page - 1) * pageSize;  // ← offset 계산

        // ↓ 인자 순서 수정 (category, searchType, keyword 순서)
        List<Board> storeList = boardService.findStoreList(category, searchType, keyword, offset, pageSize);
        int total = boardService.countStores(category, searchType, keyword);

        ModelAndView mav = new ModelAndView("board/boardList");
        mav.addObject("storeList", storeList);
        mav.addObject("total", total);
        mav.addObject("currentPage", page);
        mav.addObject("pageSize", pageSize);
        mav.addObject("category", category);
        mav.addObject("keyword", keyword);
        mav.addObject("searchType", searchType);
        return mav;
    }

    @GetMapping("/board/boardDetail")
    public ModelAndView boardDetail(@RequestParam int storeId) {

        Board store = boardService.findStoreById(storeId);

        ModelAndView mav = new ModelAndView("board/boardDetail");
        mav.addObject("board", store);
        return mav;
    }

}