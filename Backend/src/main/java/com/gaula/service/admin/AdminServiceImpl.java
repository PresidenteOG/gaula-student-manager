package com.gaula.service.admin;

import com.gaula.entity.*;
import com.gaula.repository.*;
import com.gaula.dto.admin.UsuarioAdminDto;
import lombok.RequiredArgsConstructor;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class AdminServiceImpl implements AdminService {

    private final AuditoriaRepository auditoriaRepo;
    private final AlumnoRepository alumnoRepo;
    private final ProfesorRepository profesorRepo;
    private final IncidenciaRepository incidenciaRepo;
    private final HorarioRepository claseRepo;
    private final FranjaHorariaRepository horarioTemplateRepo;
    private final CursoRepository cursoRepo;
    private final MateriaRepository materiaRepo;
    private final AsistenciaRepository asistenciaRepo;
    private final PasswordEncoder    passwordEncoder;

    @Override
    public List<Auditoria> findAllAuditoria() {
        return auditoriaRepo.findAllByOrderByFechaDesc();
    }

    @Override
    @Transactional
    public Auditoria createAuditoria(Auditoria auditoria) {
        if (auditoria.getFecha() == null) auditoria.setFecha(java.time.LocalDateTime.now());
        return auditoriaRepo.save(auditoria);
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getDashboardStats() {
        long totalAlumnos = alumnoRepo.count();
        long totalProfesores = profesorRepo.count();
        long incidenciasAbiertas = incidenciaRepo.countByEstado(Incidencia.EstadoIncidencia.ABIERTA);
        long clasesSemana = claseRepo.count();

        java.time.DayOfWeek today = java.time.LocalDate.now().getDayOfWeek();
        List<Map<String, String>> proximasClases = claseRepo.findAll().stream()
            .filter(c -> c.getDiaSemana() == today)
            .sorted(java.util.Comparator.comparing(Horario::getHoraInicio))
            .limit(5)
            .map(c -> Map.of(
                "subject", c.getMateria().getNombre(),
                "course", c.getMateria().getCurso().getCodigoGrupo(),
                "time", c.getHoraInicio().toString(),
                "room", c.getAula() != null ? c.getAula() : "Aula N/A"
            ))
            .toList();

        long totalCursos = cursoRepo.count();
        long totalMaterias = materiaRepo.count();

        List<Asistencia> todasAsistencias = asistenciaRepo.findAll();
        String asistenciaPromedio = "0%";
        if (!todasAsistencias.isEmpty()) {
            long positivos = todasAsistencias.stream()
                .filter(a -> a.getEstado() == Asistencia.EstadoAsistencia.PRESENTE || 
                             a.getEstado() == Asistencia.EstadoAsistencia.JUSTIFICADO)
                .count();
            double porcentaje = (positivos * 100.0) / todasAsistencias.size();
            asistenciaPromedio = String.format("%.1f%%", porcentaje);
        }

        List<Map<String, Object>> incidenciasPorCurso = cursoRepo.findAll().stream()
            .map(c -> Map.<String, Object>of("name", c.getCodigoGrupo(), "count", incidenciaRepo.countByAlumnoCursoId(c.getId())))
            .filter(m -> (long)m.get("count") > 0)
            .sorted((a, b) -> Long.compare((long)b.get("count"), (long)a.get("count")))
            .limit(5)
            .toList();

        List<Map<String, String>> recentAlerts = incidenciaRepo.findAll().stream()
            .sorted((a, b) -> b.getFechaIncidencia().compareTo(a.getFechaIncidencia()))
            .limit(5)
            .map(inc -> Map.of(
                "title", inc.getTitulo(),
                "student", inc.getAlumno().getNombre(),
                "time", inc.getFechaIncidencia().toString()
            ))
            .toList();

        Map<String, Object> stats = new HashMap<>();
        stats.put("totalAlumnos", totalAlumnos);
        stats.put("totalProfesores", totalProfesores);
        stats.put("totalCursos", totalCursos);
        stats.put("totalMaterias", totalMaterias);
        stats.put("clasesEstaSemana", clasesSemana);
        stats.put("asistenciaPromedio", asistenciaPromedio);
        stats.put("incidenciasAbiertas", incidenciasAbiertas);
        stats.put("proximasClases", proximasClases);
        stats.put("incidenciasPorCurso", incidenciasPorCurso);
        stats.put("recentAlerts", recentAlerts);

        return stats;
    }

    @Override
    @Transactional
    public void generarHorario(Long cursoId) {
        Curso curso = cursoRepo.findById(cursoId).orElseThrow();
        List<Materia> materias = curso.getMaterias();
        List<FranjaHoraria> slots = horarioTemplateRepo.findAllByOrderByOrdenAsc();

        if (materias.isEmpty() || slots.isEmpty()) {
            throw new IllegalArgumentException("El curso no tiene materias o no hay plantillas de horario.");
        }

        claseRepo.deleteAll(claseRepo.findByMateriaCursoId(cursoId));

        Profesor profesorDefecto = curso.getTutor();
        if (profesorDefecto == null) {
            profesorDefecto = profesorRepo.findAll().stream().findFirst().orElse(null);
        }

        if (profesorDefecto == null) {
            throw new IllegalStateException("No hay profesores disponibles.");
        }

        int materiaIdx = 0;
        for (java.time.DayOfWeek day : java.time.DayOfWeek.values()) {
            if (day == java.time.DayOfWeek.SATURDAY || day == java.time.DayOfWeek.SUNDAY) continue;

            for (FranjaHoraria slot : slots) {
                if (!slot.isEsLectiva()) continue;

                Materia m = materias.get(materiaIdx % materias.size());
                Horario c = Horario.builder()
                    .diaSemana(day)
                    .horaInicio(slot.getHoraInicio())
                    .horaFin(slot.getHoraFin())
                    .materia(m)
                    .profesor(profesorDefecto)
                    .aula("Aula 101")
                    .build();
                claseRepo.save(c);
                materiaIdx++;
            }
        }
    }

    @Override
    @Transactional
    public void updateMateriaColor(Long materiaId, String color) {
        Materia materia = materiaRepo.findById(materiaId).orElseThrow();
        materia.setColor(color);
        materiaRepo.save(materia);
    }

    @Override
    @Transactional(readOnly = true)
    public List<UsuarioAdminDto> listarUsuarios() {
        List<UsuarioAdminDto> usuarios = new ArrayList<>();
        
        profesorRepo.findAll().forEach(p -> usuarios.add(UsuarioAdminDto.builder()
            .id(p.getId())
            .nombre(p.getNombre())
            .apellidos(p.getApellidos())
            .username(p.getUsername())
            .email(p.getEmail())
            .rol(p.getRol().name())
            .estado(p.getEstado().name())
            .fechaCreacion(p.getFechaCreacion())
            .ultimaConexion(p.getUltimaConexion())
            .ipConexion(p.getIpConexion())
            .ultimoJwt(p.getUltimoJwt())
            .build()));

        alumnoRepo.findAll().forEach(a -> usuarios.add(UsuarioAdminDto.builder()
            .id(a.getId())
            .nombre(a.getNombre())
            .apellidos(a.getApellidos())
            .username(a.getUsername())
            .email(a.getEmail())
            .rol("STUDENT")
            .estado(a.getEstado().name())
            .fechaCreacion(a.getFechaCreacion())
            .ultimaConexion(a.getUltimaConexion())
            .ipConexion(a.getIpConexion())
            .ultimoJwt(a.getUltimoJwt())
            .build()));

        return usuarios;
    }

    @Override
    @Transactional
    public void resetPassword(Long id, String rol) {
        String defaultPass = passwordEncoder.encode("gaula123"); // gaula123
        if ("STUDENT".equals(rol)) {
            alumnoRepo.findById(id).ifPresent(a -> {
                a.setPassword(defaultPass);
                alumnoRepo.save(a);
                auditoriaRepo.save(Auditoria.builder()
                    .usuario("ADMIN")
                    .accion("RESET_PASSWORD")
                    .objetivo("ALUMNO_" + a.getUsername())
                    .tipo("WARN")
                    .fecha(java.time.LocalDateTime.now())
                    .build());
            });
        } else {
            profesorRepo.findById(id).ifPresent(p -> {
                p.setPassword(defaultPass);
                profesorRepo.save(p);
                auditoriaRepo.save(Auditoria.builder()
                    .usuario("ADMIN")
                    .accion("RESET_PASSWORD")
                    .objetivo("PROFESOR_" + p.getUsername())
                    .tipo("WARN")
                    .fecha(java.time.LocalDateTime.now())
                    .build());
            });
        }
    }

    @Override
    @Transactional
    public void cambiarEstadoUsuario(Long id, String nuevoEstado, String rol) {
        if ("STUDENT".equals(rol)) {
            alumnoRepo.findById(id).ifPresent(a -> {
                a.setEstado(Alumno.EstadoAlumno.valueOf(nuevoEstado));
                alumnoRepo.save(a);
            });
        } else {
            profesorRepo.findById(id).ifPresent(p -> {
                p.setEstado(Profesor.EstadoProfesor.valueOf(nuevoEstado));
                profesorRepo.save(p);
            });
        }
    }

    @Override
    @Transactional
    public void eliminarUsuario(Long id, String rol) {
        if ("STUDENT".equals(rol)) {
            alumnoRepo.deleteById(id);
        } else {
            profesorRepo.deleteById(id);
        }
    }
}

