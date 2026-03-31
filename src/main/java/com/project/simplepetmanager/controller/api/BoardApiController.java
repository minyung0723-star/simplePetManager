package com.project.simplepetmanager.controller.api;

import com.project.simplepetmanager.model.mapper.BoardMapper;
import com.project.simplepetmanager.model.dto.Board;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class BoardApiController {

    private BoardMapper boardMapper;
    @Autowired

    @GetMapping("/board/detail")
    public String detailPage(Model model) {

       // System.out.println("=== 컨트롤러 진입 ==="); // ← 맨 위에 추가

        List<Board> storeList = boardMapper.getStoreList();
     //   System.out.println("조회된 데이터 수: " + storeList.size());

        model.addAttribute("stores", storeList);
        return "board/boardDetail";
    }


}