package com.gaula.repository;

import com.gaula.entity.Horario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.DayOfWeek;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

/**
 * Repositorio JPA para Horario (sesión semanal de una Materia).
 */
@Repository
public interface HorarioRepository extends JpaRepository<Horario, Long> {

    /**
     * Obtiene el horario completo de un profesor (todas sus sesiones).
     * Ordenado por día y hora de inicio.
     */
    @Query("SELECT sh FROM Horario sh WHERE sh.activo = true AND sh.profesor.id = :profesorId " +
           "ORDER BY sh.diaSemana ASC, sh.horaInicio ASC")
    List<Horario> findByProfesorId(Long profesorId);

    /**
     * Obtiene el horario de un profesor para un día concreto.
     * Usado en la pantalla "Pasar Lista" para mostrar las sesiones de hoy.
     */
    @Query("SELECT sh FROM Horario sh WHERE sh.activo = true AND sh.profesor.id = :profesorId " +
           "AND sh.diaSemana = :diaSemana ORDER BY sh.horaInicio ASC")
    List<Horario> findByProfesorIdAndDiaSemana(Long profesorId, DayOfWeek diaSemana);

    /**
     * Obtiene el horario de un alumno a través de su curso y materias.
     * Un alumno ve las clases de las materias en las que está matriculado.
     */
    @Query("SELECT sh FROM Horario sh WHERE sh.activo = true AND sh.materia.id IN " +
           "(SELECT m.id FROM Alumno a JOIN a.materias m WHERE a.id = :alumnoId) " +
           "ORDER BY sh.diaSemana ASC, sh.horaInicio ASC")
    List<Horario> findHorarioByAlumnoId(@Param("alumnoId") Long alumnoId);

    /**
     * Obtiene todas las sesiones de una materia concreta.
     */
    @Query("SELECT sh FROM Horario sh WHERE sh.activo = true AND sh.materia.id = :materiaId " +
           "ORDER BY sh.diaSemana ASC, sh.horaInicio ASC")
    List<Horario> findByMateriaId(Long materiaId);

    /**
     * Detecta conflictos de horario para un profesor:
     * misma hora y día con profesor diferente usaría el mismo espacio.
     */
    @Query("SELECT hr FROM Horario hr WHERE hr.activo = true " + 
           "AND hr.profesor.id = :profesorId " +
           "AND hr.diaSemana = :dia " +
           "AND hr.horaInicio < :horaFin AND hr.horaFin > :horaInicio")
    List<Horario> detectarConflictoHorario(
        @Param("profesorId") Long profesorId,
        @Param("dia") DayOfWeek dia,
        @Param("horaInicio") LocalTime horaInicio,
        @Param("horaFin") LocalTime horaFin
    );

    @Query("SELECT sh FROM Horario sh WHERE sh.activo = true AND sh.materia.curso.id = :cursoId " +
           "ORDER BY sh.diaSemana ASC, sh.horaInicio ASC")
    List<Horario> findByMateriaCursoId(Long cursoId);

    @Query("SELECT hr FROM Horario hr WHERE hr.activo = false " + 
           "AND hr.materia.id = :materiaId " +
           "AND hr.profesor.id = :profesorId " +
           "AND hr.diaSemana = :dia " +
           "AND hr.aula = :aula " +
           "AND hr.horaInicio = :horaInicio AND hr.horaFin = :horaFin")
    Optional<Horario> findClonInactivo(
        @Param("materiaId") Long materiaId,
        @Param("profesorId") Long profesorId,
        @Param("dia") DayOfWeek dia,
        @Param("aula") String aula,
        @Param("horaInicio") LocalTime horaInicio,
        @Param("horaFin") LocalTime horaFin
    );
}
