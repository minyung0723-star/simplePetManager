package com.project.simplepetmanager.model.mapper;

import com.project.simplepetmanager.model.dto.Board;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface BoardMapper {
    List<Board> getStoreList();


}
