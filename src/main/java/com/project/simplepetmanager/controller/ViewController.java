package com.project.simplepetmanager.controller;

import com.project.simplepetmanager.model.dto.Board;
import com.project.simplepetmanager.model.service.BoardService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.ui.Model;
import java.util.List;


@Controller
@RequiredArgsConstructor
public class ViewController {

    @GetMapping("/")
    public String indexView(){
        return "index";
    }

    @GetMapping("/user/login")
    public String loginView() {return "user/login";}

    @GetMapping("/user/register")
    public String registerView() {return "user/register";}

    @GetMapping("/user/findUser")
    public String findUserView(){return "user/findUser";}

    @GetMapping("/user/passwordEdit")
    public String passwordEditView(){return "user/passwordEdit";}

    @GetMapping("/mypage/myPage")
    public String mypageView(){return "mypage/myPage";}

    @GetMapping ("/review/reviewPage")
    public String reviewView(){return "review/reviewPage";}

    @GetMapping ("/review/createreviewPage")
    public String createreviewPageView() {return "review/createreviewPage";}

    @GetMapping("/board/boardList")
    public String boardList(){return "board/boardList";}

    private final BoardService boardService; // 추가

    @GetMapping("/board/boardDetail")
    public String boardDetail(Model model) {
        List<Board> boardListData = boardService.findAllBoard();
        model.addAttribute("boardLists", boardListData);
        System.out.println("boardListData: " + boardListData); // ✅ 추가
        if (!boardListData.isEmpty()) {
            model.addAttribute("store", boardListData.get(0));
            System.out.println("store: " + boardListData.get(0)); // ✅ 추가
        }
        return "board/boardDetail";
    }



}
