package com.gaula.repository;

import com.gaula.entity.CursoPlantilla;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

/**
 * Repositorio JPA para CursoPlantilla (DAM, DAW, ASIX, SMIX...).
 */
@Repository
public interface CursoPlantillaRepository extends JpaRepository<CursoPlantilla, Long> {

    /** Busca plantilla por código único (DAM, DAW...). */
    Optional<CursoPlantilla> findByCodigo(String codigo);

    /** Verifica si ya existe una plantilla con ese código. */
    boolean existsByCodigo(String codigo);
}
