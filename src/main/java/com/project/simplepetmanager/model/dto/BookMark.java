package com.project.simplepetmanager.model.dto;

import lombok.*;

@Getter
@Setter
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class BookMark {

    private int storeId;
    private int user_number;
    private String Store_name;
    private String Store_address;

    // TODO 5 : 북마크 패널 카드에 이미지를 보여주려면 store_image 필드 추가
    // bookmarkMapper.xml getBookmarkListByUser 쿼리에서 stores 테이블과 JOIN 해서 가져와야 함 (TODO 7 참고)
    //
    // private String storeImage;

}