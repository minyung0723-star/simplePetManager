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
    private String category;
    private Double latitude;
     private Double longitude;

    // ======= bookmark Variables ==========
    private int userNumber;
    private int storeId;
    private boolean prefer;

    private String title;
    private String content;
}
