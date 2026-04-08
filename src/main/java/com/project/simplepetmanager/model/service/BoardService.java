package com.project.simplepetmanager.model.service;

import com.project.simplepetmanager.model.dto.Board;
import com.project.simplepetmanager.model.mapper.BoardMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;




@Service
@RequiredArgsConstructor
public class BoardService {

    private final BoardMapper boardMapper;


    // 하나의 데이터 가져오기 상세페이지 이동 참조



    public Board findBoardByBoardId(int user_number){

      return boardMapper.addBookMark(user_number);  // boardMapper 에 매개변수로 storeId를 전달하여 1번에 저장된 가게 데이터 반환하기

    }
    public void addBookmark(int userNumber, int storeId) {
        boardMapper.insertBookmark(userNumber, storeId);
    }
}
