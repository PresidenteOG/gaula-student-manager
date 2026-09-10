package com.gaula.service.ano_escolar;

import com.gaula.domain.AnioEscolarDto;
import com.gaula.dto.anio_escolar.CreateAnioEscolarRequest;
import com.gaula.dto.anio_escolar.UpdateAnioEscolarRequest;
import com.gaula.entity.AnioEscolar;
import com.gaula.entity.Curso;
import com.gaula.exception.ResourceNotFoundException;
import com.gaula.repository.AnioEscolarRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

/**
 * Implementación del servicio de CursosEscolares.
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class AñoEscolarServiceImpl implements AñoEscolarService {

    private final AnioEscolarRepository  añoEscolarRepository;

    @Override
    @Transactional(readOnly = true)
    public List<AnioEscolarDto> findAll() {
        return añoEscolarRepository.findAll().stream()
            .map(AnioEscolarDto::fromEntity)
            .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<AnioEscolarDto> findActivos() {
        return añoEscolarRepository.findByActivoTrueOrderByDenominacionAsc().stream()
            .map(AnioEscolarDto::fromEntity)
            .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public AnioEscolarDto findById(Long id) {
        return AnioEscolarDto.fromEntity(
            añoEscolarRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("AnioEscolar", "id", id))
        );
    }

    @Override
    @Transactional
    public AnioEscolarDto create(CreateAnioEscolarRequest request) {
        String denominacion = request.denominacion() != null && !request.denominacion().isBlank() 
            ? request.denominacion() 
            : request.nombre();

        // Check for existing year with same denomination
        var existente = añoEscolarRepository.findAll().stream()
            .filter(a -> a.getDenominacion().equalsIgnoreCase(denominacion))
            .findFirst();

        if (existente.isPresent()) {
            AnioEscolar ae = existente.get();
            if (request.activarComoActual()) {
                activar(ae.getId());
            }

            log.info("AñoEscolar ya existe, reutilizando: {} (ID: {})", denominacion, ae.getId());
            return AnioEscolarDto.fromEntity(ae);
        }

        AnioEscolar nuevo = AnioEscolar.builder()
            .denominacion(denominacion)
            .descripcion(request.descripcion())
            .activo(request.activarComoActual())
            .fechaInicio(request.fechaInicio())
            .fechaFin(request.fechaFin())
            .build();

        // Si se activa como actual, desactivar el anterior
        if (request.activarComoActual()) {
            añoEscolarRepository
                .findByActivoTrue()
                .ifPresent(anterior -> {
                    anterior.setActivo(false);
                    añoEscolarRepository.save(anterior);
                    log.info("AnioEscolar anterior desactivado: ID {}", anterior.getId());
                });
        }

        AnioEscolar guardado = añoEscolarRepository.save(nuevo);

        log.info("AñoEscolar creado: {} (ID: {})", denominacion, guardado.getId());
        return AnioEscolarDto.fromEntity(guardado);
    }

    @Override
    @Transactional
    public AnioEscolarDto activar(Long id) {
        AnioEscolar ae = añoEscolarRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("AnioEscolar", "id", id));

        // Desactivar absolutamente todos los años escolares de otras denominaciones
        añoEscolarRepository.findAll().forEach(otro -> {
            if (!otro.getDenominacion().equalsIgnoreCase(ae.getDenominacion())) {
                if (Boolean.TRUE.equals(otro.getActivo())) {
                    otro.setActivo(false);
                    añoEscolarRepository.save(otro);
                }
            }
        });

        if (!Boolean.TRUE.equals(ae.getActivo())) {
            ae.setActivo(true);
            añoEscolarRepository.save(ae);
        }

        return AnioEscolarDto.fromEntity(ae);
    }

    @Override
    @Transactional
    public AnioEscolarDto desactivar(Long id) {
        AnioEscolar ae = añoEscolarRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("AnioEscolar", "id", id));

        if (Boolean.TRUE.equals(ae.getActivo())) {
            ae.setActivo(false);
            añoEscolarRepository.save(ae);
        }

        return AnioEscolarDto.fromEntity(ae);
    }

    @Override
    @Transactional
    public AnioEscolarDto update(Long id, UpdateAnioEscolarRequest request) {
        AnioEscolar ae = añoEscolarRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("AnioEscolar", "id", id));

        if (request.denominacion() != null) ae.setDenominacion(request.denominacion());
        if (request.nombre() != null) ae.setDenominacion(request.nombre());
        if (request.fechaInicio() != null) ae.setFechaInicio(request.fechaInicio());
        if (request.fechaFin() != null) ae.setFechaFin(request.fechaFin());
        if (request.descripcion() != null) ae.setDescripcion(request.descripcion());

        return AnioEscolarDto.fromEntity(añoEscolarRepository.save(ae));
    }

    @Override
    @Transactional
    public void delete(Long id) {
        AnioEscolar ae = añoEscolarRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("AnioEscolar", "id", id));

        // Safeguard: Check if any of this year has courses (grupos) with students
        for (Curso curso : ae.getCursos()) {
            if (curso.getAlumnos() != null && !curso.getAlumnos().isEmpty()) {
                throw new IllegalStateException("No se puede eliminar el año '" + ae.getDenominacion() + 
                    "' porque el curso '" + curso.getCodigoGrupo() + "' tiene estudiantes matriculados.");
            }
        }

        añoEscolarRepository.deleteById(id);
        log.info("Año Académico eliminado completamente: ID {}", id);
    }
}
