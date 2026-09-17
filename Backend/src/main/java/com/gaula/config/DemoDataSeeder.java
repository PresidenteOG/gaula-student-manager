package com.gaula.config;

import com.gaula.entity.*;
import com.gaula.repository.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.core.annotation.Order;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Fills the in-memory database with a small fictional school whenever the
 * {@code demo} profile is active. Never runs against a real datasource.
 *
 * The data is deliberately tiny — enough to log in as each role and see every
 * screen populated (dashboard, directory, schedule, attendance, admin config).
 * Password is role-based for convenience: {@code admin123} for the admin
 * account, {@code teacher123} for every teacher, {@code student123} for every
 * student.
 */
@Component
@Profile("demo")
@Order(0)
@RequiredArgsConstructor
@Slf4j
public class DemoDataSeeder implements CommandLineRunner {

    private final PasswordEncoder passwordEncoder;
    private final AnioEscolarRepository anioEscolarRepository;
    private final CursoPlantillaRepository cursoPlantillaRepository;
    private final MateriaPlantillaRepository materiaPlantillaRepository;
    private final CursoRepository cursoRepository;
    private final MateriaRepository materiaRepository;
    private final ProfesorRepository profesorRepository;
    private final AlumnoRepository alumnoRepository;
    private final HorarioRepository horarioRepository;
    private final FranjaHorariaRepository franjaHorariaRepository;
    private final ConfiguracionSistemaRepository configuracionSistemaRepository;

    @Override
    @Transactional
    public void run(String... args) {
        if (profesorRepository.count() > 0) {
            log.info("Demo data already present ({} teachers) — skipping seed.", profesorRepository.count());
            return;
        }
        try {
            seed();
            log.info("Demo school seeded. Log in with admin/admin123, any teacher username/teacher123, or any student username/student123.");
        } catch (Exception e) {
            log.error("Demo seeding failed — the app still starts, but screens will be empty.", e);
        }
    }

