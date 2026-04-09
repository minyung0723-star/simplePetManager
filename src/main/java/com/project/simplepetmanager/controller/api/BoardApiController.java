package com.project.simplepetmanager.controller.api;


import com.project.simplepetmanager.model.dto.Board;

import com.project.simplepetmanager.model.service.BoardService;
import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RequiredArgsConstructor
@RestController
public class BoardApiController {

    // ✅ BoardService를 필드로 선언 → @RequiredArgsConstructor가 생성자 주입 자동 처리
    private final BoardService boardService;


/*
    @GetMapping("/api/board/boardDetail")
    public String detailPage(Model model) {

        // ✅ 인스턴스(boardService)를 통해 메서드 호출
        List<Board> boardListData = boardService.findAllBoard();

        model.addAttribute("boardLists", boardListData);

        System.out.println("데이터 개수: " + boardListData.size()); // ← 추가
        System.out.println("데이터 내용: " + boardListData);

        // ✅ 첫 번째 store의 위도/경도를 꺼내서 따로 담기
        if (!boardListData.isEmpty()) {
            model.addAttribute("store", boardListData.get(0));
        }else {
            System.out.println("boardListData가 비어있음"); // ✅ 추가
        }


        return "board/boardDetail";
    }

    @PostMapping("/api/bookmark/add")
    @ResponseBody
    public String addBookmark(@RequestParam int userNumber,
                              @RequestParam int storeId) {

        boardService.addBookmark(userNumber, storeId);

        return "ok";
    }

 */
}