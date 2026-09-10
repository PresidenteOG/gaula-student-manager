package com.gaula.service.reglamento;

import com.gaula.entity.Reglamento;

import java.security.Principal;
import java.util.List;
import java.util.Optional;

/**
 * Contrato del servicio de Cursos (grupos clase instanciados).
 */
public interface ReglamentoService {

    List<Reglamento> findAll();

    Optional<Reglamento> findActivo();

    Reglamento findById(Long id);

    Reglamento create(Reglamento request, Principal principal);

    Optional<Reglamento> activar(Long id);

    void delete(Long id);
}

