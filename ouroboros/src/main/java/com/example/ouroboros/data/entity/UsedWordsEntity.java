package com.example.ouroboros.data.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Entity
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Table(name = "usedwords")
public class UsedWordsEntity {

    public static enum WinStatus {
        WIN, LOSE, UNDECIDED;
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne
    @JoinColumn(name = "username", referencedColumnName = "username")
    private UserEntity user;

    @Size(max = 100)
    @Column(name = "word", length = 100)
    private String word;

    @Size(max = 500)
    @Column(name = "log", length = 500)
    private String log;

    @Column(name = "result")
    @Enumerated(EnumType.STRING)
    private WinStatus result;
}
