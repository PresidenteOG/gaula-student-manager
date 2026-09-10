package com.gaula.service.plantilla_materia;

import com.gaula.domain.MateriaPlantillaDto;
import com.gaula.dto.plantilla.CreateMateriaPlantillaRequest;
import com.gaula.entity.CursoPlantilla;
import com.gaula.entity.MateriaPlantilla;
import com.gaula.exception.ResourceNotFoundException;
import com.gaula.repository.CursoPlantillaRepository;
import com.gaula.repository.MateriaPlantillaRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.List;
import java.util.stream.Collectors;

/**
 * Implementación del servicio de Materias.
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class MateriaPlantillaServiceImpl implements MateriaPlantillaService {

    private final MateriaPlantillaRepository   plantillaRepository;
    private final CursoPlantillaRepository     cursoRepository;

    @Override
    @Transactional(readOnly = true)
    public List<MateriaPlantillaDto> findByCursoPlantillaId(Long cursoId) {
        return plantillaRepository.findByCursoPlantillaIdOrderByCodigoAsc(cursoId).stream()
            .map(MateriaPlantillaDto::fromEntity)
            .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public MateriaPlantillaDto findById(Long id) {
        return MateriaPlantillaDto.fromEntity(
            plantillaRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("MateriaPlantilla", "id", id))
        );
    }

    @Override
    @Transactional
    public MateriaPlantillaDto create(CreateMateriaPlantillaRequest request) {
        CursoPlantilla cursoPlantilla = cursoRepository.findById(request.cursoPlantillaId())
            .orElseThrow(() -> new ResourceNotFoundException("CursoPlantilla", "id", request.cursoPlantillaId()));

        if (plantillaRepository.existsByCodigoAndCursoPlantillaId(request.codigo(), request.cursoPlantillaId())) {
            throw new IllegalArgumentException(
                "Ya existe una materia con código '" + request.codigo() + "' en el curso plantilla " + cursoPlantilla.getCodigo()
            );
        }

        MateriaPlantilla plantilla = MateriaPlantilla.builder()
            .codigo(request.codigo())
            .nombre(request.nombre())
            .horasTotales(request.horasTotales())
            .cursoPlantilla(cursoPlantilla)
            .build();

        MateriaPlantilla guardada = plantillaRepository.save(plantilla);
        log.info("MateriaPlantilla creada: {} en {} (ID: {})", guardada.getNombre(), cursoPlantilla.getCodigo(), guardada.getId());
        return MateriaPlantillaDto.fromEntity(guardada);
    }

    @Override
    @Transactional
    public MateriaPlantillaDto update(Long id, CreateMateriaPlantillaRequest request) {
        MateriaPlantilla materia = plantillaRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("MateriaPlantilla", "id", id));

        if (StringUtils.hasText(request.codigo()))  materia.setCodigo(request.codigo());
        if (StringUtils.hasText(request.nombre()))  materia.setNombre(request.nombre());
        if (request.horasTotales() > 0)             materia.setHorasTotales(request.horasTotales());

        return MateriaPlantillaDto.fromEntity(plantillaRepository.save(materia));
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (!plantillaRepository.existsById(id)) {
            throw new ResourceNotFoundException("MateriaPlantilla", "id", id);
        }
        plantillaRepository.deleteById(id);
        log.info("MateriaPlantilla eliminada (ID: {})", id);
    }
}
