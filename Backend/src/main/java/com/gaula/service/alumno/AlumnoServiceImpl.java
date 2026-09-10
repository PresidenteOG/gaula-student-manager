package com.gaula.service.alumno;

import com.gaula.domain.AlumnoDto;
import com.gaula.dto.alumno.CreateAlumnoRequest;
import com.gaula.dto.alumno.UpdateAlumnoRequest;
import com.gaula.dto.perfil.UpdatePerfilRequest;
import com.gaula.entity.Alumno;
import com.gaula.entity.AppTheme;
import com.gaula.entity.Curso;
import com.gaula.entity.Materia;
import com.gaula.exception.ResourceNotFoundException;
import com.gaula.repository.AlumnoRepository;
import com.gaula.repository.CursoRepository;
import com.gaula.repository.MateriaRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * Implementación del servicio de Alumnos.
 *
 * DECISIONES ARQUITECTÓNICAS:
 * - @Transactional en métodos de escritura para garantizar atomicidad.
 * - @Transactional(readOnly=true) en consultas para optimizar Hibernate.
 * - La contraseña se hashea con BCrypt antes de persistir.
 * - Si no se especifican materiaIds al crear, el alumno se matricula
 *   automáticamente en TODAS las materias del curso.
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class AlumnoServiceImpl implements AlumnoService {

    private final AlumnoRepository  alumnoRepository;
    private final CursoRepository   cursoRepository;
    private final MateriaRepository  materiaRepository;
    private final PasswordEncoder    passwordEncoder;

    @Override
    @Transactional(readOnly = true)
    public List<AlumnoDto> findAll() {
        return alumnoRepository.findAll().stream()
            .map(AlumnoDto::fromEntity)
            .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public AlumnoDto findById(Long id) {
        Alumno alumno = alumnoRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Alumno", "id", id));
        return AlumnoDto.fromEntity(alumno);
    }

    @Override
    @Transactional(readOnly = true)
    public AlumnoDto findByUsername(String username) {
        Alumno alumno = alumnoRepository.findByUsername(username)
            .orElseThrow(() -> new ResourceNotFoundException("Alumno", "username", username));
        return AlumnoDto.fromEntity(alumno);
    }

    @Override
    @Transactional(readOnly = true)
    public List<AlumnoDto> findByCursoId(Long cursoId) {
        return alumnoRepository.findActivosByCursoId(cursoId).stream()
            .map(AlumnoDto::fromEntity)
            .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<AlumnoDto> buscar(String query) {
        // Fallback para búsqueda no paginada si se requiere, usando un Pageable grande o refactorizando
        return alumnoRepository.buscarPorNombreOApellidos(query, org.springframework.data.domain.Pageable.unpaged()).getContent().stream()
            .map(AlumnoDto::fromEntity)
            .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public org.springframework.data.domain.Page<AlumnoDto> findAllPaginated(String query, Long cursoId, org.springframework.data.domain.Pageable pageable) {
        return alumnoRepository.buscarAvanzado(query, cursoId, pageable)
            .map(AlumnoDto::fromEntity);
    }

    @Override
    @Transactional
    public AlumnoDto create(CreateAlumnoRequest request) {
        // Validar unicidad de username y email
        if (alumnoRepository.existsByUsername(request.username())) {
            throw new IllegalArgumentException("Ya existe un alumno con el username: " + request.username());
        }
        if (alumnoRepository.existsByEmail(request.email())) {
            throw new IllegalArgumentException("Ya existe un alumno con el email: " + request.email());
        }

        // Construir la entidad Alumno
        Alumno alumno = Alumno.builder()
            .nombre(request.nombre())
            .apellidos(request.apellidos())
            .username(request.username())
            .password(passwordEncoder.encode(request.password()))
            .email(request.email())
            .estado(Alumno.EstadoAlumno.ACTIVO)
            .avatar(StringUtils.hasText(request.avatar()) ? request.avatar() : "👨‍🎓")
            .dni(request.dni())
            .telefono(request.telefono())
            .direccion(request.direccion())
            .fechaNacimiento(request.fechaNacimiento())
            .materias(new ArrayList<>())
            .build();

        Alumno guardado = alumnoRepository.save(alumno);
        log.info("Alumno creado: {} (ID: {})", guardado.getNombreCompleto(), guardado.getId());
        return AlumnoDto.fromEntity(guardado);
    }

    @Override
    @Transactional
    public AlumnoDto update(Long id, UpdateAlumnoRequest request) {
        Alumno alumno = alumnoRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Alumno", "id", id));

        // Actualizar solo los campos no nulos (patch semántico)
        if (StringUtils.hasText(request.nombre()))    alumno.setNombre(request.nombre());
        if (StringUtils.hasText(request.apellidos())) alumno.setApellidos(request.apellidos());
        if (StringUtils.hasText(request.email()))     alumno.setEmail(request.email());
        if (StringUtils.hasText(request.avatar()))    alumno.setAvatar(request.avatar());
        if (StringUtils.hasText(request.password()))  alumno.setPassword(passwordEncoder.encode(request.password()));

        if (StringUtils.hasText(request.estado())) {
            alumno.setEstado(Alumno.EstadoAlumno.valueOf(request.estado().toUpperCase()));
        }

        final Long cursoActualId = (alumno.getCurso() != null) ? alumno.getCurso().getId() : null;
        if (!Objects.equals(request.cursoId(), cursoActualId)) {
            if (request.cursoId() != null) {
                Curso curso = cursoRepository.findById(request.cursoId())
                    .orElseThrow(() -> new ResourceNotFoundException("Curso", "id", request.cursoId()));
                alumno.setCurso(curso);

                // Matricular en materias: si no se especifican, se matricula en todas las del curso
                List<Materia> materias;
                if (request.materiaIds() != null && !request.materiaIds().isEmpty()) {
                    materias = materiaRepository.findAllById(request.materiaIds());
                } else {
                    materias = materiaRepository.findByCursoIdOrderByCodigoAsc(request.cursoId());
                }
                alumno.setMaterias(new ArrayList<>(materias));
            } else {
                alumno.setCurso(null);
                alumno.setMaterias(new ArrayList<>());
            }
        }

        Alumno actualizado = alumnoRepository.save(alumno);
        log.info("Alumno actualizado: {} (ID: {})", actualizado.getNombreCompleto(), actualizado.getId());
        return AlumnoDto.fromEntity(actualizado);
    }

    @Override
    @Transactional
    public AlumnoDto updatePerfilPropio(String username, UpdatePerfilRequest request) {
        Alumno alumno = alumnoRepository.findByUsername(username)
            .orElseThrow(() -> new ResourceNotFoundException("Alumno", "username", username));

        // Email único: validar solo si cambia respecto al actual.
        String nuevoEmail = request.email().trim();
        if (!nuevoEmail.equalsIgnoreCase(alumno.getEmail())
                && alumnoRepository.existsByEmail(nuevoEmail)) {
            throw new IllegalArgumentException("Ya existe un usuario con el email: " + nuevoEmail);
        }

        alumno.setNombre(request.nombre().trim());
        alumno.setApellidos(request.apellidos().trim());
        alumno.setEmail(nuevoEmail);
        alumno.setDni(normalizar(request.dni()));
        alumno.setTelefono(normalizar(request.telefono()));
        alumno.setDireccion(normalizar(request.direccion()));
        alumno.setFechaNacimiento(request.fechaNacimiento());

        Alumno actualizado = alumnoRepository.save(alumno);
        log.info("Perfil propio actualizado para alumno: {} (ID: {})", username, actualizado.getId());
        return AlumnoDto.fromEntity(actualizado);
    }

    /** Convierte cadenas vacías o en blanco a null para no persistir basura. */
    private static String normalizar(String valor) {
        return StringUtils.hasText(valor) ? valor.trim() : null;
    }

    @Override
    @Transactional
    public AlumnoDto cambiarEstado(Long id, String nuevoEstado) {
        Alumno alumno = alumnoRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Alumno", "id", id));
        alumno.setEstado(Alumno.EstadoAlumno.valueOf(nuevoEstado.toUpperCase()));
        return AlumnoDto.fromEntity(alumnoRepository.save(alumno));
    }

    @Override
    @Transactional
    public AlumnoDto actualizarMaterias(Long alumnoId, List<Long> materiaIds) {
        Alumno alumno = alumnoRepository.findById(alumnoId)
            .orElseThrow(() -> new ResourceNotFoundException("Alumno", "id", alumnoId));

        List<Materia> nuevasMaterias = materiaRepository.findAllById(materiaIds);
        alumno.setMaterias(new ArrayList<>(nuevasMaterias));

        log.info("Materias del alumno {} actualizadas: {} materias", alumnoId, nuevasMaterias.size());
        return AlumnoDto.fromEntity(alumnoRepository.save(alumno));
    }

    @Override
    @Transactional
    public void updateAvatar(String username, String avatar) {
        Alumno alumno = alumnoRepository.findByUsername(username)
            .orElseThrow(() -> new ResourceNotFoundException("Alumno", "username", username));
        alumno.setAvatar(avatar);
        alumnoRepository.save(alumno);
    }

    @Override
    @Transactional
    public void updateTheme(String username, String theme) {
        Alumno alumno = alumnoRepository.findByUsername(username)
            .orElseThrow(() -> new ResourceNotFoundException("Alumno", "username", username));
        alumno.setTheme(theme.equalsIgnoreCase("light") ? AppTheme.light : AppTheme.dark);
        alumnoRepository.save(alumno);
    }

    @Override
    @Transactional
    public void cambiarPassword(Long id, String nuevaPassword) {
        Alumno alumno = alumnoRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Alumno", "id", id));
        alumno.setPassword(passwordEncoder.encode(nuevaPassword));
        alumnoRepository.save(alumno);
        log.info("Contraseña actualizada para Alumno ID: {}", id);
    }

    @Override
    @Transactional(readOnly = true)
    public List<AlumnoDto> getAlumnosSinMatricular() {
        return alumnoRepository.findByCursoIsNullOrderByApellidosAsc().stream()
            .map(AlumnoDto::fromEntity)
            .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (!alumnoRepository.existsById(id)) {
            throw new ResourceNotFoundException("Alumno", "id", id);
        }
        alumnoRepository.deleteById(id);
        log.info("Alumno eliminado (ID: {})", id);
    }
}
