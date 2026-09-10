package com.gaula.security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.lang.NonNull;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Filtro JWT que intercepta CADA request HTTP (OncePerRequestFilter).
 *
 * FLUJO:
 *   1. Extrae el token del header Authorization: "Bearer <token>"
 *   2. Valida el token con JwtTokenProvider
 *   3. Extrae username y roles del token (sin consultar la BBDD)
 *   4. Inyecta la autenticación en el SecurityContext
 *   5. Continúa la cadena de filtros
 *
 * DECISIÓN ARQUITECTÓNICA:
 * Los roles se leen del token JWT (no de la BBDD) para evitar
 * una consulta a la BBDD en cada request. Si los roles del
 * usuario cambian, será necesario que el cliente renueve su token.
 */
@Component
@RequiredArgsConstructor
@Slf4j
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtTokenProvider jwtTokenProvider;
    private final TokenBlacklist tokenBlacklist;
    private final com.gaula.repository.ProfesorRepository profesorRepo;
    private final com.gaula.repository.AlumnoRepository alumnoRepo;

    @Override
    protected void doFilterInternal(
        @NonNull HttpServletRequest  request,
        @NonNull HttpServletResponse response,
        @NonNull FilterChain         filterChain
    ) throws ServletException, IOException {

        try {
            // ── 1. Extraer el token del header Authorization ──
            String token = extraerTokenDelHeader(request);

            // ── 2. Validar el token si existe y no está en la blacklist ──
            if (StringUtils.hasText(token) && jwtTokenProvider.validarToken(token) && !tokenBlacklist.contains(token)) {

                // ── 3. Extraer datos del token ──
                String username = jwtTokenProvider.extraerUsername(token);
                List<String> roles = jwtTokenProvider.extraerRoles(token);
                Long userId = jwtTokenProvider.extraerUserId(token);

                // ── 4. Construir las authorities de Spring Security desde el token ──
                List<SimpleGrantedAuthority> authorities = roles.stream()
                    .map(SimpleGrantedAuthority::new)
                    .collect(Collectors.toList());

                // ── 5. Crear el objeto de autenticación y cargarlo en el contexto ──
                // Usamos GaulaUserPrincipal para que el ID esté disponible en @PreAuthorize
                UserDetailsServiceImpl.GaulaUserPrincipal principal = 
                    new UserDetailsServiceImpl.GaulaUserPrincipal(userId, username, "", authorities);

                UsernamePasswordAuthenticationToken authentication =
                    new UsernamePasswordAuthenticationToken(principal, null, authorities);

                authentication.setDetails(
                    new WebAuthenticationDetailsSource().buildDetails(request)
                );

                SecurityContextHolder.getContext().setAuthentication(authentication);
                log.debug("Usuario '{}' autenticado con roles: {}", username, roles);

                // ── 6. Actualizar información de conexión (Auditoría) ──
                actualizarInformacionConexion(userId, roles, token, request);
            }
        } catch (Exception ex) {
            // No lanzar excepción aquí: dejar que el endpoint protegido
            // devuelva 401 si el usuario no está autenticado.
            log.error("No se pudo autenticar el usuario desde el token: {}", ex.getMessage());
            SecurityContextHolder.clearContext();
        }

        // ── 6. Continuar con el siguiente filtro de la cadena ──
        filterChain.doFilter(request, response);
    }

    /**
     * Extrae el token JWT del header Authorization.
     * Formato esperado: "Bearer eyJhbGciOiJIUzUxMiJ9..."
     *
     * @return el token sin el prefijo "Bearer ", o null si no existe
     */
    private String extraerTokenDelHeader(HttpServletRequest request) {
        String authHeader = request.getHeader("Authorization");
        if (StringUtils.hasText(authHeader) && authHeader.startsWith("Bearer ")) {
            return authHeader.substring(7); // Eliminar "Bearer "
        }
        return null;
    }

    /**
     * Actualiza la información de conexión del usuario en la base de datos.
     * Incluye IP, Timestamp y el último JWT utilizado.
     */
    private void actualizarInformacionConexion(Long userId, List<String> roles, String token, HttpServletRequest request) {
        try {
            String ip = getClientIp(request);
            java.time.LocalDateTime now = java.time.LocalDateTime.now();

            if (roles.contains("ROLE_ADMIN") || roles.contains("ROLE_TEACHER")) {
                profesorRepo.findById(userId).ifPresent(p -> {
                    // Solo actualizar si ha pasado más de 1 minuto para evitar sobrecarga
                    if (p.getUltimaConexion() == null || p.getUltimaConexion().isBefore(now.minusMinutes(1))) {
                        p.setUltimaConexion(now);
                        p.setIpConexion(ip);
                        p.setUltimoJwt(token);
                        profesorRepo.save(p);
                    }
                });
            } else if (roles.contains("ROLE_STUDENT")) {
                alumnoRepo.findById(userId).ifPresent(a -> {
                    if (a.getUltimaConexion() == null || a.getUltimaConexion().isBefore(now.minusMinutes(1))) {
                        a.setUltimaConexion(now);
                        a.setIpConexion(ip);
                        a.setUltimoJwt(token);
                        alumnoRepo.save(a);
                    }
                });
            }
        } catch (Exception e) {
            log.error("Error actualizando información de conexión: {}", e.getMessage());
        }
    }

    private String getClientIp(HttpServletRequest request) {
        String xfHeader = request.getHeader("X-Forwarded-For");
        if (xfHeader == null) return request.getRemoteAddr();
        return xfHeader.split(",")[0];
    }
}
