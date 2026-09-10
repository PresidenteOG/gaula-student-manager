package com.gaula.repository;

import com.gaula.entity.Curso;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Repositorio JPA para Curso (grupo clase real: "1º DAM Mañana 24/25").
 */
@Repository
public interface CursoRepository extends JpaRepository<Curso, Long> {

    /** Lista todos los cursos de un AnioEscolar dado. */
    @Query("SELECT c FROM Curso c WHERE c.anioEscolar.id = :anioEscolarId ORDER BY c.anioEscolar.denominacion ASC")
    List<Curso> findByAnioEscolarOrderByAnoAsc(Long anioEscolarId);

    /**
     * Obtiene los cursos de los que un profesor es tutor.
     * Usado en el panel del dashboard del profesor.
     */
    List<Curso> findByTutorId(Long tutorId);

    /**
     * Obtiene todos los cursos de un AnioEscolar activo.
     * Usado en la pantalla "Cursos" de administración.
     */
    @Query("SELECT c FROM Curso c WHERE c.anioEscolar.activo = true ORDER BY c.anioEscolar.denominacion ASC")
    List<Curso> findAllCursosActivos();

    /**
     * Obtiene el curso al que pertenece un alumno concreto.
     */
    @Query("SELECT a.curso FROM Alumno a WHERE a.id = :alumnoId")
    Curso findCursoByAlumnoId(@Param("alumnoId") Long alumnoId);

    /** Verifica si ya existe un curso con el mismo código en un año escolar. */
    boolean existsByCodigoGrupoAndAnioEscolarId(String codigoGrupo, Long anioEscolarId);
}
