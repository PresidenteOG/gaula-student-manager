package com.gaula.security;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Proveedor de tokens JWT para GAULA.
 *
 * Responsabilidades:
 *   1. Generar tokens JWT firmados con HS512 al hacer login
 *   2. Extraer claims del token (username, roles, expiración)
 *   3. Validar la firma y la caducidad del token en cada request
 *
 * El token incluye como claims:
 *   - sub (subject):  username del usuario
 *   - roles:          lista de roles Spring Security (ROLE_ADMIN, etc.)
 *   - iat (issued at): timestamp de emisión
 *   - exp (expiry):    timestamp de caducidad (24h por defecto)
 */
@Component
@Slf4j
public class JwtTokenProvider {

    /** Clave secreta de firma (leída de application.yml o variable de entorno). */
    @Value("${gaula.jwt.secret}")
    private String jwtSecret;

    /** Tiempo de expiración en milisegundos (24h = 86.400.000). */
    @Value("${gaula.jwt.expiration-ms}")
    private long jwtExpirationMs;

    /**
     * Genera la SecretKey HMAC-SHA512 a partir de la clave en Base64.
     * La clave debe tener al menos 512 bits (64 bytes) para HS512.
     */
    private SecretKey getSigningKey() {
        byte[] keyBytes = jwtSecret.getBytes(java.nio.charset.StandardCharsets.UTF_8);
        // HS512 requires minimum 512 bits (64 bytes) — pad if necessary
        if (keyBytes.length < 64) {
            byte[] padded = new byte[64];
            System.arraycopy(keyBytes, 0, padded, 0, keyBytes.length);
            keyBytes = padded;
        }
        return Keys.hmacShaKeyFor(keyBytes);
    }

    /**
     * Genera un token JWT a partir de la autenticación exitosa.
     * Se llama desde AuthService después de validar credenciales.
     *
     * @param authentication objeto de autenticación de Spring Security
     * @return token JWT firmado como String
     */
    public String generarToken(Authentication authentication) {
        UserDetailsServiceImpl.GaulaUserPrincipal userPrincipal = (UserDetailsServiceImpl.GaulaUserPrincipal) authentication.getPrincipal();

        // Extraer roles como lista de strings para incluirlos en el token
        List<String> roles = userPrincipal.getAuthorities().stream()
            .map(GrantedAuthority::getAuthority)
            .collect(Collectors.toList());

        Date ahora    = new Date();
        Date caducidad = new Date(ahora.getTime() + jwtExpirationMs);

        return Jwts.builder()
            .subject(userPrincipal.getUsername())        // "sub": username
            .claim("roles", roles)                       // roles como claim custom
            .claim("userId", userPrincipal.getId())      // ID de usuario para verificaciones de propiedad
            .issuer("gaula-backend")                     // "iss": issuer para validación de ciclo de vida
            .issuedAt(ahora)                             // "iat"
            .expiration(caducidad)                       // "exp"
            .signWith(getSigningKey(), Jwts.SIG.HS512)   // firma HMAC-SHA512
            .compact();
    }

    /**
     * Extrae el ID de usuario del token JWT.
     */
    public Long extraerUserId(String token) {
        Object idClaim = parsearClaims(token).get("userId");
        if (idClaim instanceof Number n) {
            return n.longValue();
        }
        return null;
    }

    /**
     * Extrae el username (subject) del token JWT.
     *
     * @param token token JWT como String (sin el prefijo "Bearer ")
     * @return username del usuario
     */
    public String extraerUsername(String token) {
        return parsearClaims(token).getSubject();
    }

    /**
     * Extrae los roles del token JWT.
     *
     * @param token token JWT como String
     * @return lista de roles (ej: ["ROLE_ADMIN"])
     */
    public List<String> extraerRoles(String token) {
        Object rolesClaim = parsearClaims(token).get("roles");
        if (rolesClaim instanceof List<?> rolesList) {
            return rolesList.stream()
                .map(Object::toString)
                .collect(Collectors.toList());
        }
        return List.of();
    }

    /**
     * Valida que el token sea correcto:
     *   - Firma válida (no ha sido manipulado)
     *   - No ha caducado
     *   - No está mal formado
     *
     * @param token token JWT como String
     * @return true si el token es válido, false en caso contrario
     */
    public boolean validarToken(String token) {
        try {
            parsearClaims(token);
            return true;
        } catch (ExpiredJwtException ex) {
            log.warn("Token JWT caducado: {}", ex.getMessage());
        } catch (MalformedJwtException ex) {
            log.warn("Token JWT mal formado: {}", ex.getMessage());
        } catch (io.jsonwebtoken.security.SignatureException ex) {
            log.warn("Firma JWT inválida: {}", ex.getMessage());
        } catch (IllegalArgumentException ex) {
            log.warn("Token JWT vacío o nulo: {}", ex.getMessage());
        }
        return false;
    }

    /**
     * Parsea el token y devuelve el objeto Claims con todos los datos.
     * Lanza excepción si el token es inválido o ha caducado.
     */
    private Claims parsearClaims(String token) {
        return Jwts.parser()
            .verifyWith(getSigningKey())
            .build()
            .parseSignedClaims(token)
            .getPayload();
    }
}
