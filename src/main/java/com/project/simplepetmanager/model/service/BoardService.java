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

    /**
     * TODO : 가게 단건 조회 서비스 메서드
     *
     * @param storeId  조회할 가게 PK
     * @return         Board 객체 → ViewController 에서 model.addAttribute("store", ...) 로 뷰에 전달
     *
     * → boardMapper.selectStoreById(storeId) 호출
     */

}