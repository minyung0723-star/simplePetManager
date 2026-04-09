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

    // TODO 8 : BookmarkService 주입 추가
    // 북마크 추가/삭제/조회 API 를 이 컨트롤러에서 처리하려면 아래 주석 해제
    //
    //  private final BookmarkService bookmarkService;
     private final BookmarkService bookmarkService;


    // TODO 9 : 북마크 추가 API
    // boardDetail.jsp 의 addBookmark() 함수가 POST /api/bookmark/add 를 호출하고 있음
    // BookmarkService.insertBookmark() 와 연결해야 실제로 DB 에 저장됨
    // 중복 체크는 BookmarkService 내부에서 이미 처리하고 있음 (checkBookmarkExists)
    //
    // @PostMapping("/api/bookmark/add")
    // public String addBookmark(@RequestParam int userNumber,
    //                           @RequestParam int storeId) {
    //     BookMark bookMark = new BookMark();
    //     bookMark.setUser_number(userNumber);
    //     bookMark.setStoreId(storeId);
    //     bookmarkService.insertBookmark(bookMark);
    //     return "ok";
    // }


    // TODO 10 : 북마크 삭제 API (하트 토글 해제)
    // 상세페이지에서 이미 북마크된 가게를 다시 클릭하면 삭제되어야 함
    //
    // @DeleteMapping("/api/bookmark/delete")
    // public String deleteBookmark(@RequestParam int userNumber,
    //                              @RequestParam int storeId) {
    //     bookmarkService.deleteBookmark(userNumber, storeId);
    //     return "ok";
    // }


    // TODO 11 : 북마크 목록 조회 API (북마크 패널용)
    // boardDetail.jsp 의 북마크 패널에서 유저의 즐겨찾기 목록을 불러올 때 사용
    // 반환된 리스트를 JS 에서 받아 .bookmark-list 에 카드로 렌더링해야 함
    //
    // @GetMapping("/api/bookmark/list")
    // public List<BookMark> getBookmarkList(@RequestParam int userNumber) {
    //     return bookmarkService.findBookMarkListByUser(userNumber);
    // }


    // TODO 12 : 북마크 토글 API (추가/삭제 한 번에 처리)
    // TODO 9, 10 을 별도로 두지 않고 토글 방식으로 합칠 수 있음
    // checkBookmarkExists 로 존재 여부 확인 후 있으면 삭제, 없으면 추가
    //
    // @PostMapping("/api/bookmark/toggle")
    // public String toggleBookmark(@RequestParam int userNumber,
    //                              @RequestParam int storeId) {
    //     boolean exists = bookmarkService.checkBookmarkExists(userNumber, storeId);
    //     if (exists) {
    //         bookmarkService.deleteBookmark(userNumber, storeId);
    //         return "deleted";
    //     } else {
    //         BookMark bookMark = new BookMark();
    //         bookMark.setUser_number(userNumber);
    //         bookMark.setStoreId(storeId);
    //         bookmarkService.insertBookmark(bookMark);
    //         return "added";
    //     }
    // }

}