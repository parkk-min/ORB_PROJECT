package com.example.ouroboros.controller;

import com.example.ouroboros.data.dto.UserDTO;
import com.example.ouroboros.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
public class UserController {
    private final UserService userService;

    // 회원가입
    @PostMapping("/signup")
    public ResponseEntity<String> addUser(@RequestBody UserDTO userDTO) {
        if (userService.isUsernameTaken(userDTO.getUsername())) {
            return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body("이미 존재하는 아이디입니다.");
        }

        userService.addUser(userDTO);  // 중복 아니므로 정상 가입 처리
        return ResponseEntity.ok("User added. 가입 성공");
    }

    // 회원정보
    @GetMapping("/user")
    public ResponseEntity<UserDTO> getUser(@RequestParam String username) {
        UserDTO userDTO = this.userService.findUserByUsername(username);
        return ResponseEntity.status(HttpStatus.OK).body(userDTO);
    }
}
