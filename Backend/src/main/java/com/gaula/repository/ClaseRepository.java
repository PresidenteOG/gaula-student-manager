package com.gaula.repository;

import com.gaula.entity.Clase;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.Set;

/**
 * Repositorio JPA para Horario (sesión semanal de una Materia).
 */
@Repository
public interface ClaseRepository extends JpaRepository<Clase, Long> {

    List<Clase> findByProfesorId(Long profesorId);
 
    // En desuso actualmente, en un futuro se podría usar para el detail de curso
    List<Clase> findByMateriaCursoId(Long cursoId);
 
    List<Clase> findByHorarioId(Long horarioId);

    Optional<Clase> findByHorarioIdAndFecha(Long horarioId, LocalDate fecha);

    @Query(
        "SELECT c.horario.id FROM Clase c WHERE c.profesor.id = :profesorId AND c.fecha = :fecha"
    )
    Set<Long> findHorarioIdsByProfesorAndFecha(Long profesorId, LocalDate fecha);

    @Query(
        "SELECT c.id, " +                                 // row[0] (Long)
        "c.fecha, " +                                     // row[1] (LocalDateTime)
        "c.profesor, " +                                  // row[2] (Profesor)
        "COALESCE(c.materia.nombre, 'Sin Materia'), " +   // row[3] (String)
        "COALESCE(c.materia.curso.codigoGrupo, ''), " +   // row[4] (String)
        "c.horario, " +                                   // row[5] (Horario)
        "c.aula, " +                                      // row[6] (String)
        "(SELECT COUNT(al) FROM c.materia.alumnos al), " +// row[7] (Long) -> Total alumnos matriculados
        "CAST(SUM(CASE WHEN a.estado = 'AUSENTE' OR a.estado = 'JUSTIFICADO' THEN 1 ELSE 0 END) AS int), " + // row[8] (Integer) -> Ausentes
        "CAST(SUM(CASE WHEN a.estado = 'RETRASO' THEN 1 ELSE 0 END) AS int) " + // row[9] (Integer) -> Retrasos
        "FROM Clase c " +
        "LEFT JOIN c.faltas a " + // Usamos LEFT JOIN por si hay clases creadas que aún no tienen el pase de lista hecho
        "GROUP BY c.id, c.fecha, c.profesor.nombre, c.profesor.apellidos, c.materia.nombre, c.materia.curso.codigoGrupo, c.horario.horaInicio, c.horario.horaFin, c.aula " +
        "ORDER BY c.fecha DESC, c.horario.horaInicio DESC, c.id DESC"
    )
    List<Object[]> findGlobalHistory();

    long countByMateriaId(Long materiaId);

    @Query("SELECT COUNT(c) FROM Clase c " +
       "JOIN c.materia m " +
       "JOIN m.alumnos a " +
       "WHERE a.id = :alumnoId")
    long countByAlumnoId(@Param("alumnoId") Long alumnoId);
}
