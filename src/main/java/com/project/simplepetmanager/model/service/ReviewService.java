package com.project.simplepetmanager.model.service;

import com.project.simplepetmanager.model.mapper.ReviewMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class ReviewService {

    private final ReviewMapper reviewMapper;

    private final String UPLOAD_PATH = System.getProperty("user.dir") + "/uploads/";

    // 리뷰 목록 (검색 + 페이지네이션)
    public Map<String, Object> getReviewList(String keyword, int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        Map<String, Object> param = new HashMap<>();
        param.put("keyword",  keyword);
        param.put("pageSize", pageSize);
        param.put("offset",   offset);

        List<Map<String, Object>> list = reviewMapper.selectReviewList(param);
        int total      = reviewMapper.countReview(param);
        int totalPages = (int) Math.ceil((double) total / pageSize);

        Map<String, Object> result = new HashMap<>();
        result.put("list",        list);
        result.put("total",       total);
        result.put("totalPages",  totalPages);
        result.put("currentPage", page);
        return result;
    }

    // 특정 유저가 작성한 리뷰 목록 (마이페이지 서버사이드 렌더링용)
    public List<Map<String, Object>> getReviewsByUserNumber(int userNumber) {
        return reviewMapper.selectReviewsByUserNumber(userNumber);
    }

    // 리뷰 등록
    public Map<String, Object> insertReview(Map<String, Object> param, MultipartFile file) {
        Map<String, Object> result = new HashMap<>();
        if (file != null && !file.isEmpty()) {
            try {
                File dir = new File(UPLOAD_PATH + "review/");
                if (!dir.exists()) dir.mkdirs();
                String ext      = file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf("."));
                String filename = UUID.randomUUID() + ext;
                file.transferTo(new File(dir, filename));
                param.put("reviewImage", filename);
                param.put("imageUrl",    "/uploads/review/" + filename);
            } catch (IOException e) {
                log.error("리뷰 이미지 업로드 실패", e);
            }
        }
        int rows = reviewMapper.insertReview(param);
        result.put("success", rows > 0);
        result.put("message", rows > 0 ? "리뷰가 등록되었습니다." : "리뷰 등록에 실패했습니다.");
        return result;
    }

    // 리뷰 삭제
    public Map<String, Object> deleteReview(int reviewNumber) {
        Map<String, Object> result = new HashMap<>();
        int rows = reviewMapper.deleteReview(reviewNumber);
        result.put("success", rows > 0);
        result.put("message", rows > 0 ? "리뷰가 삭제되었습니다." : "삭제에 실패했습니다.");
        return result;
    }
}