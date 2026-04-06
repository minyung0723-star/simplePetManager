package com.project.simplepetmanager.model.service;

import com.project.simplepetmanager.model.dto.Board;
import com.project.simplepetmanager.model.dto.Review;
import com.project.simplepetmanager.model.mapper.ReviewMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class ReviewService {


    private final ReviewMapper reviewMapper; // 외부에서 함부로 조작 못하게 private으로 선언!

    /**
     * 새로운 리뷰를 등록하는 기능 (public: 컨트롤러가 호출 가능)
     * @param review 사용자가 입력한 데이터가 담긴 바구니
     */
    public void registerReview(Review review) {
        // 나중에 "이미 리뷰를 쓴 사용자인지 확인" 같은 로직이 들어올 수 잇음.
        reviewMapper.insertReview(review);
    }

    /**
     * 특정 병원의 리뷰 목록을 가져오는 기능 (public: 컨트롤러가 호출 가능)
     * @param storeId 병원 번호
     * @return 작성자 정보가 포함된 리뷰 리스트
     */
    public List<Review> getReviewList(int storeId) {
        return reviewMapper.getReviewList(storeId);
    }


    public String toggleBookmark(long userNumber, long storeId) {

        int count = reviewMapper.checkBookmark(userNumber, storeId);

        if (count == 0) {
            reviewMapper.insertBookmark(userNumber, storeId);
            return "inserted";
        } else {
            reviewMapper.deleteBookmark(userNumber, storeId);
            return "deleted";
        }
    }

    // 2. [추가] 컨트롤러가 "이거 찜 되어 있어?"라고 물어볼 때 답해줄 메서드!
    public int checkBookmark(long userNumber, long storeId) {
        // 매퍼에게 직접 물어봐서 결과를 리턴해줍니다.
        return reviewMapper.checkBookmark(userNumber, storeId);
    }
    /**
     * 특정 병원(가게)의 상세 정보를 가져오는 서비스
     * @param storeId 병원 아이디
     * @return Board 객체 (병원 이름, 주소 등 포함)
     */
    public Board getStoreDetail(int storeId) {
        // 매퍼에게 DB에서 데이터를 가져오라고 시킵니다.
        return reviewMapper.getStoreDetail(storeId);
    }
}