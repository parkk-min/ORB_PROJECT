package com.example.ouroboros.jwt;

import io.jsonwebtoken.ExpiredJwtException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

// 토큰 검사, 인증 처리
@RequiredArgsConstructor
public class JwtFilter extends OncePerRequestFilter { // 요청당 1번만 실행 필터
    private final JwtUtil jwtUtil;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        String token = request.getHeader("Authorization"); // 요청헤더에서 Authorization 추출
        if (token != null && token.startsWith("Bearer ")) { // 형식에 맞으면
            token = token.split(" ")[1]; // 토큰값만 분리
        } else { // 형식에 안맞으며
            filterChain.doFilter(request, response);
            return;
        }

        // 유효기간 확인
        try {
            this.jwtUtil.isTokenExpired(token); // 유효기간 지나면 예외발생
        } catch (ExpiredJwtException e) {
            response.getWriter().println("AccessToken is expired " + e.getMessage());
            response.setStatus(456);
            return;
        }
        
        // 토큰정보 추출
        String username = jwtUtil.getUsername(token);
        String role = jwtUtil.getRole(token);
        List<GrantedAuthority> authorities = new ArrayList<>();
        authorities.add(new SimpleGrantedAuthority(role));
        
        // 인증
        User user = new User(username, "", authorities);
        Authentication auth = new UsernamePasswordAuthenticationToken(user, "", authorities);
        SecurityContextHolder.getContext().setAuthentication(auth);
        filterChain.doFilter(request, response); // 다음필터로 넘김
    }

}
