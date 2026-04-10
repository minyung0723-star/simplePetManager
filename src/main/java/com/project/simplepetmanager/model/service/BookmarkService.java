package com.project.simplepetmanager.model.service;

import com.project.simplepetmanager.model.dto.BookMark;
import com.project.simplepetmanager.model.mapper.BookmarkMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class BookmarkService {

    private final BookmarkMapper bookmarkMapper;

    public List<BookMark> findBookMarkListByUser(int userNumber) {
        return bookmarkMapper.getBookmarkListByUser(userNumber);
    }

    public void insertBookmark(BookMark bookMark) {
        int exists = bookmarkMapper.checkBookmarkExists(
                bookMark.getUser_number(),
                bookMark.getStoreId()
        );
        if (exists == 0) {
            bookmarkMapper.insertBookmarkList(bookMark);
        }
    }

    public void deleteBookmark(int userNumber, int storeId) {
        bookmarkMapper.deleteBookmark(userNumber, storeId);
    }

    public boolean confirmBookmark(int userNumber, int storeId) {
        int confirm = bookmarkMapper.checkBookmarkExists(userNumber, storeId);
        if (confirm > 0) {
            return true;
        } else {
            return false;
        }
    }}



    /**
     * TODO : 북마크 존재 여부를 boolean 으로 반환하는 래퍼 메서드
     *
     * @param userNumber  로그인 유저 번호
     * @param storeId     확인할 가게 PK
     * @return            true → 이미 즐겨찾기 됨 / false → 즐겨찾기 안 됨
     *
     * → bookmarkMapper.checkBookmarkExists(userNumber, storeId) > 0
     *   BoardApiController 토글 API(TODO) 와 ViewController(TODO) 에서 사용
     */

