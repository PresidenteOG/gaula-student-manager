package com.gaula.repository;

import com.gaula.entity.Alumno;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repositorio JPA para la entidad Alumno.
 * Extiende JpaRepository que proporciona CRUD completo y paginación.
 */
@Repository
public interface AlumnoRepository extends JpaRepository<Alumno, Long> {

    /** Busca un alumno por su nombre de usuario (login). */
    Optional<Alumno> findByUsername(String username);

    /** Verifica si ya existe un alumno con ese username. */
    boolean existsByUsername(String username);

    /** Verifica si ya existe un alumno con ese email. */
    boolean existsByEmail(String email);

    /** Busca un alumno por email. */
    Optional<Alumno> findByEmail(String email);

    /**
     * Obtiene todos los alumnos de un curso concreto,
     * ordenados por apellidos para las listas de clase.
     */
    List<Alumno> findByCursoIdOrderByApellidosAsc(Long cursoId);

    /**
     * Obtiene todos los alumnos activos de un curso.
     * Excluye los alumnos DE_BAJA e INACTIVOS de las listas diarias.
     */
    @Query("SELECT a FROM Alumno a WHERE a.curso.id = :cursoId AND a.estado = 'ACTIVO' ORDER BY a.apellidos ASC")
    List<Alumno> findActivosByCursoId(@Param("cursoId") Long cursoId);

    /**
     * Busca alumnos por nombre o apellidos (búsqueda parcial, case-insensitive).
     * Usado en la barra de búsqueda de la pantalla Alumnos.
     */
    @Query("SELECT a FROM Alumno a WHERE LOWER(a.nombre) LIKE LOWER(CONCAT('%', :busqueda, '%')) " +
           "OR LOWER(a.apellidos) LIKE LOWER(CONCAT('%', :busqueda, '%')) " +
           "ORDER BY a.apellidos ASC")
    org.springframework.data.domain.Page<Alumno> buscarPorNombreOApellidos(@Param("busqueda") String busqueda, org.springframework.data.domain.Pageable pageable);

    @Query("SELECT a FROM Alumno a WHERE " +
           "(:cursoId IS NULL OR a.curso.id = :cursoId) AND " +
           "(:busqueda IS NULL OR LOWER(a.nombre) LIKE LOWER(CONCAT('%', :busqueda, '%')) OR LOWER(a.apellidos) LIKE LOWER(CONCAT('%', :busqueda, '%'))) " +
           "ORDER BY a.apellidos ASC")
    org.springframework.data.domain.Page<Alumno> buscarAvanzado(@Param("busqueda") String busqueda, @Param("cursoId") Long cursoId, org.springframework.data.domain.Pageable pageable);

    /**
     * Obtiene todos los alumnos matriculados en una materia concreta.
     * Útil para el control de asistencia por materia.
     */
    @Query("SELECT a FROM Alumno a JOIN a.materias m WHERE m.id = :materiaId ORDER BY a.apellidos ASC")
    List<Alumno> findByMateriaId(@Param("materiaId") Long materiaId);

    /** Alumnos sin curso asignado (para selector de matriculación). */
    List<Alumno> findByCursoIsNullOrderByApellidosAsc();
}
