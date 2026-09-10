package com.gaula.service.reglamento;

import com.gaula.entity.Reglamento;
import com.gaula.exception.ResourceNotFoundException;
import com.gaula.repository.ReglamentoRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.Principal;
import java.util.List;
import java.util.Optional;

/**
 * Implementación del servicio de Cursos (grupos clase).
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class ReglamentoServiceImpl implements ReglamentoService {

    private final ReglamentoRepository  reglamentoRepository;

    @Override
    @Transactional(readOnly = true)
    public List<Reglamento> findAll() {
        return reglamentoRepository.findAllByOrderByFechaCreacionDesc();
    }

    @Override
    public Optional<Reglamento> findActivo() {
        return reglamentoRepository.findByActivoTrue();
    }

    @Override
    @Transactional(readOnly = true)
    public Reglamento findById(Long id) {
        return reglamentoRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Reglamento", "id", id));
    }

    @Override
    @Transactional
    public Reglamento create(Reglamento request, Principal principal) {
        // Desactivar el anterior activo si se marca este como activo
        if (request.isActivo()) {
            reglamentoRepository.findByActivoTrue().ifPresent(r -> {
                r.setActivo(false);
                reglamentoRepository.save(r);
            });
        }
        
        request.setCreadoPor(principal.getName());
        return reglamentoRepository.save(request);
    }

    @Override
    @Transactional
    public Optional<Reglamento> activar(Long id) {
        reglamentoRepository.findByActivoTrue().ifPresent(r -> {
            r.setActivo(false);
            reglamentoRepository.save(r);
        });
        
        return reglamentoRepository.findById(id).map(r -> {
            r.setActivo(true);
            return reglamentoRepository.save(r);
        });
    }

    @Override
    @Transactional
    public void delete(Long id) {
        Reglamento reglamento = reglamentoRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Reglamento", "id", id));
        reglamentoRepository.delete(reglamento);
        log.info("Reglamento eliminado (ID: {})", id);
    }
}
