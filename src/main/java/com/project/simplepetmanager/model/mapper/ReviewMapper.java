package com.project.simplepetmanager.model.mapper;

import com.project.simplepetmanager.model.dto.Board;
import com.project.simplepetmanager.model.dto.Review;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper

/**
 * [MyBatis Mapper 인터페이스]
 * 1. 실무 로직(SQL)은 'reviewMapper.xml'에 작성되어 있습니다.
 * 2. 자바(Service)에서 호출할 메서드 이름만 선언한 '리모컨' 역할을 합니다.
 * 3. MyBatis가 이 인터페이스를 읽어 실제 SQL 실행 객체를 자동으로 생성합니다.
 */
public interface ReviewMapper {

    /**
     * 리뷰 등록 (XML의 id="insertReview"와 연결됨)
     * @param review 등록할 리뷰 데이터가 담긴 DTO
     */
    void insertReview(Review review);

    /**
     * 특정 병원의 리뷰 목록 조회 (XML의 id="getReviewList"와 연결됨)
     * @param storeId 조회할 병원 번호
     * @return 작성자 정보(닉네임, 사진)가 포함된 리뷰 리스트
     */
    List<Review> getReviewList(int storeId);

    /**
     * 북마크 체크, 추가, 삭제
     */
    int checkBookmark(@Param("userNumber") long userNumber, @Param("storeId") long storeId);
    void insertBookmark(@Param("userNumber") long userNumber, @Param("storeId") long storeId);
    void deleteBookmark(@Param("userNumber") long userNumber, @Param("storeId") long storeId);
    Board getStoreDetail(int storeId);

}