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
    private String StoreName;       // TODO: Store_name → 올바른 camelCase 필드명으로
    private String StoreAddress;       // TODO: Store_address → 올바른 camelCase 필드명으로
    private String StoreImage;       // TODO: store_image → 올바른 camelCase 필드명으로
}