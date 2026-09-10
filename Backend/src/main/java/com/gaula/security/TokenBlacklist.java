package com.gaula.security;

import org.springframework.stereotype.Component;

import java.util.Collections;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

/**
 * In-memory blacklist of invalidated JWT tokens.
 * Tokens added here are rejected by JwtAuthenticationFilter on every request.
 * Entries persist until server restart (acceptable for this project scale).
 */
@Component
public class TokenBlacklist {

    private final Set<String> blacklisted = Collections.newSetFromMap(new ConcurrentHashMap<>());

    public void add(String token) {
        if (token != null && !token.isBlank()) {
            blacklisted.add(token);
        }
    }

    public boolean contains(String token) {
        return token != null && blacklisted.contains(token);
    }
}
