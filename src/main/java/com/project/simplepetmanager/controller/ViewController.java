package com.project.simplepetmanager.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
@RequiredArgsConstructor
public class ViewController {

    @GetMapping("/")
    public String indexView(){return "index";}

    @GetMapping("/login")
    public String loginView() {return "user/login";}

    @GetMapping("/register")
    public String registerView() {return "user/register";}

    @GetMapping("/findUser")
    public String findUserView(){return "user/findUser";}

    @GetMapping("/passwordEdit")
    public String passwordEditView(){return "user/passwordEdit";}

    //@GetMapping("/mypage/myPage")
    //public String mypageView(){return "mypage/myPage";}

    @GetMapping ("/review/reviewPage")
    public String reviewView(){return "review/reviewPage";}

    @GetMapping ("/review/createreviewPage")
    public String createreviewPageView() {return "review/createreviewPage";}

    @GetMapping("/board/boardList")
    public String boardList(){return "board/boardList";}




}
