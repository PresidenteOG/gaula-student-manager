package com.gaula.repository;

import com.gaula.entity.MateriaPlantilla;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repositorio JPA para MateriaPlantilla (módulos base de un ciclo).
 */
@Repository
public interface MateriaPlantillaRepository extends JpaRepository<MateriaPlantilla, Long> {

    /** Lista todos los módulos de un CursoPlantilla ordenados por código. */
    List<MateriaPlantilla> findByCursoPlantillaIdOrderByCodigoAsc(Long cursoPlantillaId);

    /** Busca un módulo con ese código dentro del ciclo. */
    Optional<MateriaPlantilla> findByCodigoAndCursoPlantillaId(String codigo, Long cursoPlantillaId);

    /** Verifica si ya existe un módulo con ese código dentro del ciclo. */
    boolean existsByCodigoAndCursoPlantillaId(String codigo, Long cursoPlantillaId);
}
