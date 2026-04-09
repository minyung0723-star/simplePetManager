package com.project.simplepetmanager.controller;

import com.project.simplepetmanager.model.dto.Board;
import com.project.simplepetmanager.model.service.BoardService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.ui.Model;

@Controller
@RequiredArgsConstructor
public class ViewController {

    private final BoardService boardService;

    @GetMapping("/")
    public String indexView() { return "index"; }

    @GetMapping("/user/login")
    public String loginView() { return "user/login"; }

    @GetMapping("/user/register")
    public String registerView() { return "user/register"; }

    @GetMapping("/user/findUser")
    public String findUserView() { return "user/findUser"; }

    @GetMapping("/user/passwordEdit")
    public String passwordEditView() { return "user/passwordEdit"; }

    @GetMapping("/mypage/myPage")
    public String mypageView() { return "mypage/myPage"; }

    @GetMapping("/review/reviewPage")
    public String reviewView() { return "review/reviewPage"; }

    @GetMapping("/review/createreviewPage")
    public String createreviewPageView() { return "review/createreviewPage"; }

    @GetMapping("/board/boardList")
    public String boardList(
            @RequestParam(defaultValue = "")    String category,
            @RequestParam(defaultValue = "all") String searchType,
            @RequestParam(defaultValue = "")    String keyword,
            @RequestParam(defaultValue = "1")   int page,
            Model model) {

        int pageSize = 10;
        int offset   = (page - 1) * pageSize;

        model.addAttribute("storeList",   boardService.findStoreList(category, searchType, keyword, offset, pageSize));
        model.addAttribute("total",       boardService.countStores(category, searchType, keyword));
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize",    pageSize);
        model.addAttribute("keyword",     keyword);
        model.addAttribute("category",    category);
        model.addAttribute("searchType",  searchType);

        return "board/boardList";
    }

    /**
     * TODO : 가게 상세 페이지 엔드포인트
     *
     * @param storeId  boardList 카드 클릭 시 전달되는 가게 PK (?storeId=N)
     * @param model    뷰에 전달할 데이터 컨테이너
     * @return         "board/boardDetail" 뷰 이름
     *
     * model 에 담아야 할 것:
     *   - "store"        → boardService.findStoreById(storeId)   (BoardService TODO 참고)
     *   - "loginUser"    → 세션 또는 JWT 에서 꺼낸 로그인 유저 객체
     *                      boardDetail.jsp 의 isLogin 체크에 사용됨
     *   - "isBookmarked" → bookmarkService.checkBookmarkExists(userNumber, storeId) > 0
     *                      상세 진입 시 북마크 버튼 초기 상태(활성/비활성) 설정에 사용됨
     */

}