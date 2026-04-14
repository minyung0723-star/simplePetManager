package com.project.simplepetmanager.model.mapper;

import com.project.simplepetmanager.model.dto.BookMark;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface BookmarkMapper {

    /**
     * TODO : 유저의 북마크 목록 조회
     *
     * @param userNumber  로그인 유저 번호
     * @return            List<BookMark> — 북마크 패널 카드 렌더링에 사용
     *
     * → bookmarkMapper.xml id="getBookmarkListByUser"
     *   현재 bookmark 테이블만 조회 중 → stores 테이블과 JOIN 해서
     *   store_name, store_address, store_image 를 함께 가져오도록 수정 필요
     */
    List<BookMark> getBookmarkListByUser(int userNumber);

    /**
     * @param userNumber  로그인 유저 번호
     * @param storeId     중복 체크할 가게 PK
     * @return            0 → 즐겨찾기 없음 / 1 이상 → 이미 즐겨찾기 됨
     */
    int checkBookmarkExists(@Param("userNumber") int userNumber,
                            @Param("storeId")    int storeId);

    /**
     * TODO : 북마크 INSERT 쿼리 수정 필요
     *
     * @param bookMark  user_number, storeId 가 담긴 BookMark 객체
     *
     * → bookmarkMapper.xml id="insertBookmarkList"
     *   현재 Store_name, Store_address 를 bookmark 테이블에 직접 저장하고 있음
     *   → user_number, storeid, prefer 만 저장하도록 수정할 것
     *     (가게 정보는 stores 테이블 JOIN 으로 가져오면 됨)
     */
    void insertBookmarkList(BookMark bookMark);

    /**
     * @param userNumber  로그인 유저 번호
     * @param storeId     삭제할 가게 PK
     */
    void deleteBookmark(@Param("userNumber") int userNumber,
                        @Param("storeId")    int storeId);


}