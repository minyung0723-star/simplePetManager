package com.project.simplepetmanager.model.service;

import com.project.simplepetmanager.model.dto.Board;
import com.project.simplepetmanager.model.dto.BookMark;
import com.project.simplepetmanager.model.mapper.BookmarkMapper;
import jakarta.mail.Store;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.GetMapping;

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

        if (exists == 0) {  // 중복 아닐 때만 추가
            bookmarkMapper.insertBookmarkList(bookMark);
        }
    }

    public void deleteBookmark(int userNumber, int storeId) {
        bookmarkMapper.deleteBookmark(userNumber, storeId);
    }


}
