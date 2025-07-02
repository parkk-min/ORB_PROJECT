package com.example.ouroboros.data.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.ColumnDefault;

import java.util.ArrayList;
import java.util.List;

@Table(name = "user")
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Entity
@Data
public class UserEntity {
    @Id
    @Size(max = 10)
    @Column(name = "username", length = 10)
    private String username;

    @NotNull
    @Size(max = 100)
    @Column(name = "password", nullable = false, length = 100)
    private String password;

    @NotNull
    @Size(max = 4)
    @Column(name = "name", nullable = false, length = 4)
    private String name;

    @NotNull
    @Size(max = 11)
    @Column(name = "phone", nullable = false, length = 11)
    private String phone;

    @OneToMany(mappedBy = "user")
    private List<UsedWordsEntity> usedWords = new ArrayList<>();

    @Size(max = 10)
    @NotNull
    @ColumnDefault("ROLE_USER")
    @Column(name = "role", nullable = false, length = 10)
    private String role;

}
