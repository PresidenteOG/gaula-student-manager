package com.gaula.service.evento;

import com.gaula.controller.EventoController.EventoRequest;
import com.gaula.entity.Evento;

import java.util.List;

/**
 * Contrato del servicio de Cursos (grupos clase instanciados).
 */
public interface EventoService {

    List<Evento> findAll();

    List<Evento> findByCursoId(Long cursoId);

    Evento findById(Long id);

    Evento create(EventoRequest request);

    void delete(Long id);
}
