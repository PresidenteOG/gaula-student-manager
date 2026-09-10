package com.gaula.repository;

import com.gaula.entity.Asistencia;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface AsistenciaRepository extends JpaRepository<Asistencia, Long> {

    List<Asistencia> findByAlumnoId(Long alumnoId);

    Optional<Asistencia> findByAlumnoIdAndClaseId(Long alumnoId, Long claseId);

    /** Historial de clases de un profesor — JOIN FETCH evita N+1 */
    @Query("SELECT a FROM Asistencia a WHERE a.clase.horario.id = :sessionId AND a.fecha = :fecha")
    List<Asistencia> findBySessionIdAndFecha(Long sessionId, LocalDate fecha);

    /** Historial de clases de un profesor — JOIN FETCH evita N+1 */
    @Query("SELECT DISTINCT a FROM Asistencia a " +
           "LEFT JOIN FETCH a.clase c " +
           "LEFT JOIN FETCH c.profesor " +
           "LEFT JOIN FETCH c.materia m " +
           "LEFT JOIN FETCH m.curso " +
           "WHERE c.profesor.id = :profesorId")
    List<Asistencia> findByClaseProfesorId(@Param("profesorId") Long profesorId);
}
