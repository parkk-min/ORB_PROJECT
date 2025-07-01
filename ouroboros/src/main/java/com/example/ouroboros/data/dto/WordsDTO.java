package com.example.ouroboros.data.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class WordsDTO {

    private Integer id;
    private String word;
    private String firstChar;
    private String lastChar;
}
