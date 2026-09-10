package com.gaula.service.profesor;

import com.gaula.domain.ProfesorDto;
import com.gaula.dto.profesor.CreateProfesorRequest;
import com.gaula.dto.profesor.UpdateProfesorRequest;
import com.gaula.dto.perfil.UpdatePerfilRequest;
import com.gaula.entity.Profesor;
import com.gaula.exception.ResourceNotFoundException;
import com.gaula.repository.ProfesorRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import com.gaula.repository.HorarioRepository;
import com.gaula.repository.IncidenciaRepository;
import com.gaula.repository.AsistenciaRepository;
import com.gaula.entity.AppTheme;
import com.gaula.entity.Asistencia;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDate;
import java.util.Map;

import java.util.List;
import java.util.stream.Collectors;

/**
 * Implementación del servicio de Profesores.
 *
 * REGLA DE NEGOCIO CLAVE — Sustitución:
 * Solo se puede asignar un sustituto a un profesor con estado INACTIVO.
 * Al volver al estado ACTIVO, el sustituto se borra automáticamente.
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class ProfesorServiceImpl implements ProfesorService {

    private final ProfesorRepository profesorRepository;
    private final PasswordEncoder    passwordEncoder;
    private final HorarioRepository     claseRepository;
    private final IncidenciaRepository incidenciaRepository;
    private final AsistenciaRepository asistenciaRepository;


    @Override
    @Transactional(readOnly = true)
    public List<ProfesorDto> findAll() {
        return profesorRepository.findAll().stream()
            .map(ProfesorDto::fromEntity)
            .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public ProfesorDto findById(Long id) {
        return ProfesorDto.fromEntity(
            profesorRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Profesor", "id", id))
        );
    }

    @Override
    @Transactional(readOnly = true)
    public List<ProfesorDto> findByRol(Profesor.RolProfesor rol) {
        return profesorRepository.findByRolOrderByApellidosAsc(rol).stream()
            .map(ProfesorDto::fromEntity)
            .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<ProfesorDto> buscar(String query) {
        return profesorRepository.buscarAvanzado(query, null, null, org.springframework.data.domain.Pageable.unpaged()).getContent().stream()
            .map(ProfesorDto::fromEntity)
            .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public org.springframework.data.domain.Page<ProfesorDto> findAllPaginated(String query, String rol, Long cursoId, org.springframework.data.domain.Pageable pageable) {
        Profesor.RolProfesor rolEnum = (rol != null && !rol.isBlank()) ? Profesor.RolProfesor.valueOf(rol.toUpperCase()) : null;
        return profesorRepository.buscarAvanzado(query, rolEnum, cursoId, pageable).map(ProfesorDto::fromEntity);
    }

    @Override
    @Transactional(readOnly = true)
    public ProfesorDto findByUsername(String username) {
        Profesor profesor = profesorRepository.findByUsername(username)
            .orElseThrow(() -> new ResourceNotFoundException("Profesor", "username", username));
        return ProfesorDto.fromEntity(profesor);
    }

    @Override
    @Transactional
    public ProfesorDto create(CreateProfesorRequest request) {
        if (profesorRepository.existsByUsername(request.username())) {
            throw new IllegalArgumentException("Ya existe un profesor con el username: " + request.username());
        }
        if (profesorRepository.existsByEmail(request.email())) {
            throw new IllegalArgumentException("Ya existe un profesor con el email: " + request.email());
        }

        Profesor.RolProfesor rol = StringUtils.hasText(request.rol())
            ? Profesor.RolProfesor.valueOf(request.rol().toUpperCase())
            : Profesor.RolProfesor.TEACHER;

        Profesor profesor = Profesor.builder()
            .nombre(request.nombre())
            .apellidos(request.apellidos())
            .username(request.username())
            .password(passwordEncoder.encode(request.password()))
            .email(request.email())
            .rol(rol)
            .estado(Profesor.EstadoProfesor.ACTIVO)
            .especialidades(request.especialidades())
            .avatar(StringUtils.hasText(request.avatar()) ? request.avatar() : "👨‍🏫")
            .build();

        Profesor guardado = profesorRepository.save(profesor);
        log.info("Profesor creado: {} (ID: {})", guardado.getNombreCompleto(), guardado.getId());
        return ProfesorDto.fromEntity(guardado);
    }

    @Override
    @Transactional
    public ProfesorDto update(Long id, UpdateProfesorRequest request) {
        Profesor profesor = profesorRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Profesor", "id", id));

        if (StringUtils.hasText(request.nombre()))        profesor.setNombre(request.nombre());
        if (StringUtils.hasText(request.apellidos()))     profesor.setApellidos(request.apellidos());
        if (StringUtils.hasText(request.email()))         profesor.setEmail(request.email());
        if (StringUtils.hasText(request.avatar()))        profesor.setAvatar(request.avatar());
        if (StringUtils.hasText(request.especialidades())) profesor.setEspecialidades(request.especialidades());
        if (StringUtils.hasText(request.password()))      profesor.setPassword(passwordEncoder.encode(request.password()));
        if (StringUtils.hasText(request.rol()))           profesor.setRol(Profesor.RolProfesor.valueOf(request.rol().toUpperCase()));

        return ProfesorDto.fromEntity(profesorRepository.save(profesor));
    }

    @Override
    @Transactional
    public ProfesorDto updatePerfilPropio(String username, UpdatePerfilRequest request) {
        Profesor profesor = profesorRepository.findByUsername(username)
            .orElseThrow(() -> new ResourceNotFoundException("Profesor", "username", username));

        // Email único: validar solo si cambia respecto al actual.
        String nuevoEmail = request.email().trim();
        if (!nuevoEmail.equalsIgnoreCase(profesor.getEmail())
                && profesorRepository.existsByEmail(nuevoEmail)) {
            throw new IllegalArgumentException("Ya existe un usuario con el email: " + nuevoEmail);
        }

        profesor.setNombre(request.nombre().trim());
        profesor.setApellidos(request.apellidos().trim());
        profesor.setEmail(nuevoEmail);
        profesor.setDni(normalizar(request.dni()));
        profesor.setTelefono(normalizar(request.telefono()));
        profesor.setDireccion(normalizar(request.direccion()));
        profesor.setFechaNacimiento(request.fechaNacimiento());

        Profesor actualizado = profesorRepository.save(profesor);
        log.info("Perfil propio actualizado para profesor: {} (ID: {})", username, actualizado.getId());
        return ProfesorDto.fromEntity(actualizado);
    }

    /** Convierte cadenas vacías o en blanco a null para no persistir basura. */
    private static String normalizar(String valor) {
        return StringUtils.hasText(valor) ? valor.trim() : null;
    }

    @Override
    @Transactional
    public ProfesorDto cambiarEstado(Long id, String nuevoEstado) {
        Profesor profesor = profesorRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Profesor", "id", id));

        Profesor.EstadoProfesor estado = Profesor.EstadoProfesor.valueOf(nuevoEstado.toUpperCase());
        profesor.setEstado(estado);

        // REGLA: Si el profesor vuelve a ACTIVO, se elimina el sustituto asignado
        if (estado == Profesor.EstadoProfesor.ACTIVO) {
            profesor.setSustituto(null);
            log.info("Profesor {} ha vuelto a ACTIVO: sustitución eliminada", id);
        }

        return ProfesorDto.fromEntity(profesorRepository.save(profesor));
    }

    @Override
    @Transactional
    public ProfesorDto asignarSustituto(Long profesorId, Long sustitutoId) {
        Profesor profesor = profesorRepository.findById(profesorId)
            .orElseThrow(() -> new ResourceNotFoundException("Profesor", "id", profesorId));

        // REGLA: Solo se puede asignar sustituto a un profesor INACTIVO
        if (profesor.getEstado() != Profesor.EstadoProfesor.INACTIVO) {
            throw new IllegalArgumentException(
                "Solo se puede asignar sustituto a un profesor con estado INACTIVO. " +
                "Estado actual: " + profesor.getEstado()
            );
        }

        if (sustitutoId == null) {
            // Eliminar la sustitución
            profesor.setSustituto(null);
        } else {
            Profesor sustituto = profesorRepository.findById(sustitutoId)
                .orElseThrow(() -> new ResourceNotFoundException("Profesor sustituto", "id", sustitutoId));

            // REGLA: El sustituto debe estar ACTIVO para poder asumir clases
            if (sustituto.getEstado() != Profesor.EstadoProfesor.ACTIVO) {
                throw new IllegalArgumentException("El profesor sustituto debe estar en estado ACTIVO");
            }
            // Un profesor no puede sustituirse a sí­ mismo
            if (sustitutoId.equals(profesorId)) {
                throw new IllegalArgumentException("Un profesor no puede ser su propio sustituto");
            }

            profesor.setSustituto(sustituto);
            log.info("Sustitución asignada: {} → {}", profesorId, sustitutoId);
        }

        return ProfesorDto.fromEntity(profesorRepository.save(profesor));
    }

    @Override
    @Transactional
    public void cambiarPassword(Long id, String nuevaPassword) {
        Profesor profesor = profesorRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Profesor", "id", id));
        profesor.setPassword(passwordEncoder.encode(nuevaPassword));
        profesorRepository.save(profesor);
        log.info("Contraseña actualizada para Profesor ID: {}", id);
    }

    @Override
    @Transactional
    public void updateAvatar(String username, String avatar) {
        Profesor profesor = profesorRepository.findByUsername(username)
            .orElseThrow(() -> new ResourceNotFoundException("Profesor", "username", username));
        profesor.setAvatar(avatar);
        profesorRepository.save(profesor);
    }

    @Override
    @Transactional
    public void updateTheme(String username, String theme) {
        Profesor profesor = profesorRepository.findByUsername(username)
            .orElseThrow(() -> new ResourceNotFoundException("Profesor", "username", username));
        profesor.setTheme(theme.equalsIgnoreCase("light") ? AppTheme.light : AppTheme.dark);
        profesorRepository.save(profesor);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (!profesorRepository.existsById(id)) {
            throw new ResourceNotFoundException("Profesor", "id", id);
        }
        profesorRepository.deleteById(id);
        log.info("Profesor eliminado (ID: {})", id);
    }
    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getDashboardStats(Long id) {
        if (!profesorRepository.existsById(id)) {
            throw new ResourceNotFoundException("Profesor", "id", id);
        }

        long clasesHoy = claseRepository.findByProfesorIdAndDiaSemana(id, LocalDate.now().getDayOfWeek()).size();
        long incidenciasHoy = incidenciaRepository.countByProfesorIdAndFechaIncidenciaGreaterThanEqual(id, LocalDate.now().atStartOfDay());
        
        // Alumnos totales en sus clases (distintos)
        long totalAlumnos = claseRepository
            .findByProfesorId(id).stream()
            .flatMap(c -> c.getMateria().getAlumnos().stream())
            .distinct()
            .count();

        // Cálculo de asistencia media (Presentes + Justificados / Total)
        List<Asistencia> asistencias = asistenciaRepository.findByClaseProfesorId(id);
        String asistenciaMedia = "0%";
        if (!asistencias.isEmpty()) {
            long positivos = asistencias.stream()
                .filter(a -> a.getEstado() == Asistencia.EstadoAsistencia.PRESENTE || 
                            a.getEstado() == Asistencia.EstadoAsistencia.JUSTIFICADO)
                .count();
            double porcentaje = (positivos * 100.0) / asistencias.size();
            asistenciaMedia = String.format("%.0f%%", porcentaje);
        }

        return Map.of(
            "clasesHoy", clasesHoy,
            "totalAlumnos", totalAlumnos,
            "incidenciasHoy", incidenciasHoy,
            "asistenciaMedia", asistenciaMedia
        );
    }
}

