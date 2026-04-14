package com.project.simplepetmanager.model.mapper;

import com.project.simplepetmanager.model.dto.Board;
import com.project.simplepetmanager.model.dto.Review;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface ReviewMapper {

    // ===================== 리뷰 =====================

    /** 특정 병원 리뷰 목록 조회 */
    List<Review> getReviewList(int storeId);

    /** 마이페이지 - 내가 작성한 리뷰 목록 조회 */
    List<Map<String, Object>> getReviewsByUserNumber(long userNumber);

    /** 단건 리뷰 조회 (수정·삭제 전 본인 확인용) */
    Review getReviewById(int reviewId);

    /** 리뷰 등록 */
    int registerReview(Review review);

    /** 리뷰 수정 (본인 확인은 WHERE user_number 조건으로 DB 레벨에서 처리) */
    int updateReview(Review review);

    /** 리뷰 삭제 */
    int deleteReview(int reviewId);

    // ===================== 북마크 =====================

    /** 북마크 등록 여부 확인 */
    int checkBookmark(@Param("userNumber") long userNumber, @Param("storeId") long storeId);

    /** 북마크 등록 */
    void insertBookmark(@Param("userNumber") long userNumber, @Param("storeId") long storeId);

    /** 북마크 삭제 */
    void deleteBookmark(@Param("userNumber") long userNumber, @Param("storeId") long storeId);

    // ===================== 병원 정보 =====================

    /** 병원(가게) 상세 정보 조회 */
    Board getStoreDetail(int storeId);
}