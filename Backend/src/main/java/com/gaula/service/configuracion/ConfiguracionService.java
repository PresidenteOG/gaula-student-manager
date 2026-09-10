package com.gaula.service.configuracion;

import com.gaula.entity.ConfiguracionSistema;

import java.util.List;
import java.util.Optional;

/**
 * Contrato del servicio de Configuración del Sistema.
 * El Administrador puede leer y modificar pares clave-valor de configuración.
 */
public interface ConfiguracionService {

    /** Obtiene el valor de una configuración por su clave. */
    Optional<String> obtenerValor(String clave);

    /** Obtiene la entidad completa de una configuración. */
    Optional<ConfiguracionSistema> obtenerPorClave(String clave);

    /** Lista todas las configuraciones del sistema. */
    List<ConfiguracionSistema> findAll();

    /**
     * Crea o actualiza una configuración.
     * Si ya existe la clave, actualiza el valor. Si no, la crea.
     */
    ConfiguracionSistema guardar(String clave, String valor, String descripcion);

    /** Elimina una configuración por clave. */
    void eliminar(String clave);
}
