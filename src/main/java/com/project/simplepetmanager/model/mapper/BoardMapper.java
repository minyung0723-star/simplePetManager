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


    /**
     * TODO : 가게 상세 단건 조회
     *
     * @param storeId  조회할 가게 PK (stores.store_id)
     * @return         해당 가게의 Board 객체 (없으면 null)
     *
     * → boardMapper.xml 에 id="selectStoreById" 쿼리 작성 필요
     */

}