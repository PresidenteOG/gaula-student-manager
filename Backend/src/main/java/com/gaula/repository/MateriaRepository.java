package com.gaula.repository;

import com.gaula.entity.Materia;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Repositorio JPA para Materia (módulo instanciado en un Curso).
 */
@Repository
public interface MateriaRepository extends JpaRepository<Materia, Long> {

    /** Lista todas las materias de un Curso ordenadas por código. */
    List<Materia> findByCursoIdOrderByCodigoAsc(Long cursoId);

    /** Verifica si ya existe una materia con ese código en este curso. */
    boolean existsByCodigoAndCursoId(String codigo, Long cursoId);

    /**
     * Obtiene las materias de un profesor (a través de las clases).
     * Para mostrar al profesor las asignaturas que imparte.
     */
    @Query("SELECT DISTINCT hr.materia FROM Horario hr WHERE hr.profesor.id = :profesorId")
    List<Materia> findByProfesorId(@Param("profesorId") Long profesorId);
}
