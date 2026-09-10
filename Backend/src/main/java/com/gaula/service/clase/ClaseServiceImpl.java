package com.gaula.service.clase;

import com.gaula.domain.ClaseDto;
import com.gaula.dto.pasar_lista.PasarListaClaseRequest;
import com.gaula.entity.Clase;
import com.gaula.entity.Horario;
import com.gaula.entity.Profesor;
import com.gaula.exception.ResourceNotFoundException;
import com.gaula.repository.ClaseRepository;
import com.gaula.repository.EventoRepository;
import com.gaula.repository.HorarioRepository;
import com.gaula.repository.ProfesorRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Slf4j
public class ClaseServiceImpl implements ClaseService {

    private final HorarioRepository  horarioRepository;
    private final ProfesorRepository profesorRepository;
    private final ClaseRepository    claseRepository;
    private final EventoRepository   eventoRepository;

    @Override
    @Transactional
    public Clase guardar(PasarListaClaseRequest request, LocalDate fecha) {
        Horario sesionHorario = horarioRepository.findById(request.horarioId())
            .orElseThrow(() -> new ResourceNotFoundException("Sesión de Horario", "id", request.horarioId()));
        Profesor profesor;

        if (request.profesorId() != null) {
            profesor = profesorRepository.findById(request.profesorId())
                .orElseThrow(() -> new ResourceNotFoundException("Profesor", "id", request.profesorId()));
        } else {
            profesor = sesionHorario.getProfesor();
        }

        String aula = request.aula() != null ? request.aula() : sesionHorario.getAula();
        Optional<Clase> claseProbable = claseRepository.findByHorarioIdAndFecha(request.horarioId(), fecha);
        Clase clase;

        if (claseProbable.isPresent()) {
            clase = claseProbable.get();

            if (clase.getProfesor().getId() != profesor.getId()) {
                clase.setProfesor(profesor);
            }

            if (clase.getAula() != aula) {
                clase.setAula(aula);
            }
        } else {
            clase = new Clase();
            clase.setFecha(fecha);
            clase.setProfesor(profesor);
            clase.setHorario(sesionHorario);
            clase.setAula(aula);
            clase.setMateria(sesionHorario.getMateria());
        }

        return claseRepository.save(clase);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Map<String, Object>> getSesionesPendientesHoy(Long profesorId, String filtroHoras, boolean quitarHechos) {
        LocalDate hoy = LocalDate.now();

        if (eventoRepository.findByFecha(hoy).stream().anyMatch(e -> "FESTIVO".equalsIgnoreCase(e.getTipo()))) {
            log.info("Hoy es festivo, no se generan clases.");
            return null;
        }

        LocalTime ahora = LocalTime.now();
        DayOfWeek dia = hoy.getDayOfWeek();

        // 1. Obtener todas las sesiones del profesor para hoy que YA han empezado
        List<Horario> sesionesHoy = horarioRepository.findByProfesorIdAndDiaSemana(profesorId, dia);

        if (!filtroHoras.isEmpty()) {
            Function<LocalTime, Boolean> filtro = filtroHoras.equalsIgnoreCase("activas")
                ? (tiempo) -> ahora.isAfter(tiempo)
                : /* "proximas" */ (tiempo) -> ahora.isBefore(tiempo);
            sesionesHoy = sesionesHoy.stream().filter(sh -> filtro.apply(sh.getHoraInicio())).collect(Collectors.toList());
        }

        // 2. Filtrar las que ya tienen registros de Clase para la fecha hoy
        //el set es para optimizar, en lugar de hacer una consulta por cada horario,
        //se recolectan antes por profesor y fecha
        Set<Long> horarioIdsHechos = claseRepository.findHorarioIdsByProfesorAndFecha(profesorId, hoy);
        List<Horario> pendientes = sesionesHoy.stream().filter(sh -> {
            // Si no hay ninguna clase registrada para esta sesion hoy, está pendiente
            return !horarioIdsHechos.contains(sh.getId());
        }).collect(Collectors.toList());

        Stream<Horario> streamSesionesHoy = sesionesHoy.stream();

        if (quitarHechos) {
            streamSesionesHoy = streamSesionesHoy.filter(sh -> pendientes.contains(sh));
        }

        return streamSesionesHoy.map(sh -> {
            Map<String, Object> m = new HashMap<>();
            m.put("sesionId", sh.getId());
            m.put("materia", sh.getMateria().getNombre());
            m.put("curso", sh.getMateria().getCurso().getCodigoGrupo());
            m.put("hora", sh.getHoraInicio() + " - " + sh.getHoraFin());
            m.put("aula", sh.getAula());
            m.put("pendiente", quitarHechos ? true : pendientes.contains(sh));
            m.put("fecha", hoy);
            return m;
        }).collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<ClaseDto> getHistorialDeProfesor(Long profesorId) {
        return claseRepository.findByProfesorId(profesorId).stream().map(ClaseDto::fromEntity)
        .sorted((dto1, dto2) -> {
            // Comparar por fecha en orden descendente (más reciente primero)
            int compFecha = dto2.fecha().compareTo(dto1.fecha());

            // Si las fechas son iguales, desempatamos por horaInicio en orden descendente
            if (compFecha == 0) {
                String hora1 = dto1.horaInicio() != null ? dto1.horaInicio() : "00:00";
                String hora2 = dto2.horaInicio() != null ? dto2.horaInicio() : "00:00";
                return hora2.compareTo(hora1); // Cambiar 2 por 1 para orden ascendente
            }

            return compFecha;
        }).toList();
    }

    @Override
    @Transactional(readOnly = true)
    public List<ClaseDto> getHistorialGlobal() {
        return claseRepository.findGlobalHistory().stream()
            .map(row -> {
                Horario horario = row[5] != null ? (Horario)row[5] : null;
                int total = row[7] != null ? ((Number) row[7]).intValue() : 0;
                int ausentes = row[8] != null ? (Integer) row[8] : 0;
                int retrasos = row[9] != null ? (Integer) row[9] : 0;
                int presentes = (total - ausentes) - retrasos;

                return ClaseDto.builder()
                    .id((long)row[0])
                    .sesionId(horario != null ? horario.getId() : 0)
                    .fecha(((LocalDate)row[1]))
                    .profesor(((row[2] != null && row[2] instanceof Profesor) ? ((Profesor)row[2]).getNombreCompleto() : "Sin Profesor").toString())
                    .materiaNombre(row[3].toString())
                    .codigoGrupo(row[4].toString())
                    .horaInicio(horario != null ? horario.getHoraInicio().toString() : null)
                    .horaFin(horario != null ? horario.getHoraFin().toString() : null)
                    .aula(row[6] != null ? row[6].toString() : null)
                    .totalAlumnos(total) 
                    .presentes(presentes)
                    .ausentes(ausentes)
                    .retrasos(retrasos)
                    .build();
            })
            
            .collect(Collectors.toList());
    }
}
