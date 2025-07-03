package com.example.ouroboros.controller;

import com.example.ouroboros.data.dto.WordsDTO;
import com.example.ouroboros.service.WordsService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/word")
public class WordsController {
    private final WordsService wordsService;

    @GetMapping(value = "/random",produces = "application/json; charset=UTF-8")
    public ResponseEntity<WordsDTO> getRandomStartWord() {
        WordsDTO wordDTO = this.wordsService.getRandomStartWord();
        return new ResponseEntity<>(wordDTO, HttpStatus.OK);
    }

    @GetMapping(value = "/play", produces = "application/json; charset=UTF-8")
    public ResponseEntity<List<String>> getValidWords() {
        List<String> words = this.wordsService.getValidWordsList();
        return new ResponseEntity<>(words, HttpStatus.OK);
    }

}

