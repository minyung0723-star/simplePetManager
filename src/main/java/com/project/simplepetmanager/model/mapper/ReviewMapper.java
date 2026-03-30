package com.project.simplepetmanager.model.mapper;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface ReviewMapper {

    List<Map<String, Object>> selectReviewList(Map<String, Object> param);
    int countReview(Map<String, Object> param);
    Map<String, Object> selectReviewDetail(int reviewNumber);

    // 마이페이지 서버사이드 렌더링용 - 특정 유저의 리뷰 전체
    List<Map<String, Object>> selectReviewsByUserNumber(int userNumber);

    int insertReview(Map<String, Object> param);
    int updateReview(Map<String, Object> param);
    int deleteReview(int reviewNumber);
}