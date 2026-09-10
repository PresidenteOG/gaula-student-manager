package com.gaula.service.plantilla_curso;

import com.gaula.domain.CursoPlantillaDto;

import java.util.List;

/**
 * Contrato del servicio de Cursos (grupos clase instanciados).
 */
public interface CursoPlantillaService {

    /** Lista todos los cursos activos del año escolar activo. */
    List<CursoPlantillaDto> findAll();

    /** Obtiene un curso por ID con todos sus datos. */
    CursoPlantillaDto findById(Long id);

    /** Obtiene un curso por Código irrepetible con todos sus datos. */
    CursoPlantillaDto findByCodigo(String codigo);

    /** Crea un nuevo curso. */
    CursoPlantillaDto create(CursoPlantillaDto request);

    /** Crea un nuevo curso. */
    CursoPlantillaDto update(Long id, CursoPlantillaDto request);

    /** Elimina un curso (solo si no tiene alumnos matriculados). */
    void delete(Long id);
}
