package com.project.simplepetmanager.model.dto;

import lombok.*;

import java.time.LocalDateTime;

@Getter @Setter @ToString @AllArgsConstructor @NoArgsConstructor
public class User {
    private Long userNumber;            //회원번호
    private String userId;              //회원아이디
    private String userPassword;        //회원비밀번호
    private String userName;            //회원이름
    private String userEmail;           //회원이메일
    private LocalDateTime createdDate;  //생성일
    private LocalDateTime modifiedDate; //수정일
    private String profileImage;        //프로필이미지
    private String imageUrl;            //이미지경로
}