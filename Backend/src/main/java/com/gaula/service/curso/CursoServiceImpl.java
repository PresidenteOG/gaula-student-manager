package com.gaula.service.curso;

import com.gaula.domain.CursoDto;
import com.gaula.dto.curso.CreateCursoRequest;
import com.gaula.entity.Curso;
import com.gaula.entity.CursoPlantilla;
import com.gaula.entity.AnioEscolar;
import com.gaula.entity.Materia;
import com.gaula.entity.MateriaPlantilla;
import com.gaula.entity.Profesor;
import com.gaula.exception.ResourceNotFoundException;
import com.gaula.repository.AlumnoRepository;
import com.gaula.repository.AnioEscolarRepository;
import com.gaula.repository.CursoPlantillaRepository;
import com.gaula.repository.CursoRepository;
import com.gaula.repository.MateriaRepository;
import com.gaula.repository.ProfesorRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Implementación del servicio de Cursos (grupos clase).
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class CursoServiceImpl implements CursoService {

    private final CursoRepository       cursoRepository;
    private final AnioEscolarRepository anioEscolarRepository;
    private final CursoPlantillaRepository cursoPlantillaRepository;
    private final ProfesorRepository     profesorRepository;
    private final MateriaRepository      materiaRepository;
    private final AlumnoRepository       alumnoRepository;

    @Override
    @Transactional(readOnly = true)
    public List<CursoDto> findAllActivos() {
        return cursoRepository.findAllCursosActivos().stream()
            .map(CursoDto::fromEntity)
            .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<CursoDto> findByCursoEscolarId(Long cursoEscolarId) {
        return cursoRepository.findByAnioEscolarOrderByAnoAsc(cursoEscolarId).stream()
            .map(CursoDto::fromEntity)
            .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public CursoDto findById(Long id) {
        return CursoDto.fromEntity(
            cursoRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Curso", "id", id))
        );
    }

    @Override
    @Transactional
    public CursoDto create(CreateCursoRequest request) {
        AnioEscolar anioEscolar = anioEscolarRepository.findById(request.anioEscolarId())
            .orElseThrow(() -> new ResourceNotFoundException("AnioEscolar", "id", request.anioEscolarId()));

        CursoPlantilla cursoPlantilla = cursoPlantillaRepository.findById(request.cursoPlantillaId())
            .orElseThrow(() -> new ResourceNotFoundException("CursoPlantilla", "id", request.cursoPlantillaId()));

        Profesor tutor = null;
        if (request.tutorId() != null) {
            tutor = profesorRepository.findById(request.tutorId())
                .orElseThrow(() -> new ResourceNotFoundException("Profesor (tutor)", "id", request.tutorId()));
        }

        Curso.Turno turno = request.turno() != null 
            ? Curso.Turno.valueOf(request.turno().toUpperCase())
            : null;

        // Validar duplicados para evitar error 500 del constraint uq_grupo_anio_escolar
        if (cursoRepository.existsByCodigoGrupoAndAnioEscolarId(request.codigoGrupo(), request.anioEscolarId())) {
            throw new IllegalArgumentException("Ya existe un curso con el código '" + request.codigoGrupo() + "' en este año escolar.");
        }

        Curso curso = Curso.builder()
            .turno(turno)
            .cursoPlantilla(cursoPlantilla)
            .codigoGrupo(request.codigoGrupo())
            .desdoblamiento(request.desdoblamiento())
            .etapaCurso(request.etapaCurso())
            .anioEscolar(anioEscolar)
            .tutor(tutor)
            .build();

        Curso guardado = cursoRepository.save(curso);
        
        // Instanciar materias desde la plantilla (filtradas si se proporcionan IDs)
        List<MateriaPlantilla> todasPlantillas = cursoPlantilla.getMateriasPlantilla();
        List<Materia> materias = new ArrayList<Materia>();
        if (todasPlantillas != null) {
            List<MateriaPlantilla> materiasAInstanciar;
            if (request.materiaPlantillaIds() != null && !request.materiaPlantillaIds().isEmpty()) {
                // Solo instanciar las materias seleccionadas por el usuario
                materiasAInstanciar = todasPlantillas.stream()
                    .filter(mp -> request.materiaPlantillaIds().contains(mp.getId()))
                    .collect(Collectors.toList());
            } else {
                // Backward compatible: instanciar todas
                materiasAInstanciar = todasPlantillas;
            }

            for (MateriaPlantilla mp : materiasAInstanciar) {
                Materia m = Materia.builder()
                    .nombre(mp.getNombre())
                    .codigo(mp.getCodigo())
                    .horasTotales(mp.getHorasTotales())
                    .curso(guardado)
                    .materiaPlantilla(mp)
                    .build();
                materiaRepository.save(m);
                materias.add(m);
            }

            log.info("Instanciadas {} materias para el curso {} desde la plantilla", materiasAInstanciar.size(), guardado.getCodigoGrupo());
        }

        // Matricular alumnos si se proporcionan IDs (filtrando duplicados)
        if (request.studentIds() != null && !request.studentIds().isEmpty()) {
            request.studentIds().stream().distinct().forEach(alumnoId -> {
                alumnoRepository.findById(alumnoId).ifPresent(alumno -> {
                    alumno.setCurso(guardado);
                    alumno.setMaterias(new ArrayList<>(materias));//hay que hacer copia para evitar un fallo
                    alumnoRepository.save(alumno);
                }); 
            });
            log.info("Matriculados {} alumnos en el curso {}", request.studentIds().size(), guardado.getCodigoGrupo());
        }

        log.info("Curso creado: {} (ID: {})", guardado.getCodigoGrupo(), guardado.getId());
        return CursoDto.fromEntity(guardado);
    }

    @Override
    @Transactional
    public CursoDto asignarTutor(Long cursoId, Long profesorId) {
        Curso curso = cursoRepository.findById(cursoId)
            .orElseThrow(() -> new ResourceNotFoundException("Curso", "id", cursoId));

        Profesor tutor = profesorRepository.findById(profesorId)
            .orElseThrow(() -> new ResourceNotFoundException("Profesor", "id", profesorId));

        curso.setTutor(tutor);
        log.info("Tutor {} asignado al curso {}", tutor.getNombreCompleto(), curso.getCodigoGrupo());
        return CursoDto.fromEntity(cursoRepository.save(curso));
    }

    @Override
    @Transactional
    public void delete(Long id) {
        Curso curso = cursoRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Curso", "id", id));

        if (curso.getAlumnos() != null && !curso.getAlumnos().isEmpty()) {
            throw new IllegalArgumentException(
                "No se puede eliminar el curso '" + curso.getCodigoGrupo() +
                "' porque tiene " + curso.getAlumnos().size() + " alumno(s) matriculado(s)."
            );
        }

        cursoRepository.deleteById(id);
        log.info("Curso eliminado (ID: {})", id);
    }
}
