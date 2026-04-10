package com.project.simplepetmanager.model.mapper;

import com.project.simplepetmanager.model.dto.Board;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface BoardMapper {

    List<Board> selectStoreList(
            @Param("category")   String category,
            @Param("searchType") String searchType,
            @Param("keyword")    String keyword,
            @Param("offset")     int offset,
            @Param("pageSize")   int pageSize
    );

    int countStores(
            @Param("category")   String category,
            @Param("searchType") String searchType,
            @Param("keyword")    String keyword
    );

    Board selectStoreById(@Param("storeId") int storeId);  // TODO 채울 것: ___ 에 int 작성
}