package com.project.simplepetmanager.model.dto;

import lombok.*;
import java.time.LocalDateTime;

@Getter
@Setter
@ToString
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Review {
    private Integer reviewId;      // 리뷰 고유 번호 (PK)
    private Integer storeId;       // 어느 병원의 리뷰인지 (FK)
    private Long userNumber;    // 누가 작성한 리뷰인지 (FK)
    private String category;       // 진료 항목이나 카테고리
    private String reviewContent;  // 리뷰 내용
    private Double rating;         // 별점 점수 (예: 4.5)
    private LocalDateTime createdDate;  // 리뷰가 처음 작성된 시간
    private LocalDateTime modifiedDate; // 리뷰가 수정된 마지막 시간

    // --------------- stores 테이블 JOIN으로 가져오는 정보 --------------------
    private String storeName;       // 가게 이름 (stores JOIN, DB 컬럼 아님)
    private Double averageRating;   // 가게 별점 평균 (집계 쿼리)
    private Integer reviewCount;    // 가게 리뷰 개수 (집계 쿼리)

    // --- 아래는 JOIN을 통해 users 테이블에서 가져오는 정보 ---
    private String nickname;       // 작성자의 닉네임(user_name)
    private String profileImage;   // 작성자의 프로필 이미지
}