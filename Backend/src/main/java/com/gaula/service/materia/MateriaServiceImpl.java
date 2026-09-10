package com.gaula.service.materia;

import com.gaula.domain.MateriaDto;
import com.gaula.dto.materia.CreateMateriaRequest;
import com.gaula.entity.Curso;
import com.gaula.entity.Materia;
import com.gaula.entity.MateriaPlantilla;
import com.gaula.exception.ResourceNotFoundException;
import com.gaula.repository.CursoRepository;
import com.gaula.repository.MateriaPlantillaRepository;
import com.gaula.repository.MateriaRepository;

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
public class MateriaServiceImpl implements MateriaService {

    private final MateriaRepository         materiaRepository;
    private final CursoRepository           cursoRepository;
    private final MateriaPlantillaRepository plantillaRepository;

    @Override
    @Transactional(readOnly = true)
    public List<MateriaDto> findByCursoId(Long cursoId) {
        return materiaRepository.findByCursoIdOrderByCodigoAsc(cursoId).stream()
            .map(MateriaDto::fromEntity)
            .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public MateriaDto findById(Long id) {
        return MateriaDto.fromEntity(
            materiaRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Materia", "id", id))
        );
    }

    @Override
    @Transactional(readOnly = true)
    public List<MateriaDto> findByProfesorId(Long profesorId) {
        return materiaRepository.findByProfesorId(profesorId).stream()
            .map(MateriaDto::fromEntity)
            .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public MateriaDto create(CreateMateriaRequest request) {
        Curso curso = cursoRepository.findById(request.cursoId())
            .orElseThrow(() -> new ResourceNotFoundException("Curso", "id", request.cursoId()));

        if (materiaRepository.existsByCodigoAndCursoId(request.codigo(), request.cursoId())) {
            throw new IllegalArgumentException(
                "Ya existe una materia con código '" + request.codigo() + "' en el curso " + curso.getCodigoGrupo()
            );
        }

        MateriaPlantilla plantilla = null;
        if (request.materiaPlantillaId() != null) {
            plantilla = plantillaRepository.findById(request.materiaPlantillaId()).orElse(null);
        }

        Materia materia = Materia.builder()
            .nombre(request.nombre())
            .codigo(request.codigo())
            .horasTotales(request.horasTotales())
            .curso(curso)
            .materiaPlantilla(plantilla)
            .build();

        Materia guardada = materiaRepository.save(materia);
        log.info("Materia creada: {} en {} (ID: {})", guardada.getNombre(), curso.getCodigoGrupo(), guardada.getId());
        return MateriaDto.fromEntity(guardada);
    }

    @Override
    @Transactional
    public MateriaDto update(Long id, CreateMateriaRequest request) {
        Materia materia = materiaRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Materia", "id", id));

        if (StringUtils.hasText(request.nombre()))  materia.setNombre(request.nombre());
        if (StringUtils.hasText(request.codigo()))  materia.setCodigo(request.codigo());
        if (request.horasTotales() > 0)             materia.setHorasTotales(request.horasTotales());

        return MateriaDto.fromEntity(materiaRepository.save(materia));
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (!materiaRepository.existsById(id)) {
            throw new ResourceNotFoundException("Materia", "id", id);
        }
        materiaRepository.deleteById(id);
        log.info("Materia eliminada (ID: {})", id);
    }
}
