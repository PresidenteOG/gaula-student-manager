package com.gaula.service.asistencia;

import com.gaula.domain.AsistenciaDto;
import com.gaula.dto.pasar_lista.RegistroDeFaltaRequest;
import com.gaula.entity.Alumno;
import com.gaula.entity.Asistencia;
import com.gaula.entity.Clase;
import com.gaula.entity.ConfiguracionSistema;
import com.gaula.entity.Materia;
import com.gaula.entity.Profesor;
import com.gaula.entity.Asistencia.EstadoAsistencia;
import com.gaula.exception.ResourceNotFoundException;
import com.gaula.repository.AlumnoRepository;
import com.gaula.repository.AsistenciaRepository;
import com.gaula.repository.ClaseRepository;
import com.gaula.repository.ConfiguracionSistemaRepository;
import com.gaula.repository.ProfesorRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class AsistenciaServiceImpl implements AsistenciaService {

    private final AsistenciaRepository           asistenciaRepository;
    private final ClaseRepository                claseRepository;
    private final AlumnoRepository               alumnoRepository;
    private final ConfiguracionSistemaRepository configRepository;
    private final ProfesorRepository             profesorRepository;

    @Override
    @Transactional(readOnly = true)
    public List<AsistenciaDto> findByAlumnoId(Long alumnoId) {
        return asistenciaRepository.findByAlumnoId(alumnoId).stream()
            .map(AsistenciaDto::fromEntity)
            .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<AsistenciaDto> findBySessionIdAndFecha(Long claseId, LocalDate fecha) {

        return asistenciaRepository.findBySessionIdAndFecha(claseId, fecha).stream()
            .map(AsistenciaDto::fromEntity)
            .collect(Collectors.toList());
    }


    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> calcularResumenAlumno(Long alumnoId) {
        Alumno alumno = alumnoRepository.findById(alumnoId)
            .orElseThrow(() -> new ResourceNotFoundException("Alumno", "id", alumnoId));

        List<Asistencia> registros = asistenciaRepository.findByAlumnoId(alumnoId);
        
        // B4-4: Cargar porcentajes configurables
        double maxPctPresencial = configRepository.findByClave(ConfiguracionSistema.KEY_MAX_FALTAS_PRESENCIAL)
            .map(c -> Double.parseDouble(c.getValor())).orElse(20.0);
        double maxPctSemipresencial = configRepository.findByClave(ConfiguracionSistema.KEY_MAX_FALTAS_SEMIPRESENCIAL)
            .map(c -> Double.parseDouble(c.getValor())).orElse(50.0);
        
        final Alumno.ModalidadAlumno modalidad = alumno.getModalidad() != null ? alumno.getModalidad() : Alumno.ModalidadAlumno.PRESENCIAL;
        final double maxPct = modalidad == Alumno.ModalidadAlumno.SEMIPRESENCIAL ? maxPctSemipresencial : maxPctPresencial;

        long realizadas  = claseRepository.countByAlumnoId(alumnoId);//total clases realizadas de todas las materias del alumno
        long ausentes     = registros.stream().filter(a -> a.getEstado() == Asistencia.EstadoAsistencia.AUSENTE || a.getEstado() == Asistencia.EstadoAsistencia.FALTA).count();
        long retrasos     = registros.stream().filter(a -> a.getEstado() == Asistencia.EstadoAsistencia.RETRASO).count();
        long justificados = registros.stream().filter(a -> a.getEstado() == Asistencia.EstadoAsistencia.JUSTIFICADO).count();
        long presentes    = realizadas - (ausentes + retrasos + justificados);
        
        // B4-4: 2 retrasos = 1 hora faltada
        double horasFaltadas = ausentes * 1.0 + Math.floor(retrasos / 2.0) + justificados * 1.0;

        double porcentajeAsistencia = realizadas > 0 
            ? Math.round((double) presentes / realizadas * 1000.0) / 10.0
            : 100.0;

        // ── Per-materia breakdown ──
        Map<Materia, List<Asistencia>> porMateria = registros.stream()
            .filter(a -> a.getClase() != null && a.getClase().getMateria() != null)
            .collect(Collectors.groupingBy(a -> a.getClase().getMateria()));
        alumno.getMaterias().forEach(mat -> porMateria.putIfAbsent(mat, new ArrayList<>()));

        List<Map<String, Object>> breakdown = porMateria.entrySet().stream().map(entry -> {
            Materia materia = entry.getKey();
            List<Asistencia> lista = entry.getValue();
            long mTotal       = claseRepository.countByMateriaId(materia.getId());
            long mAusentes    = lista.stream().filter(a -> a.getEstado() == Asistencia.EstadoAsistencia.AUSENTE || a.getEstado() == Asistencia.EstadoAsistencia.FALTA).count();
            long mRetrasos    = lista.stream().filter(a -> a.getEstado() == Asistencia.EstadoAsistencia.RETRASO).count();
            long mJustificados= lista.stream().filter(a -> a.getEstado() == Asistencia.EstadoAsistencia.JUSTIFICADO).count();
            long mPresentes   = (mTotal - (mAusentes + mRetrasos + mJustificados));
            
            int  horasTotalesMateria = materia.getHorasTotales() > 0 ? materia.getHorasTotales() : (int) mTotal;
            int  maxFaltasMateria    = (int) Math.floor(horasTotalesMateria * (maxPct / 100.0));
            double totalFaltasCalculadas = mAusentes + mJustificados + Math.floor(mRetrasos / 2.0);

            double mPct = mTotal > 0 ? (totalFaltasCalculadas / horasTotalesMateria) * 100.0 : 0.0;

            Map<String, Object> m = new HashMap<>();
            m.put("materiaId",    materia.getId());
            m.put("materiaCodigo",materia.getCodigo());
            m.put("materiaNombre",materia.getNombre());
            m.put("materiaColor", materia.getColor());
            m.put("totalClases",  mTotal);
            m.put("presentes",    mPresentes);
            m.put("ausentes",     mAusentes);
            m.put("retrasos",     mRetrasos);
            m.put("justificados", mJustificados);
            m.put("horasTotales", horasTotalesMateria);
            m.put("maxFaltas",    maxFaltasMateria);
            m.put("totalFaltas",  totalFaltasCalculadas);
            m.put("porcentajeFaltas", mPct);
            return m;
        }).sorted((map1, map2) -> {
            Double d1 = (Double)map1.get("porcentajeFaltas");
            Double d2 = (Double)map2.get("porcentajeFaltas");
            return d2.compareTo(d1);
        }).collect(Collectors.toList());

        Map<String, Object> resumen = new HashMap<>();
        resumen.put("alumnoId",             alumnoId);
        resumen.put("modalidad",            alumno.getModalidad().name());
        resumen.put("maxPctFaltasPermitido", maxPct);
        resumen.put("totalClases",          realizadas);
        resumen.put("presentes",            presentes);
        resumen.put("ausentes",             ausentes);
        resumen.put("retrasos",             retrasos);
        resumen.put("justificados",         justificados);
        resumen.put("horasFaltadas",        horasFaltadas);
        resumen.put("porcentajeAsistencia", porcentajeAsistencia);
        resumen.put("modulos",               breakdown);
        return resumen;

    }

    @Override
    @Transactional
    public void guardarAsistenciaMasiva(Clase clase, LocalDate fecha, List<RegistroDeFaltaRequest> registros) {
        for (RegistroDeFaltaRequest reg : registros) {
            // Buscar si ya existe para esta clase (para ediciones)
            Asistencia asistencia = asistenciaRepository.findByAlumnoIdAndClaseId(reg.alumnoId(), clase.getId()).orElse(null);
            EstadoAsistencia estado = Asistencia.EstadoAsistencia.valueOf(reg.estado().toUpperCase());

            if (estado != EstadoAsistencia.PRESENTE) {
                if (asistencia == null) {
                    asistencia = new Asistencia();
                }

                Alumno alumno = alumnoRepository.findById(reg.alumnoId()).orElse(null);

                if (alumno != null) {
                    asistencia.setClase(clase);
                    asistencia.setAlumno(alumno);
                    asistencia.setFecha(fecha);
                    asistencia.setEstado(estado);
                    asistencia.setObservaciones(reg.observaciones());

                    asistenciaRepository.save(asistencia);
                }
            } else if (asistencia != null) {
                // Los presentes no se registran, por lo tanto se elimina asistencia
                asistenciaRepository.delete(asistencia);
            }
        }
        log.info("Registrada asistencia masiva para clase {} el {}: {} alumnos", clase.getId(), fecha, registros.size());
    }

    @Override
    @Transactional
    public void eliminarAsistencia(Long asistenciaId, Long profesorId) {
        Asistencia asistencia = asistenciaRepository.findById(asistenciaId)
            .orElseThrow(() -> new ResourceNotFoundException("Asistencia no encontrada: " + asistenciaId));

        verificarAccesoTutor(profesorId, asistencia.getAlumno());

        asistenciaRepository.delete(asistencia);
        log.info("Asistencia {} eliminada por profesor {}", asistenciaId, profesorId);
    }

    @Override
    @Transactional
    public void justificarAsistencia(Long asistenciaId, String observaciones, Long profesorId) {
        Asistencia asistencia = asistenciaRepository.findById(asistenciaId)
            .orElseThrow(() -> new ResourceNotFoundException("Asistencia no encontrada: " + asistenciaId));

        verificarAccesoTutor(profesorId, asistencia.getAlumno());

        asistencia.setEstado(EstadoAsistencia.JUSTIFICADO);
        asistencia.setObservaciones(observaciones != null ? observaciones : "");
        asistenciaRepository.save(asistencia);
        log.info("Asistencia {} justificada por profesor {}", asistenciaId, profesorId);
    }

    /**
     * Verifica que el profesor sea ADMIN o tutor del curso del alumno.
     * Lanza FORBIDDEN si no tiene acceso.
     */
    private void verificarAccesoTutor(Long profesorId, Alumno alumno) {
        Profesor profesor = profesorRepository.findById(profesorId)
            .orElseThrow(() -> new ResourceNotFoundException("Profesor no encontrado: " + profesorId));

        // Admins bypass
        if (profesor.getRol() != null && profesor.getRol().name().contains("ADMIN")) {
            return;
        }

        // Verify tutor of alumno's course
        Long cursoDeLAlumno = alumno.getCurso() != null ? alumno.getCurso().getId() : null;
        if (cursoDeLAlumno == null) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "El alumno no tiene curso asignado");
        }

        boolean esTutor = profesor.getCursosTutor().stream()
            .anyMatch(c -> c.getId().equals(cursoDeLAlumno));

        if (!esTutor) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN,
                "No eres tutor del curso de este alumno");
        }
    }
}
