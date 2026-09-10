package com.gaula.service.materia;

import com.gaula.domain.MateriaDto;
import com.gaula.dto.materia.CreateMateriaRequest;

import java.util.List;

/**
 * Contrato del servicio de Materias (módulos instanciados en un Curso).
 */
public interface MateriaService {

    /** Lista todas las materias de un curso. */
    List<MateriaDto> findByCursoId(Long cursoId);

    /** Obtiene una materia por ID. */
    MateriaDto findById(Long id);

    /** Lista las materias que imparte un profesor (a través de sus clases). */
    List<MateriaDto> findByProfesorId(Long profesorId);

    /** Crea una nueva materia en un curso. */
    MateriaDto create(CreateMateriaRequest request);

    /** Actualiza la materia. */
    MateriaDto update(Long id, CreateMateriaRequest request);

    /** Elimina la materia y sus clases asociadas. */
    void delete(Long id);
}
