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
                bookMark.getUserNumber(),   // user_number → getUserNumber()
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
        return bookmarkMapper.checkBookmarkExists(userNumber, storeId) > 0;
    }
}

