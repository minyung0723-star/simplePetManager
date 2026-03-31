package com.project.simplepetmanager.model.dto;

import lombok.*;

@Getter
@Setter
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class Board {



    private String storeImage;
    private String storeName;
    private String storePhone;
    private String storeAddress;
    private int category;
    private double latitude;
    private double longitude;

    // ======= bookmark Variables ==========
    private int userNumber;
    private int storeId;
    private boolean prefer;


}
