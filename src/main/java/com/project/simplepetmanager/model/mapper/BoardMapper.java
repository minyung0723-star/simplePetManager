package com.project.simplepetmanager.model.mapper;


import com.project.simplepetmanager.model.dto.Board;

import org.apache.ibatis.annotations.Mapper;


import com.project.simplepetmanager.model.dto.Board;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface BoardMapper {

    // 가게 목록 조회 (boardList용) - 카테고리 / 검색 / 페이징
    List<Board> selectStoreList(
            @Param("category")   String category,
            @Param("searchType") String searchType,
            @Param("keyword")    String keyword,
            @Param("offset")     int offset,
            @Param("pageSize")   int pageSize
    );

    // 전체 건수 (페이지네이션용)
    int countStores(
            @Param("category")   String category,
            @Param("searchType") String searchType,
            @Param("keyword")    String keyword
    );



}

/*

@Mapper
public interface BoardMapper {

    Board addBookMark(int storeId); //xml id 이름
    Board id (int store_id);
    void name(String store_name);
    void address(String store_address);
    void phone (String store_phone);
    void latitude(Double latitude);
    void longitude (Double longitude);
    void insertBookmark(int userNumber, int storeId);
}


 */