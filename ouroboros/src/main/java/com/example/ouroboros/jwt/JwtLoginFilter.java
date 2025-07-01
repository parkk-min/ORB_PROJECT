package com.example.ouroboros.jwt;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import java.io.IOException;
import java.util.*;

@RequiredArgsConstructor
public class JwtLoginFilter extends UsernamePasswordAuthenticationFilter {
    private final AuthenticationManager authenticationManager; // 인증처리 인터페이스 (성공시 Authentication객체반환 / 실패시 예외발생)
    private final JwtUtil jwtUtil;

    // 쿠키생성 (refreshToken)
    private Cookie createCookie(String key, String value) {
        Cookie cookie = new Cookie(key, value);
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        // cookie.setSecure(true); // HTTPS 연결에서만 전송
        cookie.setMaxAge(60*60*24);
        return cookie;
    }

    @Override
    public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response) throws AuthenticationException {
        String username = obtainUsername(request);
        String password = obtainPassword(request);

        // 인증용 토큰 생성
        UsernamePasswordAuthenticationToken authRequest = new UsernamePasswordAuthenticationToken(username, password, null);
        return authenticationManager.authenticate(authRequest); // 인증수행**
    }

    // 인증성공시
    @Override
    protected void successfulAuthentication(HttpServletRequest request, HttpServletResponse response, FilterChain chain, Authentication authResult) throws IOException, ServletException {
        UserDetails userDetails = (UserDetails) authResult.getPrincipal();
        String username = userDetails.getUsername();
        Collection<? extends GrantedAuthority> authorities = userDetails.getAuthorities();
        Iterator<? extends GrantedAuthority> authoritiesIterator = authorities.iterator();
        GrantedAuthority authority = authoritiesIterator.next();
        String role = authority.getAuthority(); // 권한명

        Map<String, Object> responseData = new HashMap<>();
        responseData.put("username", username);
        responseData.put("role", role);
        responseData.put("result", "로그인 성공");
        ObjectMapper objectMapper = new ObjectMapper();
        String jsonMessage = objectMapper.writeValueAsString(responseData);

        // 토큰 생성
        String accessToken = this.jwtUtil.generateToken("access", username, role, 60*60*1000L); // accessToken, 1시간
        String refreshToken = this.jwtUtil.generateToken("refresh", username, role, 60*60*24*1000L); // refreshToken 24시간

        response.addHeader("Authorization", "Bearer " + accessToken); // 헤더에 삽입
        response.addCookie(this.createCookie("refresh", refreshToken)); // 쿠키에 삽입
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setStatus(HttpServletResponse.SC_OK); // 200
        response.getWriter().write(jsonMessage);
    }

    // 인증실패시
    @Override
    protected void unsuccessfulAuthentication(HttpServletRequest request, HttpServletResponse response, AuthenticationException failed) throws IOException, ServletException {
        Map<String, Object> responseData = new HashMap<>();
        responseData.put("result", "로그인 실패");
        ObjectMapper objectMapper = new ObjectMapper(); // json변환
        String jsonMessage = objectMapper.writeValueAsString(responseData); // json문자열 변환

        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401
        response.getWriter().write(jsonMessage);
    }

}
