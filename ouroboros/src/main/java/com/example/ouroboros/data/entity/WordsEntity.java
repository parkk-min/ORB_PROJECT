package com.example.ouroboros.data.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "words")
public class WordsEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @NotNull
    @Size(max = 100)
    @Column(name = "word", nullable = false, length = 100)
    private String word;

    @NotNull
    @Size(min = 1, max = 1)
    @Column(name = "firstchar", nullable = false, length = 1)
    private String firstChar;

    @NotNull
    @Size(min = 1, max = 1)
    @Column(name = "lastchar", nullable = false, length = 1)
    private String lastChar;
}
