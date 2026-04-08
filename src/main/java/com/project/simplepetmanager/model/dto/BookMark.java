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

}
