package com.example.ouroboros.service;

import com.example.ouroboros.data.entity.UsedWordsEntity;
import com.example.ouroboros.data.entity.WordsEntity;
import com.example.ouroboros.data.repository.UsedWordsRepository;
import com.example.ouroboros.data.repository.UserRepository;
import com.example.ouroboros.data.repository.WordsRepository;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class UsedWordsService {

    private final WordsRepository wordsRepository;
    private final UsedWordsRepository usedWordsRepository;
    private final UserRepository userRepository;

    // 생성자 주입
    public UsedWordsService(WordsRepository wordsRepository,
                            UsedWordsRepository usedWordsRepository,
                            UserRepository userRepository) {
        this.wordsRepository = wordsRepository;
        this.usedWordsRepository = usedWordsRepository;
        this.userRepository = userRepository;
    }

    // 실제 끝말잇기 게임 로직 메서드
    // 사용자가 입력한 단어가 word로 들어온다.
    public Map<String, Object> playWordGame(String word, String username) {
        Map<String, Object> response = new HashMap<>();

        // 1. 유저가 존재하는지 DB에서 조회
        var user = userRepository.findByUsername(username)
                .orElse(null);
        if (user == null) {  // 없으면 에러 메시지 반환
            response.put("error ", username + "는 존재하지 않는 사용자입니다.");
            return response;
        }


        // 2. 입력 단어가 사전에 존재하는지 조회
        WordsEntity input = wordsRepository.findByWord(word);
        if (input == null) {
            response.put("error", word + "는 존재하지 않는 단어입니다.");
            return response;
        }


        // 3. 이미 이 단어를 해당 유저가 사용했는지 중복 체크
        if (usedWordsRepository.existsByWordAndUser_Username(input.getWord(), username)) {
            response.put("error", input.getWord() + "는 이미 사용된 단어입니다.");
            return response;
        }

        // 4. 끝말잇기 규칙 맞는지 확인: 이전에 쓴 단어의 마지막 글자와 현재 단어 첫 글자가 일치하는지
        UsedWordsEntity lastUsed = usedWordsRepository.findTopByUser_UsernameOrderByIdDesc(username);
        if (lastUsed != null) {  // 이전 단어가 있으면
            WordsEntity lastWord = wordsRepository.findByWord(lastUsed.getWord());
            // 이전 단어 마지막 글자와 현재 단어 첫 글자 비교
            if (lastWord == null || !lastWord.getLastChar().equals(input.getFirstChar())) {
                response.put("error", "끝말잇기 규칙에 맞지 않음: " + input.getWord());
                return response;
            }
        }

        // 5. 현재 단어를 사용한 기록 생성
        UsedWordsEntity usedWord = new UsedWordsEntity();
        usedWord.setUser(user);  // 누가 사용했는지 UserEntity로 연결
        usedWord.setWord(input.getWord());
        usedWord.setLog("사용자: " + input.getWord());  // 로그에 기록 남김
        usedWord.setWin(null);  // 현재 단어 사용은 승리 아님(기본값)
        usedWordsRepository.save(usedWord);  // DB에 저장


        // 6. 봇이 이어서 사용할 단어 찾기
        WordsEntity botWord = wordsRepository.findNextWord(input.getLastChar());
        if (botWord == null) {  // 다음 단어가 없으면 게임 종료 표시
            response.put("error", "이어질 단어가 없음: " + input.getLastChar());
            response.put("gameOver", true);
            return response;
        }

        // 7. 봇 단어도 사용 기록으로 남기기
        UsedWordsEntity botUsedWord = new UsedWordsEntity();
        botUsedWord.setUser(user);  // 게임 주체인 유저와 연관 (혹은 별도 봇 유저도 가능)
        botUsedWord.setWord(botWord.getWord());
        botUsedWord.setLog("봇: " + botWord.getWord());
        botUsedWord.setWin(false);
        usedWordsRepository.save(botUsedWord);


        // 8. 다음 단어(봇 단어)를 응답에 포함
        // "nextWord"가 서버에 보낼 프론트 키
        response.put("nextWord", botWord.getWord());
        return response;
    }

    public void recordGameResult(String username, boolean win) {
        UsedWordsEntity lastUsedWord = usedWordsRepository.findTopByUser_UsernameOrderByIdDesc(username);

        if (lastUsedWord != null) {
            lastUsedWord.setWin(win); // true: 승리, false: 패배
            usedWordsRepository.save(lastUsedWord);
        }
    }

    public Map<String, Object> getGameResult(String username) {
        Map<String, Object> response = new HashMap<>();

        UsedWordsEntity lastUsed = usedWordsRepository.findTopByUser_UsernameOrderByIdDesc(username);

        if (lastUsed == null) {
            response.put("error", "사용 기록이 없습니다.");
            return response;
        }

        Boolean win = lastUsed.getWin();  // true, false, null

        if (Boolean.TRUE.equals(win)) {
            response.put("result", "win");
        } else if (Boolean.FALSE.equals(win)) {
            response.put("result", "lose");
        } else {
            response.put("result", "undecided"); // 아직 결과 없음
        }

        return response;
    }


    // 게임 종료 시 사용자의 사용 단어 기록 삭제
    public void resetGame(String username) {
        usedWordsRepository.deleteByUser_Username(username);
    }
}



