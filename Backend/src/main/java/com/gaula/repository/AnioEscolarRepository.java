package com.gaula.repository;

import com.gaula.entity.AnioEscolar;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repositorio JPA para CursoEscolar (año académico + turno).
 */
@Repository
public interface AnioEscolarRepository extends JpaRepository<AnioEscolar, Long> {

    /** Lista todos los AnioEscolar activos (año actual en uso). */
    List<AnioEscolar> findByActivoTrueOrderByDenominacionAsc();

    /**
     * Busca el AñoEscolar activo.
     * Usado para obtener el año escolar activo.
     */
    Optional<AnioEscolar> findByActivoTrue();

    /** Lista todos los AnioEscolar para una denominación de año (ej: "24/25"). */
    @Query("SELECT ae FROM AnioEscolar ae WHERE ae.denominacion = :denominacion ORDER BY ae.denominacion ASC")
    List<AnioEscolar> findByDenominacion(@Param("denominacion") String denominacion);
}
