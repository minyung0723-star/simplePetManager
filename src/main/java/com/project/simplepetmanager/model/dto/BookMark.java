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
    private String ___;       // TODO: Store_name → 올바른 camelCase 필드명으로
    private String ___;       // TODO: Store_address → 올바른 camelCase 필드명으로
    private String ___;       // TODO: store_image → 올바른 camelCase 필드명으로
}