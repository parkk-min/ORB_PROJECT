package com.example.ouroboros.data.dao;

import com.example.ouroboros.data.entity.UsedWordsEntity;
import com.example.ouroboros.data.repository.UsedWordsRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UsedWordsDAO {
    private final UsedWordsRepository usedWordsRepository;


    // 단어가 사용자에 의해 이미 사용되었는지 확인
    public boolean existsByWordAndUser_Username(String word, String username) {
        return usedWordsRepository.existsByWordAndUser_Username(word, username);
    }

    // 사용자가 사용한 단어 기록 중 가장 최신 기록을 조회
    public UsedWordsEntity findTopByUser_UsernameOrderByIdDesc(String username) {
        return usedWordsRepository.findTopByUser_UsernameOrderByIdDesc(username);
    }

    // 새 기록 추가 및 수정
    public void save(UsedWordsEntity usedWordsEntity) {
        usedWordsRepository.save(usedWordsEntity);
    }

    // 사용자의 사용 기록 전부 삭제
    public void deleteByUser_Username(String username) {
        usedWordsRepository.deleteByUser_Username(username);
    }

    public List<UsedWordsEntity> findAllByUser_Username(String username) {
        return usedWordsRepository.findAllByUser_Username(username);
    }
}

