package com.gaula.service.plantilla_materia;

import com.gaula.domain.MateriaPlantillaDto;
import com.gaula.dto.plantilla.CreateMateriaPlantillaRequest;

import java.util.List;

/**
 * Contrato del servicio de Materias (módulos instanciados en un Curso).
 */
public interface MateriaPlantillaService {

    /** Lista todas las materias plantilla de un curso plantilla. */
    List<MateriaPlantillaDto> findByCursoPlantillaId(Long cursoId);

    /** Obtiene una materia plantilla por ID. */
    MateriaPlantillaDto findById(Long id);

    /** Crea una nueva materia plantilla en un curso. */
    MateriaPlantillaDto create(CreateMateriaPlantillaRequest request);

    /** Actualiza la materia plantilla. */
    MateriaPlantillaDto update(Long id, CreateMateriaPlantillaRequest request);

    /** Elimina la materia plantilla. */
    void delete(Long id);
}
