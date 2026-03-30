package com.project.simplepetmanager.model.mapper;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface BoardMapper {

    List<Map<String, Object>> selectBoardList(Map<String, Object> param);
    int countBoard(Map<String, Object> param);
    Map<String, Object> selectBoardDetail(int boardNumber);
    int insertBoard(Map<String, Object> param);
    int updateBoard(Map<String, Object> param);
    int deleteBoard(int boardNumber);
}