    private void seed() {
        String adminPass = passwordEncoder.encode("admin123");
        String teacherPass = passwordEncoder.encode("teacher123");
        String studentPass = passwordEncoder.encode("student123");

        // ── System config ──────────────────────────────────────────────
        configuracionSistemaRepository.saveAll(List.of(
            cfg("provincia_festivos", "ES-CT", "ISO 3166-2 region for the holiday calendar"),
            cfg("nombre_centro", "Institut Tecnologic Ponent", "School name shown in the UI"),
            cfg("email_soporte", "suport@itponent.example", "Support contact"),
            cfg("ano_escolar_activo", "24/25", "Active school year"),
            cfg("max_faltas_presencial", "20", "Max % absences — on-site students"),
            cfg("max_faltas_semipresencial", "50", "Max % absences — blended students")
        ));

        // ── Standard daily time slots ──────────────────────────────────
        String[] fNames  = {"1a hora", "2a hora", "3a hora", "Esbarjo", "4a hora", "5a hora", "6a hora"};
        String[] fStarts = {"08:00", "09:00", "10:00", "11:00", "11:30", "12:30", "13:30"};
        String[] fEnds   = {"09:00", "10:00", "11:00", "11:30", "12:30", "13:30", "14:30"};
        boolean[] fLect  = {true, true, true, false, true, true, true};
        List<FranjaHoraria> franjas = new ArrayList<>();
        for (int i = 0; i < fNames.length; i++) {
            franjas.add(FranjaHoraria.builder()
                .nombre(fNames[i])
                .horaInicio(LocalTime.parse(fStarts[i]))
                .horaFin(LocalTime.parse(fEnds[i]))
                .orden(i + 1)
                .esLectiva(fLect[i])
                .build());
        }
        franjaHorariaRepository.saveAll(franjas);

        // ── School year ────────────────────────────────────────────────
        AnioEscolar anio = anioEscolarRepository.save(AnioEscolar.builder()
            .denominacion("24/25")
            .activo(true)
            .descripcion("Curs academic 2024-2025")
            .fechaInicio(LocalDate.of(2024, 9, 12))
            .fechaFin(LocalDate.of(2025, 6, 20))
            .build());

        // ── Course template (DAM) + its module templates ───────────────
        CursoPlantilla dam = cursoPlantillaRepository.save(CursoPlantilla.builder()
            .codigo("DAM")
            .nombre("Desenvolupament d'Aplicacions Multiplataforma")
            .descripcion("Cicle formatiu de grau superior")
            .color("#60a5fa")
            .build());

        record Mod(String nombre, String codigo, int horas) {}
        List<Mod> mods = List.of(
            new Mod("Programacio", "M03", 231),
            new Mod("Bases de dades", "M02", 165),
            new Mod("Llenguatges de marques", "M04", 99),
            new Mod("Sistemes informatics", "M01", 165),
            new Mod("Desenvolupament d'interficies", "M06", 99),
            new Mod("Acces a dades", "M05", 132)
        );
        for (Mod m : mods) {
            materiaPlantillaRepository.save(MateriaPlantilla.builder()
                .nombre(m.nombre())
                .codigo(m.codigo())
                .horasTotales(m.horas())
                .cursoPlantilla(dam)
                .tipo(MateriaPlantilla.TipoMateria.MODULO)
                .build());
        }

        // ── Teachers (1 admin + 3 teachers) ────────────────────────────
        Profesor admin = profesorRepository.save(Profesor.builder()
            .nombre("Nuria").apellidos("Camps Vidal")
            .username("admin").password(adminPass).email("admin@itponent.example")
            .rol(Profesor.RolProfesor.ADMIN).estado(Profesor.EstadoProfesor.ACTIVO)
            .avatar("👩‍💼").especialidades("Prefectura d'estudis")
            .build());
        Profesor tIsabel = profesorRepository.save(Profesor.builder()
            .nombre("Isabel").apellidos("Fernandez Ruiz")
            .username("ifernandez").password(teacherPass).email("ifernandez@itponent.example")
            .rol(Profesor.RolProfesor.TEACHER).estado(Profesor.EstadoProfesor.ACTIVO)
            .avatar("👩‍🏫").especialidades("Programacio, Acces a dades")
            .build());
        Profesor tJordi = profesorRepository.save(Profesor.builder()
            .nombre("Jordi").apellidos("Puig Casanova")
            .username("jpuig").password(teacherPass).email("jpuig@itponent.example")
            .rol(Profesor.RolProfesor.TEACHER).estado(Profesor.EstadoProfesor.ACTIVO)
            .avatar("👨‍🏫").especialidades("Bases de dades, Llenguatges de marques")
            .build());
        Profesor tMarta = profesorRepository.save(Profesor.builder()
            .nombre("Marta").apellidos("Soler Oliva")
            .username("msoler").password(teacherPass).email("msoler@itponent.example")
            .rol(Profesor.RolProfesor.TEACHER).estado(Profesor.EstadoProfesor.ACTIVO)
            .avatar("👩‍🏫").especialidades("Sistemes informatics, Interficies")
            .build());

        // ── Two real groups: 1r DAM and 2n DAM, morning shift ──────────
        Curso g1 = cursoRepository.save(Curso.builder()
            .codigoGrupo("1DAM-M").turno(Curso.Turno.MANANA).etapaCurso(1)
            .cursoPlantilla(dam).anioEscolar(anio).tutor(tIsabel)
            .build());
        Curso g2 = cursoRepository.save(Curso.builder()
            .codigoGrupo("2DAM-M").turno(Curso.Turno.MANANA).etapaCurso(2)
            .cursoPlantilla(dam).anioEscolar(anio).tutor(tJordi)
            .build());

        // ── Subjects per group ────────────────────────────────────────
        Materia progG1 = materia("Programacio", "M03", 231, "#60a5fa", g1);
        Materia bbddG1 = materia("Bases de dades", "M02", 165, "#34d399", g1);
        Materia marksG1 = materia("Llenguatges de marques", "M04", 99, "#f59e0b", g1);
        Materia sisG1  = materia("Sistemes informatics", "M01", 165, "#a78bfa", g1);
        Materia adG2   = materia("Acces a dades", "M05", 132, "#60a5fa", g2);
        Materia diG2   = materia("Desenvolupament d'interficies", "M06", 99, "#f472b6", g2);
        Materia progG2 = materia("Programacio avancada", "M03", 99, "#38bdf8", g2);
        materiaRepository.saveAll(List.of(progG1, bbddG1, marksG1, sisG1, adG2, diG2, progG2));

        // ── Students ──────────────────────────────────────────────────
        String[][] s1 = {
            {"Carla", "Lopez Martinez", "clopez"},
            {"Sofia", "Garcia Perez", "sgarcia"},
            {"Marc", "Roca Ferrer", "mroca"},
            {"Aina", "Vila Serra", "avila"},
            {"Pol", "Mas Nadal", "pmas"},
        };
        String[][] s2 = {
            {"Laia", "Torres Blanch", "ltorres"},
            {"Bruno", "Sala Riera", "bsala"},
            {"Nil", "Bonet Prat", "nbonet"},
            {"Emma", "Costa Rius", "ecosta"},
        };
        List<Materia> materiasG1 = List.of(progG1, bbddG1, marksG1, sisG1);
        List<Materia> materiasG2 = List.of(adG2, diG2, progG2);
        List<Alumno> alumnos = new ArrayList<>();
        for (String[] s : s1) alumnos.add(alumno(s, studentPass, g1, materiasG1));
        for (String[] s : s2) alumnos.add(alumno(s, studentPass, g2, materiasG2));
        alumnoRepository.saveAll(alumnos);

        // ── Weekly schedule (a readable subset) ───────────────────────
        List<Horario> horario = new ArrayList<>();
        horario.add(sesion(DayOfWeek.MONDAY, "08:00", "10:00", "A11", progG1, tIsabel));
        horario.add(sesion(DayOfWeek.MONDAY, "10:00", "11:00", "A11", bbddG1, tJordi));
        horario.add(sesion(DayOfWeek.MONDAY, "11:30", "13:30", "Lab2", sisG1, tMarta));
        horario.add(sesion(DayOfWeek.TUESDAY, "08:00", "10:00", "A11", bbddG1, tJordi));
        horario.add(sesion(DayOfWeek.TUESDAY, "10:00", "12:30", "A11", marksG1, tJordi));
        horario.add(sesion(DayOfWeek.WEDNESDAY, "08:00", "10:00", "Lab1", progG1, tIsabel));
        horario.add(sesion(DayOfWeek.WEDNESDAY, "10:00", "11:00", "A11", sisG1, tMarta));
        horario.add(sesion(DayOfWeek.THURSDAY, "08:00", "10:00", "A11", progG1, tIsabel));
        horario.add(sesion(DayOfWeek.THURSDAY, "11:30", "14:30", "Lab2", marksG1, tJordi));
        horario.add(sesion(DayOfWeek.FRIDAY, "08:00", "10:00", "A11", bbddG1, tJordi));
        horario.add(sesion(DayOfWeek.FRIDAY, "10:00", "12:30", "Lab1", sisG1, tMarta));
        // 2n DAM
        horario.add(sesion(DayOfWeek.MONDAY, "08:00", "10:00", "A21", adG2, tIsabel));
        horario.add(sesion(DayOfWeek.TUESDAY, "08:00", "11:00", "Lab3", diG2, tMarta));
        horario.add(sesion(DayOfWeek.WEDNESDAY, "08:00", "10:00", "A21", progG2, tIsabel));
        horario.add(sesion(DayOfWeek.THURSDAY, "08:00", "10:00", "A21", adG2, tIsabel));
        horario.add(sesion(DayOfWeek.FRIDAY, "08:00", "11:00", "Lab3", diG2, tMarta));
        horarioRepository.saveAll(horario);
    }

