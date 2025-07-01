package com.example.ouroboros.controller;

import com.example.ouroboros.data.dto.WordsDTO;
import com.example.ouroboros.service.WordsService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/word")
public class WordsController {
    private final WordsService wordsService;

    @GetMapping(value = "/random")
    public ResponseEntity<WordsDTO> getRandomStartWord() {
        WordsDTO wordDTO = this.wordsService.getRandomStartWord();
        return new ResponseEntity<>(wordDTO, HttpStatus.OK);
    }

}
