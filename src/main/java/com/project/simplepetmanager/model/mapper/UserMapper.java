package com.project.simplepetmanager.model.mapper;

import com.project.simplepetmanager.model.dto.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.Map;

@Mapper
public interface UserMapper {

    //회원가입
    void register(User user);

    //이메일 중복체크
    int checkEmail(String userEmail);

    //로그인유저 확인
    User login(String userEmail);

    //로그인 및 사용자 조회
    User findByUserId(String userId);

    // 아이디 찾기
    String findId(String userName, String userEmail);

    // 비밀번호 찾기용 사용자 검증
    int verifyPw(String userId, String userEmail);

    // 비밀번호 업데이트
    int updatePassword(String userId, String userPassword);

    // 이메일로 유저 조회
    User findByUserEmail(String userEmail);

    // 기본 정보 수정 (이름, 이메일)
    int updateUserInfo(Map<String, Object> param);

    // 프로필 이미지 수정
    int updateProfileImage(Map<String, Object> param);

    // 회원 탈퇴
    int deleteUser(long userNumber);
}