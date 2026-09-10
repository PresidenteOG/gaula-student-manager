package com.gaula.repository;

import com.gaula.entity.Festivo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface FestivoRepository extends JpaRepository<Festivo, Long> {
    List<Festivo> findByAnio(Integer anio);
    boolean existsByAnio(Integer anio);

    /**
     * Elimina primero los registros de la tabla de provincias (ElementCollection)
     * y luego los festivos del año indicado, evitando violaciones de FK.
     */
    @Modifying
    @Query(value = "DELETE FROM festivo_provincia WHERE festivo_id IN " +
                   "(SELECT id FROM festivo WHERE anio = :anio)", nativeQuery = true)
    void deleteProvinciasByAnio(@Param("anio") int anio);

    @Modifying
    @Query("DELETE FROM Festivo f WHERE f.anio = :anio")
    void deleteByAnio(@Param("anio") int anio);
}
