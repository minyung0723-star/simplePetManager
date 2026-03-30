package com.project.simplepetmanager.controller;

import com.project.simplepetmanager.common.CookieUtil;
import com.project.simplepetmanager.common.JwtUtil;
import com.project.simplepetmanager.model.dto.User;
import com.project.simplepetmanager.model.service.BoardService;
import com.project.simplepetmanager.model.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Map;

@Controller
@RequestMapping("/board")
@RequiredArgsConstructor
public class BoardViewController {

    private final BoardService boardService;
    private final UserService  userService;
    private final JwtUtil      jwtUtil;
    private final CookieUtil   cookieUtil;

    /**
     * 게시판 목록 페이지
     * - 초기 1페이지 목록을 서버에서 렌더링 (JSTL)
     * - 검색/페이지 변경은 board.js 에서 fetch 후 tbody 교체
     * - 로그인한 유저 번호를 JSP에 전달 (글쓰기/수정/삭제 권한 판단용)
     */
    @GetMapping("/boardList")
    public String boardList(
            @RequestParam(defaultValue = "")    String keyword,
            @RequestParam(defaultValue = "all") String searchType,
            @RequestParam(defaultValue = "")    String category,
            @RequestParam(defaultValue = "1")   int    page,
            @RequestParam(defaultValue = "10")  int    pageSize,
            HttpServletRequest request,
            Model model) {

        // 초기 목록 로드
        Map<String, Object> boardData = boardService.getBoardList(keyword, searchType, category, page, pageSize);
        model.addAttribute("boardList",   boardData.get("list"));
        model.addAttribute("total",       boardData.get("total"));
        model.addAttribute("totalPages",  boardData.get("totalPages"));
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize",    pageSize);
        model.addAttribute("keyword",     keyword);
        model.addAttribute("searchType",  searchType);
        model.addAttribute("category",    category);

        // 로그인 유저 번호 (작성자 본인만 수정/삭제 버튼 노출용)
        String token = cookieUtil.get(request, "access_token");
        if (token != null && jwtUtil.isValidToken(token)) {
            User user = userService.getUserByEmail(jwtUtil.getEmail(token));
            if (user != null) {
                model.addAttribute("myUserNumber", user.getUserNumber());
            }
        }

        return "board/boardList";
    }
}