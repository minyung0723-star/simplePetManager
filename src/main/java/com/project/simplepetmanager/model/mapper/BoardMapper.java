package com.project.simplepetmanager.model.mapper;

import com.project.simplepetmanager.model.dto.Board;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface BoardMapper {

    List<Board>getStoreList(); //xml id 이름
    Board id (int store_id);
    void name(String store_name);
    void address(String store_address);
    void phone (String store_phone);
    void latitude(Double latitude);
    void longitude (Double longitude);
    void insertBookmark(int userNumber, int storeId);
}
