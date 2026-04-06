package com.project.simplepetmanager.model.mapper;

import com.project.simplepetmanager.model.dto.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

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
    int updatePassword (String userId, String userPassword);
}
