package com.gaula.repository;

import com.gaula.entity.Profesor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repositorio JPA para la entidad Profesor.
 */
@Repository
public interface ProfesorRepository extends JpaRepository<Profesor, Long> {

    /** Busca un profesor por username para el login JWT. */
    Optional<Profesor> findByUsername(String username);

    /** Verifica si ya existe un profesor con ese username. */
    boolean existsByUsername(String username);

    /** Verifica si ya existe un profesor con ese email. */
    boolean existsByEmail(String email);

    /** Busca un profesor por email. */
    Optional<Profesor> findByEmail(String email);

    /**
     * Lista todos los profesores con un rol concreto.
     * Útil para listar solo admins o solo teachers.
     */
    List<Profesor> findByRolOrderByApellidosAsc(Profesor.RolProfesor rol);

    /**
     * Lista todos los profesores activos (no de baja).
     * Para el selector de sustitutos: solo se pueden asignar profesores ACTIVOS.
     */
    @Query("SELECT p FROM Profesor p WHERE p.estado = 'ACTIVO' ORDER BY p.apellidos ASC")
    List<Profesor> findAllActivos();

    /**
     * Busca el sustituto actualmente asignado a un profesor.
     * El campo sustituto solo tiene valor cuando el profesor está INACTIVO.
     */
    @Query("SELECT p FROM Profesor p WHERE p.sustituto.id = :sustitutoId")
    List<Profesor> findBySustitutoId(@Param("sustitutoId") Long sustitutoId);

    /**
     * Busca profesores que son tutores de algún curso.
     * Mostrar en la pantalla de administración de tutorías.
     */
    @Query("SELECT DISTINCT p FROM Profesor p JOIN p.cursosTutor c ORDER BY p.apellidos ASC")
    List<Profesor> findAllTutores();

    /**
     * Busca profesores por nombre o apellidos (búsqueda parcial).
     */
    @Query("SELECT p FROM Profesor p WHERE " +
           "(:busqueda IS NULL OR LOWER(p.nombre) LIKE LOWER(CONCAT('%', :busqueda, '%')) OR LOWER(p.apellidos) LIKE LOWER(CONCAT('%', :busqueda, '%'))) " +
           "AND (:rol IS NULL OR p.rol = :rol) " +
           "ORDER BY p.apellidos ASC")
    org.springframework.data.domain.Page<Profesor> buscarPorNombreORol(@Param("busqueda") String busqueda, @Param("rol") Profesor.RolProfesor rol, org.springframework.data.domain.Pageable pageable);

    @Query("SELECT p FROM Profesor p WHERE " +
           "(:cursoId IS NULL OR EXISTS (SELECT 1 FROM Horario hr WHERE hr.profesor = p AND hr.materia.curso.id = :cursoId)) " +
           "AND (:busqueda IS NULL OR LOWER(p.nombre) LIKE LOWER(CONCAT('%', :busqueda, '%')) OR LOWER(p.apellidos) LIKE LOWER(CONCAT('%', :busqueda, '%'))) " +
           "AND (:rol IS NULL OR p.rol = :rol) " +
           "ORDER BY p.apellidos ASC")
    org.springframework.data.domain.Page<Profesor> buscarAvanzado(
        @Param("busqueda") String busqueda, 
        @Param("rol") Profesor.RolProfesor rol, 
        @Param("cursoId") Long cursoId, 
        org.springframework.data.domain.Pageable pageable
    );
}
