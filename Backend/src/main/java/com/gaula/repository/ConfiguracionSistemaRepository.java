package com.gaula.repository;

import com.gaula.entity.ConfiguracionSistema;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

/**
 * Repositorio JPA para ConfiguracionSistema (pares clave-valor de configuración).
 *
 * Permite al Administrador leer y modificar configuraciones como
 * la provincia de festivos, el nombre del centro, etc.
 */
@Repository
public interface ConfiguracionSistemaRepository extends JpaRepository<ConfiguracionSistema, Long> {

    /**
     * Busca el valor de una configuración por su clave.
     * Uso: configuracionRepo.findByClave("provincia_festivos")
     */
    Optional<ConfiguracionSistema> findByClave(String clave);

    /** Verifica si existe una configuración con esa clave. */
    boolean existsByClave(String clave);
}
