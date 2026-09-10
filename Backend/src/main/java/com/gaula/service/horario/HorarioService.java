package com.gaula.service.horario;

import com.gaula.domain.AlumnoDto;
import com.gaula.domain.HorarioDto;
import com.gaula.dto.horario.CreateHorarioRequest;

import java.util.List;

/**
 * Contrato del servicio de horario (sesiones semanales del horario).
 */
public interface HorarioService {
    HorarioDto buscarSesion(Long sesionId);

    /** Horario completo de un profesor (todas sus sesiones de la semana). */
    List<HorarioDto> findHorarioProfesor(Long profesorId);

    /** Horario semanal de un alumno (sesiones de sus materias matriculadas). */
    List<HorarioDto> findHorarioAlumno(Long alumnoId);

    /** Lista todas las sesiones de una materia. */
    List<HorarioDto> findByMateriaId(Long materiaId);

    /** Lista todas las sesiones de un curso completo. */
    List<HorarioDto> findByCursoId(Long cursoId);

    /** Crea una nueva sesión de clase en el horario. */
    HorarioDto create(CreateHorarioRequest request);

    /** Esconde una sesión de clase. */
    void hide(Long id);

    /** Lista alumnos matriculados en la materia de la sesión. */
    List<AlumnoDto> findAlumnosBySesionId(Long claseId);
    
    // Para poder generar próxima clase del profesor
    HorarioDto findProximaSesion(Long profesorId);
}
