package com.gaula.service.plantilla_curso;

import com.gaula.domain.CursoPlantillaDto;
import com.gaula.domain.CursoPlantillaDto.MateriaPlantillaResumenDto;
import com.gaula.entity.CursoPlantilla;
import com.gaula.entity.MateriaPlantilla;
import com.gaula.entity.MateriaPlantilla.TipoMateria;
import com.gaula.exception.ResourceNotFoundException;
import com.gaula.repository.CursoPlantillaRepository;
import com.gaula.repository.MateriaPlantillaRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * Implementación del servicio de Cursos (grupos clase).
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class CursoPlantillaServiceImpl implements CursoPlantillaService {

    private final CursoPlantillaRepository       cursoRepository;
    private final MateriaPlantillaRepository   materiaRepository;

    @Override
    @Transactional(readOnly = true)
    public List<CursoPlantillaDto> findAll() {
        return cursoRepository.findAll().stream()
            .map(CursoPlantillaDto::fromEntity)
            .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public CursoPlantillaDto findByCodigo(String codigo) {
        return cursoRepository.findByCodigo(codigo).map(CursoPlantillaDto::fromEntity).orElse(null);
    }

    @Override
    @Transactional(readOnly = true)
    public CursoPlantillaDto findById(Long id) {
        return CursoPlantillaDto.fromEntity(
            cursoRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Curso", "id", id))
        );
    }

    @Override
    @Transactional
    public CursoPlantillaDto create(CursoPlantillaDto request) {
        CursoPlantilla cursoPlantilla = CursoPlantilla.builder()
            .codigo(request.codigo())
            .nombre(request.nombre())
            .descripcion(request.descripcion() != null ? request.descripcion() : null)
            .color(request.color())
            .build();

        CursoPlantilla guardado = cursoRepository.save(cursoPlantilla);
        List<MateriaPlantillaResumenDto> plantillas = request.materias();

        if (plantillas != null) {
            for (MateriaPlantillaResumenDto resumen : plantillas) {
                MateriaPlantilla mp = MateriaPlantilla.builder()
                    .nombre(resumen.nombre())
                    .codigo(resumen.codigo())
                    .horasTotales(resumen.horasTotales())
                    .cursoPlantilla(guardado)
                    .tipo(TipoMateria.valueOf(resumen.tipo()))
                    .build();
                materiaRepository.save(mp);
            }

            log.info("Creadas {} plantillas de materias para el curso plantilla {}", plantillas.size(), guardado.getCodigo());
        }

        log.info("CursoPlantilla creada: (ID: {})", guardado.getId());
        return CursoPlantillaDto.fromEntity(guardado);
    }

    @Override
    @Transactional
    public CursoPlantillaDto update(Long id, CursoPlantillaDto request) {
        CursoPlantilla cursoPlantilla = cursoRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("CursoPlantilla", "id", id));

        if (StringUtils.hasText(request.codigo()))  cursoPlantilla.setCodigo(request.codigo());
        if (StringUtils.hasText(request.nombre()))  cursoPlantilla.setNombre(request.nombre());
        if (StringUtils.hasText(request.color()))   cursoPlantilla.setColor(request.color());
        cursoPlantilla.setDescripcion(request.descripcion());

        CursoPlantilla guardado = cursoRepository.save(cursoPlantilla);
        List<MateriaPlantillaResumenDto> plantillas = request.materias();

        if (plantillas != null) {
            //Eliminar materias existentes que hayan quedado fuera
            if (plantillas.isEmpty()) {
                List<MateriaPlantilla> aBorrar = new ArrayList<>(cursoPlantilla.getMateriasPlantilla());
                cursoPlantilla.getMateriasPlantilla().clear();
                aBorrar.forEach(oldMp -> materiaRepository.delete(oldMp));
            } else {
                Iterator<MateriaPlantilla> iterator = cursoPlantilla.getMateriasPlantilla().iterator();
                while (iterator.hasNext()) {
                    MateriaPlantilla oldMp = iterator.next();
                    boolean anyMatch = false;
                    for (MateriaPlantillaResumenDto resumen : plantillas) {
                        //los que haya recibido que tengan id negativo, significa que son
                        //nuevos, y por lo tanto no se deben tener en cuenta
                        if (resumen.id() >= 0 && resumen.id().equals(oldMp.getId())) {
                            anyMatch = true;
                        }
                    }
                    if (!anyMatch) {
                        iterator.remove();
                        materiaRepository.delete(oldMp);
                    }
                };
            }

            //Modificar materias existentes o añadir nuevas
            for (MateriaPlantillaResumenDto resumen : plantillas) {
                Optional<MateriaPlantilla> mpOpt = materiaRepository.findById(resumen.id());
                MateriaPlantilla mp;

                if (mpOpt.isPresent()) {
                    mp = mpOpt.get();
                    if (StringUtils.hasText(resumen.codigo()))  mp.setCodigo(resumen.codigo());
                    if (StringUtils.hasText(resumen.nombre()))  mp.setNombre(resumen.nombre());
                    if (StringUtils.hasText(resumen.tipo()))    mp.setTipo(TipoMateria.valueOf(resumen.tipo()));
                    if (resumen.horasTotales() > 0)             mp.setHorasTotales(resumen.horasTotales());
                } else {
                    mp = MateriaPlantilla.builder()
                        .nombre(resumen.nombre())
                        .codigo(resumen.codigo())
                        .horasTotales(resumen.horasTotales())
                        .cursoPlantilla(guardado)
                        .tipo(TipoMateria.valueOf(resumen.tipo()))
                        .build();
                }

                materiaRepository.save(mp);
            }

            log.info("Se han actualizado/creado {} plantillas de materias para el curso plantilla {}", plantillas.size(), guardado.getCodigo());
        }

        log.info("CursoPlantilla actualizada: (ID: {})", guardado.getId());
        return CursoPlantillaDto.fromEntity(guardado);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        cursoRepository.findById(id)
            .orElseThrow(
                () -> new ResourceNotFoundException("CursoPlantilla", "id", id)
            );
        //las materias plantilla se eliminan en cascada
        cursoRepository.deleteById(id);
        log.info("CursoPlantilla eliminada (ID: {})", id);
    }
}
