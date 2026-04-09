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
        model.addAttribute("category",    category);
        model.addAttribute("searchType",  searchType);
        model.addAttribute("keyword",     keyword);

        return "board/boardList";
    }

}