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

    public List<Board> findStoreList(String category, String searchType, String keyword, int offset, int pageSize) {
        return boardMapper.selectStoreList(category, searchType, keyword, offset, pageSize);
    }

    public int countStores(String category, String searchType, String keyword) {
        return boardMapper.countStores(category, searchType, keyword);
    }

    public Board findStoreById(int storeId) {
        return boardMapper.selectStoreById(storeId);  // TODO: 메서드명과 인자 채울 것
    }
}