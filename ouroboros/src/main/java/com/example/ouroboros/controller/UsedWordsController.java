package com.example.ouroboros.controller;

import com.example.ouroboros.data.dto.UsedWordsDTO;
import com.example.ouroboros.service.UsedWordsService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping(value = "/game")
public class UsedWordsController {
    private final UsedWordsService usedWordsService;

    // 끝말잇기 게임 플레이
    @PostMapping("/play")
    public ResponseEntity<Map<String, Object>> playWordGame(@RequestBody UsedWordsDTO request) {
        Map<String, Object> response = usedWordsService.playWordGame(
                request.getWord(),
                request.getUsername()
        );
        return ResponseEntity.ok(response);
    }

    // 게임 결과 저장 (승패 기록)
    @PostMapping("/result")
    public ResponseEntity<Void> recordGameResult(@RequestBody UsedWordsDTO request) {
        usedWordsService.recordGameResult(
                request.getUsername(),
                request.getResult()
        );
        return ResponseEntity.ok().build();
    }

    // 사용자 단어 사용 기록 전체 조회
    @PostMapping("/history")
    public ResponseEntity<List<UsedWordsDTO>> getGameHistory(@RequestBody UsedWordsDTO request) {
        List<UsedWordsDTO> history = usedWordsService.getGameResult(request.getUsername());
        return ResponseEntity.ok(history);
    }

    // 4) 게임 기록 초기화
    @PostMapping("/reset")
    public ResponseEntity<Void> resetGame(@RequestBody UsedWordsDTO request) {
        usedWordsService.resetGame(request.getUsername());
        return ResponseEntity.ok().build();
    }


}
