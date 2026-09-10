package com.gaula.service.ano_escolar;

import com.gaula.domain.AnioEscolarDto;
import com.gaula.dto.anio_escolar.CreateAnioEscolarRequest;
import com.gaula.dto.anio_escolar.UpdateAnioEscolarRequest;

import java.util.List;

/**
 * Contrato del servicio de CursosEscolares (años académicos + turno).
 */
public interface AñoEscolarService {

    /** Lista todos los años escolares. */
    List<AnioEscolarDto> findAll();

    /** Lista solo los años escolares activos. */
    List<AnioEscolarDto> findActivos();

    /** Obtiene un año escolar por ID. */
    AnioEscolarDto findById(Long id);

    /** Crea un nuevo año escolar. */
    AnioEscolarDto create(CreateAnioEscolarRequest request);

    /** Activa un año escolar y desactiva el anterior del mismo ciclo y turno. */
    AnioEscolarDto activar(Long id);

    /** Desactiva un año escolar. */
    AnioEscolarDto desactivar(Long id);

    /** Actualiza un año escolar existente. */
    AnioEscolarDto update(Long id, UpdateAnioEscolarRequest request);

    /** Elimina un año escolar. */
    void delete(Long id);
}
