package com.project.simplepetmanager.model.service;

import com.project.simplepetmanager.model.mapper.BoardMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class BoardService {

    private final BoardMapper boardMapper;

    // 게시글 목록 (검색 + 페이지네이션)
    public Map<String, Object> getBoardList(String keyword, String searchType,
                                            String category, int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        Map<String, Object> param = new HashMap<>();
        param.put("keyword",    keyword);
        param.put("searchType", searchType);
        param.put("category",   category);
        param.put("pageSize",   pageSize);
        param.put("offset",     offset);

        List<Map<String, Object>> list = boardMapper.selectBoardList(param);
        int total      = boardMapper.countBoard(param);
        int totalPages = (int) Math.ceil((double) total / pageSize);

        Map<String, Object> result = new HashMap<>();
        result.put("list",        list);
        result.put("total",       total);
        result.put("totalPages",  totalPages);
        result.put("currentPage", page);
        return result;
    }

    // 게시글 상세
    public Map<String, Object> getBoardDetail(int boardNumber) {
        return boardMapper.selectBoardDetail(boardNumber);
    }

    // 게시글 등록
    public Map<String, Object> insertBoard(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        int rows = boardMapper.insertBoard(param);
        result.put("success", rows > 0);
        result.put("message", rows > 0 ? "게시글이 등록되었습니다." : "게시글 등록에 실패했습니다.");
        return result;
    }

    // 게시글 수정
    public Map<String, Object> updateBoard(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        int rows = boardMapper.updateBoard(param);
        result.put("success", rows > 0);
        result.put("message", rows > 0 ? "게시글이 수정되었습니다." : "수정 권한이 없거나 게시글을 찾을 수 없습니다.");
        return result;
    }

    // 게시글 삭제
    public Map<String, Object> deleteBoard(int boardNumber) {
        Map<String, Object> result = new HashMap<>();
        int rows = boardMapper.deleteBoard(boardNumber);
        result.put("success", rows > 0);
        result.put("message", rows > 0 ? "게시글이 삭제되었습니다." : "삭제에 실패했습니다.");
        return result;
    }
}