package com.project.simplepetmanager.model.mapper;


import com.project.simplepetmanager.model.dto.BookMark;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface BookmarkMapper {



   // Bookmark.findByBookmarkId(int bookmarkId);

    List<BookMark> getBookmarkListByUser(int userNumber);

    int checkBookmarkExists(@Param("userNumber") int userNumber,
                            @Param("storeId") int storeId);

    void insertBookmarkList(BookMark bookMark);

    void deleteBookmark(@Param("userNumber") int userNumber,
                        @Param("storeId") int storeId);
    /**
     * todo : 프론트엔드 화면없이 백엔드에서 북마크 확인하기
     *
     *
     * 확인할 endpoint 주소는 총 2가지!
     *
     * http://localhost:8080/api/bookmark/1
     * -> {} 보는 페이지에서 하나의 북마크만 조회 1번 북마크
     *
     *
     *http://localhost:8080/api/bookmarkList
     * -> {} 보는 @RestController 에서 모든 북마크 조회하기
     *
     * 전제조건 : 아직 로그인 유무 고려하지 않음
     * 만들어야할 파일
     * 0. bookmark table에 primary key 로 bookmark_id 추가하기 INTEGER 사용
     * 1. dto/BookMark
     * 2. mapper/BookMark  resources/mappers/bookmarkMapper.xml
     * 3. service/BookmarkService
     * 4. controller/api/BookmarkApiController
     *    -> return bookmarkService.findAllBookmark();
     *     이용해서 모든 븍마크 데이터 조회
     */
}
