package com.project.simplepetmanager.model.mapper;

import com.project.simplepetmanager.model.dto.User;
import org.apache.ibatis.annotations.Mapper;

import java.util.Map;

@Mapper
public interface UserMapper {

    // 이메일로 유저 조회 (로그인, JWT 검증)
    User selectUserByEmail(String userEmail);

    // 아이디로 유저 조회
    User selectUserByUserId(String userId);

    // 회원번호로 유저 조회
    User selectUserByUserNumber(int userNumber);

    // 회원가입
    int insertUser(User user);

    // 기본 정보 수정 (이름, 이메일)
    int updateUserInfo(Map<String, Object> param);

    // 비밀번호 변경
    int updatePassword(Map<String, Object> param);

    // 프로필 이미지 경로 저장
    int updateProfileImage(Map<String, Object> param);

    // 회원 탈퇴
    int deleteUser(int userNumber);
}