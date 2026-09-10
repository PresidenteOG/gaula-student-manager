package com.gaula.security;

import com.gaula.entity.Alumno;
import com.gaula.entity.Profesor;
import com.gaula.repository.AlumnoRepository;
import com.gaula.repository.ProfesorRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Implementación de UserDetailsService para Spring Security.
 *
 * ESTRATEGIA DE AUTENTICACIÓN:
 * Busca el usuario primero en la tabla `profesor` y luego en `alumno`.
 * Asigna el rol correspondiente como GrantedAuthority:
 *   - Profesor con rol ADMIN → ROLE_ADMIN
 *   - Profesor con rol TEACHER → ROLE_TEACHER
 *   - Alumno → ROLE_STUDENT
 *
 * Spring Security usa esta clase para cargar el usuario al validar
 * las credenciales durante el login (AuthenticationManager).
 */
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class UserDetailsServiceImpl implements UserDetailsService {

    private final ProfesorRepository profesorRepository;
    private final AlumnoRepository alumnoRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

        // ── 1. Buscar en la tabla de profesores (admin o teacher) ──
        var profesorOpt = profesorRepository.findByUsername(username);
        if (profesorOpt.isPresent()) {
            Profesor profesor = profesorOpt.get();

            String springRole = switch (profesor.getRol()) {
                case ADMIN   -> "ROLE_ADMIN";
                case TEACHER -> "ROLE_TEACHER";
            };

            return new GaulaUserPrincipal(
                profesor.getId(),
                profesor.getUsername(),
                profesor.getPassword(),
                List.of(new SimpleGrantedAuthority(springRole))
            );
        }

        // ── 2. Buscar en la tabla de alumnos ──
        var alumnoOpt = alumnoRepository.findByUsername(username);
        if (alumnoOpt.isPresent()) {
            Alumno alumno = alumnoOpt.get();
            return new GaulaUserPrincipal(
                alumno.getId(),
                alumno.getUsername(),
                alumno.getPassword(),
                List.of(new SimpleGrantedAuthority("ROLE_STUDENT"))
            );
        }

        throw new UsernameNotFoundException("Usuario no encontrado: " + username);
    }

    /**
     * Clase personalizada para extender UserDetails con el ID del usuario.
     */
    public static class GaulaUserPrincipal extends User {
        private final Long id;

        public GaulaUserPrincipal(Long id, String username, String password, 
                                 List<SimpleGrantedAuthority> authorities) {
            super(username, password, authorities);
            this.id = id;
        }

        public Long getId() { return id; }
    }
}
