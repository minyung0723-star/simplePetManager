package com.project.simplepetmanager.controller;

import com.project.simplepetmanager.common.CookieUtil;
import com.project.simplepetmanager.common.JwtUtil;
import com.project.simplepetmanager.model.dto.Board;
import com.project.simplepetmanager.model.dto.BookMark;
import com.project.simplepetmanager.model.dto.User;
import com.project.simplepetmanager.model.service.BoardService;
import com.project.simplepetmanager.model.service.BookmarkService;
import com.project.simplepetmanager.model.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

/**
 * 게시판 뷰(JSP) 렌더링 전담 컨트롤러
 * - @Controller 사용 → ModelAndView 정상 렌더링
 * - @RestController 에 ModelAndView 를 쓰면 JSON 직렬화 시도 → 400 에러 발생하므로 분리
 */
@Controller
@RequiredArgsConstructor
public class BoardViewController {

    private final BoardService    boardService;
    private final BookmarkService bookmarkService;
    private final UserService     userService;
    private final JwtUtil         jwtUtil;
    private final CookieUtil      cookieUtil;

    /**
     * 가게 목록 페이지
     * GET /board/boardList
     */
    @GetMapping("/board/boardList")
    public ModelAndView boardList(
            @RequestParam(defaultValue = "") String category,
            @RequestParam(defaultValue = "") String keyword,
            @RequestParam(defaultValue = "all") String searchType,
            @RequestParam(defaultValue = "1") int page) {

        int pageSize = 10;
        int offset   = (page - 1) * pageSize;

        List<Board> storeList = boardService.findStoreList(category, searchType, keyword, offset, pageSize);
        int total             = boardService.countStores(category, searchType, keyword);

        ModelAndView mav = new ModelAndView("board/boardList");
        mav.addObject("storeList",   storeList);
        mav.addObject("total",       total);
        mav.addObject("currentPage", page);
        mav.addObject("pageSize",    pageSize);
        mav.addObject("category",    category);
        mav.addObject("keyword",     keyword);
        mav.addObject("searchType",  searchType);
        return mav;
    }

    /**
     * 가게 상세 페이지
     * GET /board/boardDetail?storeId=1
     * - JWT 쿠키로 로그인 유저 확인
     * - loginUser 를 model 에 담아야 JSP 에서 ${loginUser.userNumber} 사용 가능
     * - isBookmarked 도 함께 전달하여 초기 별 상태 결정
     */
    @GetMapping("/board/boardDetail")
    public ModelAndView boardDetail(@RequestParam int storeId,
                                    HttpServletRequest request) {

        Board store = boardService.findStoreById(storeId);

        ModelAndView mav = new ModelAndView("board/boardDetail");
        mav.addObject("board", store);

        String token = cookieUtil.get(request, "access_token");
        if (token != null && jwtUtil.isValidToken(token)) {
            try {
                User loginUser       = userService.getUserByEmail(jwtUtil.getEmail(token));
                boolean isBookmarked = bookmarkService.confirmBookmark(
                        loginUser.getUserNumber(), storeId);

                // 즐겨찾기 목록 조회 후 모델에 추가
                // Bookmarkpopup.jsp 의 ${bookmarkList} 렌더링에 사용
                List<BookMark> bookmarkList = bookmarkService.findBookMarkListByUser(loginUser.getUserNumber());

                mav.addObject("loginUser",    loginUser);
                mav.addObject("isBookmarked", isBookmarked);
                mav.addObject("bookmarkList", bookmarkList);
            } catch (Exception e) {
                // loginUser 를 model 에 넣지 않으면 JSP ${loginUser.userNumber} 가 빈 문자열로
                // 렌더링되어 /api/bookmark/add 호출 시 userNumber="" → Spring 타입 변환 실패(400)
                // → 예외 발생 시에도 반드시 loginUser 를 null 이 아닌 빈 객체 대신 아예 제외하고,
                //   JSP <c:when test="${not empty loginUser}"> 가 false 가 되도록 유지한다.
                //   단, 토큰은 유효했으므로 재조회 시도 없이 비로그인 상태로 폴백.
                mav.addObject("isBookmarked", false);
            }
        } else {
            mav.addObject("isBookmarked", false);
        }

        return mav;
    }
}