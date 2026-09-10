package com.gaula.service.incidencia;

import com.gaula.domain.IncidenciaDto;
import com.gaula.dto.incidencia.CreateIncidenciaRequest;
import com.gaula.entity.Alumno;
import com.gaula.entity.Incidencia;
import com.gaula.entity.Profesor;
import com.gaula.exception.ResourceNotFoundException;
import com.gaula.repository.AlumnoRepository;
import com.gaula.repository.IncidenciaRepository;
import com.gaula.repository.ProfesorRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class IncidenciaServiceImpl implements IncidenciaService {

    private final IncidenciaRepository incidenciaRepository;
    private final AlumnoRepository alumnoRepository;
    private final ProfesorRepository profesorRepository;

    @Override
    @Transactional(readOnly = true)
    public List<IncidenciaDto> findAll() {
        return incidenciaRepository.findAll().stream()
            .map(i -> IncidenciaDto.fromEntity(i))
            .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<IncidenciaDto> findByAlumnoId(Long alumnoId) {
        return incidenciaRepository.findByAlumnoIdOrderByFechaIncidenciaDesc(alumnoId).stream()
            .map(i -> IncidenciaDto.fromEntity(i))
            .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<IncidenciaDto> findByProfesor(String username) {
        return incidenciaRepository.findByProfesorUsernameOrderByFechaIncidenciaDesc(username).stream()
            .map(i -> IncidenciaDto.fromEntity(i))
            .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public org.springframework.data.domain.Page<IncidenciaDto> findAllPaginated(org.springframework.data.domain.Pageable pageable) {
        return incidenciaRepository.findAllByOrderByFechaIncidenciaDesc(pageable)
            .map(i -> IncidenciaDto.fromEntity(i));
    }

    @Override
    @Transactional(readOnly = true)
    public org.springframework.data.domain.Page<IncidenciaDto> findAvanzado(String username, String role, Long alumnoId, Long profesorId, Long cursoId, String estado, String resolucion, org.springframework.data.domain.Pageable pageable) {
        Incidencia.EstadoIncidencia estadoEnum = null;
        if (estado != null && !estado.isBlank() && !estado.equalsIgnoreCase("todas")) {
            try {
                // Reemplazar guiones por guiones bajos para que coincida con el Enum (e.g., en-proceso -> EN_PROCESO)
                String normalizedStatus = estado.trim().replace("-", "_").toUpperCase();
                estadoEnum = Incidencia.EstadoIncidencia.valueOf(normalizedStatus);
            } catch (IllegalArgumentException e) {
                log.warn("Estado de incidencia inválido: {}", estado);
            }
        }

        Incidencia.ResolucionIncidencia resolucionEnum = null;
        if (resolucion != null && !resolucion.isBlank() && !resolucion.equalsIgnoreCase("todas")) {
            try {
                resolucionEnum = Incidencia.ResolucionIncidencia.valueOf(resolucion.trim().toUpperCase());
            } catch (IllegalArgumentException e) {
                log.warn("Resolución de incidencia inválida: {}", resolucion);
            }
        }

        if ("ROLE_ADMIN".equals(role)) {
            return incidenciaRepository.buscarAvanzadoAdmin(alumnoId, profesorId, cursoId, estadoEnum, resolucionEnum, pageable)
                .map(i -> IncidenciaDto.fromEntity(i));
        } else if ("ROLE_TEACHER".equals(role) || "ROLE_DOCENTE".equals(role)) {
            return incidenciaRepository.buscarAvanzadoProfesor(username, alumnoId, profesorId, cursoId, estadoEnum, resolucionEnum, pageable)
                .map(i -> IncidenciaDto.fromEntity(i));
        } else {
            // Estudiante: solo ve lo propio
            return incidenciaRepository.buscarAvanzadoAlumno(username, estadoEnum, resolucionEnum, pageable)
                .map(i -> IncidenciaDto.fromEntity(i));
        }
    }


    @Override
    @Transactional(readOnly = true)
    public org.springframework.data.domain.Page<IncidenciaDto> findByProfesorPaginated(String username, org.springframework.data.domain.Pageable pageable) {
        return incidenciaRepository.findByProfesorUsernameOrderByFechaIncidenciaDesc(username, pageable)
            .map(i -> IncidenciaDto.fromEntity(i));
    }

    @Override
    @Transactional
    public IncidenciaDto create(CreateIncidenciaRequest request) {
        Alumno alumno = alumnoRepository.findById(request.alumnoId())
            .orElseThrow(() -> new ResourceNotFoundException("Alumno", "id", request.alumnoId()));
        Profesor profesor = null;
        if (request.profesorId() != null) {
            profesor = profesorRepository.findById(request.profesorId()).orElse(null);
        }

        Incidencia incidencia = Incidencia.builder()
            .alumno(alumno)
            .profesor(profesor)
            .titulo(request.titulo())
            .descripcion(request.descripcion())
            .gravedad(Incidencia.GravedadIncidencia.valueOf(request.gravedad().toUpperCase()))
            .estado(Incidencia.EstadoIncidencia.ABIERTA)
            .build();


        Incidencia guardada = incidenciaRepository.save(incidencia);
        log.info("Incidencia creada para alumno {}: {}", request.alumnoId(), request.titulo());

        return IncidenciaDto.fromEntity(guardada);
    }

    @Override
    @Transactional
    public IncidenciaDto updateEstado(Long id, String nuevoEstado, String resolucion) {
        Incidencia incidencia = incidenciaRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Incidencia", "id", id));
        
        incidencia.setEstado(Incidencia.EstadoIncidencia.valueOf(nuevoEstado.toUpperCase()));
        
        if (resolucion != null && !resolucion.isBlank()) {
            incidencia.setResolucion(Incidencia.ResolucionIncidencia.valueOf(resolucion.toUpperCase()));
        }

        return IncidenciaDto.fromEntity(incidenciaRepository.save(incidencia));
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (!incidenciaRepository.existsById(id)) {
            throw new ResourceNotFoundException("Incidencia", "id", id);
        }
        incidenciaRepository.deleteById(id);
    }
}
