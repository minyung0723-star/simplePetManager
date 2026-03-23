package com.project.simplepetmanager.controller.view;


import com.project.simplepetmanager.model.service.BoardService;
import lombok.RequiredArgsConstructor;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequiredArgsConstructor
public class BoardViewController {

    private final BoardService boardService;

    @GetMapping("/")
    public String indexView(){
        return "index";
    }

    @GetMapping("/user/login") //로그인페이지 이동
    public Board (@RequestBody Board board){
        BoardViewController
        return "login";
    }
}
