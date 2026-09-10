package com.gaula.service.horario;

import com.gaula.domain.HorarioDto;
import com.gaula.dto.horario.CreateHorarioRequest;
import com.gaula.domain.AlumnoDto;
import com.gaula.entity.Horario;
import com.gaula.entity.Materia;
import com.gaula.entity.Profesor;
import com.gaula.exception.ResourceNotFoundException;
import com.gaula.repository.EventoRepository;
import com.gaula.repository.HorarioRepository;
import com.gaula.repository.MateriaRepository;
import com.gaula.repository.ProfesorRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * Implementación del servicio de Sesiones de Horario.
 *
 * REGLA: Antes de crear una sesión se verifica que no haya conflicto de horario
 * para el mismo profesor en el mismo día y franja horaria.
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class HorarioServiceImpl implements HorarioService {

    private final HorarioRepository  horarioRepository;
    private final MateriaRepository  materiaRepository;
    private final ProfesorRepository profesorRepository;
    private final EventoRepository   eventoRepository;

    private static final DateTimeFormatter TIME_FMT = DateTimeFormatter.ofPattern("HH:mm");

    @Override
    @Transactional(readOnly = true)
    public HorarioDto buscarSesion(Long sesionId) {
        return HorarioDto.fromEntity(
            horarioRepository.findById(sesionId)
                .orElseThrow(() -> new ResourceNotFoundException("Sesión de Horario", "id", sesionId))
        );
    }

    @Override
    @Transactional(readOnly = true)
    public List<HorarioDto> findHorarioProfesor(Long profesorId) {
        return horarioRepository.findByProfesorId(profesorId).stream()
            .map(HorarioDto::fromEntity)
            .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<HorarioDto> findHorarioAlumno(Long alumnoId) {
        return horarioRepository.findHorarioByAlumnoId(alumnoId).stream()
            .map(HorarioDto::fromEntity)
            .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<HorarioDto> findByMateriaId(Long materiaId) {
        return horarioRepository.findByMateriaId(materiaId).stream()
            .map(HorarioDto::fromEntity)
            .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<HorarioDto> findByCursoId(Long cursoId) {
        return horarioRepository.findByMateriaCursoId(cursoId).stream()
            .map(HorarioDto::fromEntity)
            .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public HorarioDto create(CreateHorarioRequest request) {
        Materia  materia  = materiaRepository.findById(request.materiaId())
            .orElseThrow(() -> new ResourceNotFoundException("Materia", "id", request.materiaId()));
        Profesor profesor = profesorRepository.findById(request.profesorId())
            .orElseThrow(() -> new ResourceNotFoundException("Profesor", "id", request.profesorId()));

        DayOfWeek dia        = DayOfWeek.valueOf(request.diaSemana().toUpperCase());
        LocalTime  horaInicio = LocalTime.parse(request.horaInicio(), TIME_FMT);
        LocalTime  horaFin    = LocalTime.parse(request.horaFin(), TIME_FMT);

        if (horaFin.isBefore(horaInicio) || horaFin.equals(horaInicio)) {
            throw new IllegalArgumentException("La hora de fin debe ser posterior a la hora de inicio");
        }

        // Detectar conflicto de horario para el mismo profesor
        List<Horario> conflictos = horarioRepository.detectarConflictoHorario(
            request.profesorId(), dia, horaInicio, horaFin
        );
        if (!conflictos.isEmpty()) {
            throw new IllegalArgumentException(
                "El profesor ya tiene una sesión asignada el " + dia +
                " entre " + horaInicio + " y " + horaFin
            );
        }

        // Se podría reactivar si se crea una nueva sesion EXACTAMENTE igual a una inactiva ya existente
        Optional<Horario> optional = horarioRepository.findClonInactivo(request.materiaId(), request.profesorId(), dia, request.aula(), horaInicio, horaFin);
        Horario sesion = optional.orElse(Horario.builder()
            .diaSemana(dia)
            .horaInicio(horaInicio)
            .horaFin(horaFin)
            .aula(request.aula())
            .materia(materia)
            .profesor(profesor)
            .build());

        sesion.setActivo(true);
        Horario guardada = horarioRepository.save(sesion);
        log.info("Sesión de Horario " + (optional.isPresent() ? "reactivada" : "creada") + ": {} {} {}-{} (ID: {})",
            guardada.getDiaSemana(), materia.getNombre(), horaInicio, horaFin, guardada.getId());
        return HorarioDto.fromEntity(guardada);
    }

    @Override
    @Transactional
    public void hide(Long id) {
        Optional<Horario> optional = horarioRepository.findById(id);

        if (!optional.isPresent()) {
            throw new ResourceNotFoundException("Sesión de Horario", "id", id);
        }

        Horario horario = optional.get();
        horario.setActivo(false);

        horarioRepository.save(horario);
        log.info("Sesión de Horario desactivada (ID: {})", id);
    }

    @Override
    @Transactional(readOnly = true)
    public List<AlumnoDto> findAlumnosBySesionId(Long horarioSesionId) {
        Horario horarioSesion = horarioRepository.findById(horarioSesionId)
            .orElseThrow(() -> new ResourceNotFoundException("Sesión de Horario", "id", horarioSesionId));
        
        // Obtener únicamente los alumnos de la materia implicada, los del resto del curso no deben aplicar
        return horarioSesion.getMateria().getAlumnos().stream()
            .map(AlumnoDto::fromEntity)
            .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public HorarioDto findProximaSesion(Long profesorId) {
        LocalDate hoy = LocalDate.now();
        // B3-1: Ignorar días festivos
        if (eventoRepository.findByFecha(hoy).stream().anyMatch(e -> "FESTIVO".equalsIgnoreCase(e.getTipo()))) {
            log.info("Hoy es festivo, no se generan clases.");
            return null;
        }

        LocalTime ahora = LocalTime.now();
        DayOfWeek dia = hoy.getDayOfWeek();
        
        return horarioRepository.findByProfesorIdAndDiaSemana(profesorId, dia)
            .stream()
            .filter(c -> ahora.isBefore(c.getHoraFin()))
            .findFirst()
            .map(HorarioDto::fromEntity)
            .orElse(null);
    }
}
