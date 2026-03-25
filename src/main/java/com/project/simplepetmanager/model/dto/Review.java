package com.project.simplepetmanager.model.dto;

import lombok.*;

@Getter @Setter @ToString @AllArgsConstructor @NoArgsConstructor
public class Review {
    /**
     * 리뷰페이지
     */
    private Integer reviewId;
    private String reviewContent;
    private int rating;
    
}
