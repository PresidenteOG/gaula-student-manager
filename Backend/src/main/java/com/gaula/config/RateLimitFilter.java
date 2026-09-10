package com.gaula.config;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Filtro de seguridad para prevenir ataques DDoS básicos mediante Rate Limiting.
 * Limita el número de peticiones por IP en un intervalo de tiempo.
 */
@Component
@Slf4j
public class RateLimitFilter implements Filter {

    // Configuración: 100 peticiones por minuto por IP
    private static final int MAX_REQUESTS_PER_MINUTE = 100;
    private final Map<String, UserRequestInfo> requestCounts = new ConcurrentHashMap<>();

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Exempt logout from rate limiting: it is a single fire-and-forget action
        // per session and must never return 429 as that breaks the logout flow entirely.
        if ("POST".equalsIgnoreCase(httpRequest.getMethod())
                && httpRequest.getRequestURI().endsWith("/api/auth/logout")) {
            chain.doFilter(request, response);
            return;
        }

        String clientIp = getClientIp(httpRequest);
        long currentTime = System.currentTimeMillis();

        UserRequestInfo info = requestCounts.compute(clientIp, (k, v) -> {
            if (v == null || (currentTime - v.startTime) > 60000) {
                return new UserRequestInfo(currentTime, new AtomicInteger(1));
            }
            v.count.incrementAndGet();
            return v;
        });

        if (info.count.get() > MAX_REQUESTS_PER_MINUTE) {
            log.warn("Rate limit excedido para IP: {}", clientIp);
            httpResponse.setStatus(429); // Too Many Requests
            httpResponse.getWriter().write("Demasiadas peticiones. Por favor, espere un minuto.");
            return;
        }

        chain.doFilter(request, response);
    }

    private String getClientIp(HttpServletRequest request) {
        String xfHeader = request.getHeader("X-Forwarded-For");
        if (xfHeader == null) {
            return request.getRemoteAddr();
        }
        return xfHeader.split(",")[0];
    }

    private static class UserRequestInfo {
        long startTime;
        AtomicInteger count;

        UserRequestInfo(long startTime, AtomicInteger count) {
            this.startTime = startTime;
            this.count = count;
        }
    }
}
