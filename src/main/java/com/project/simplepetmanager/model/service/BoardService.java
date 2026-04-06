package com.project.simplepetmanager.model.service;

import com.project.simplepetmanager.model.dto.Board;
import com.project.simplepetmanager.model.mapper.BoardMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;



import java.util.List;

@Service
@RequiredArgsConstructor
public class BoardService {

    private final BoardMapper boardMapper;



    public List<Board> findAllBoard() {
        return boardMapper.getStoreList(); // Mapper에서 연결
    }
    public void addBookmark(int userNumber, int storeId) {
        boardMapper.insertBookmark(userNumber, storeId);
    }
}