    // ── builders ──────────────────────────────────────────────────────

    private ConfiguracionSistema cfg(String clave, String valor, String descripcion) {
        return ConfiguracionSistema.builder().clave(clave).valor(valor).descripcion(descripcion).build();
    }

    private Materia materia(String nombre, String codigo, int horas, String color, Curso curso) {
        return Materia.builder()
            .nombre(nombre).codigo(codigo).horasTotales(horas).color(color).curso(curso)
            .build();
    }

    private Alumno alumno(String[] s, String pass, Curso curso, List<Materia> materias) {
        return Alumno.builder()
            .nombre(s[0]).apellidos(s[1]).username(s[2]).password(pass)
            .email(s[2] + "@alumnat.itponent.example")
            .estado(Alumno.EstadoAlumno.ACTIVO)
            .modalidad(Alumno.ModalidadAlumno.PRESENCIAL)
            .avatar("🎓")
            .curso(curso)
            .materias(new ArrayList<>(materias))
            .build();
    }

    private Horario sesion(DayOfWeek dia, String inicio, String fin, String aula, Materia materia, Profesor profesor) {
        return Horario.builder()
            .activo(true)
            .diaSemana(dia)
            .horaInicio(LocalTime.parse(inicio))
            .horaFin(LocalTime.parse(fin))
            .aula(aula)
            .materia(materia)
            .profesor(profesor)
            .build();
    }
}
