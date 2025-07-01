package com.example.ouroboros.data.dto;

import com.example.ouroboros.data.entity.UsedWordsEntity;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@JsonIgnoreProperties(ignoreUnknown = true)
public class UsedWordsDTO {

    private Integer id;
    private String username;
    private String log;
    private String word;
    private UsedWordsEntity.WinStatus result;

}
