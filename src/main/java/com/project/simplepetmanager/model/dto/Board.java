package com.project.simplepetmanager.model.dto;

import lombok.*;

@Getter
@Setter
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class Board {
    private int store_id;
    private String store_address;
    private int store_name;
    private String store_image;
    private int store_phone;
    private int category;
    private double latitude;
    private double longitude;

    // ======= bookmark Variables ==========
    private int user_number;
    private int storeId;
    private boolean prefer;


}
