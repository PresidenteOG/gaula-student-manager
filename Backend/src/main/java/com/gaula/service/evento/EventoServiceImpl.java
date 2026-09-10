package com.gaula.service.evento;

import com.gaula.controller.EventoController.EventoRequest;
import com.gaula.entity.Evento;
import com.gaula.exception.ResourceNotFoundException;
import com.gaula.repository.CursoRepository;
import com.gaula.repository.EventoRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Implementación del servicio de Cursos (grupos clase).
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class EventoServiceImpl implements EventoService {

    private final EventoRepository eventoRepo;
    private final CursoRepository  cursoRepository;

    @Override
    @Transactional(readOnly = true)
    public List<Evento> findAll() {
        return eventoRepo.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Evento> findByCursoId(Long cursoId) {
        List<Evento> eventos = eventoRepo.findByCursoIdIsNull();
        eventos.addAll(eventoRepo.findByCursoId(cursoId));
        return eventos;
    }

    @Override
    @Transactional(readOnly = true)
    public Evento findById(Long id) {
        return eventoRepo.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Evento", "id", id));
    }

    @Override
    @Transactional
    public Evento create(EventoRequest request) {
        Evento evento = Evento.builder()
            .titulo(request.titulo())
            .descripcion(request.descripcion())
            .fecha(java.time.LocalDate.parse(request.fecha()))
            .tipo(request.tipo())
            .curso(request.cursoId() != null ? cursoRepository.findById(request.cursoId()).orElse(null) : null)
            .build();
        return eventoRepo.save(evento);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        Evento evento = eventoRepo.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Evento", "id", id));
        eventoRepo.delete(evento);
        log.info("Evento eliminado (ID: {})", id);
    }
}
