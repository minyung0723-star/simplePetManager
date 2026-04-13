package com.project.simplepetmanager.model.dto;

import lombok.*;

@Getter
@Setter
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class BookMark {

    private int storeId;
    private int userNumber;       // user_number → userNumber (camelCase 통일)
    private String storeName;     // StoreName   → storeName
    private String storeAddress;  // StoreAddress → storeAddress
    private String storePhone;    // 추가
    private String storeImage;    // StoreImage  → storeImage
    private String category;      // 추가
    private Double latitude;      // 추가 (지도 이동용)
    private Double longitude;     // 추가 (지도 이동용)
}