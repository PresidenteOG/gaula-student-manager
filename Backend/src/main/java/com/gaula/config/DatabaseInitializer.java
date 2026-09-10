package com.gaula.config;

// import com.gaula.repository.ProfesorRepository;
// import com.gaula.repository.AlumnoRepository;
// import com.gaula.repository.HorarioTemplateRepository;
// import com.gaula.entity.HorarioTemplate;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
// import org.springframework.boot.CommandLineRunner;
// import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
// import org.springframework.transaction.annotation.Transactional;
// import org.springframework.jdbc.core.JdbcTemplate;
// import java.util.List;

/**
 * Componente de auto-curación de base de datos.
 * Asegura que los usuarios básicos tengan la contraseña 'admin123'
 * independientemente de errores en los scripts SQL o en la migración Cloud.
 */
@Component
@RequiredArgsConstructor
@Slf4j
public class DatabaseInitializer /*implements CommandLineRunner*/ {

    // private final ProfesorRepository profesorRepository;
    // private final AlumnoRepository alumnoRepository;
    // private final PasswordEncoder passwordEncoder;
    // private final JdbcTemplate jdbcTemplate;
    // private final HorarioTemplateRepository horarioTemplateRepository;

    // @Override
    // public void run(String... args) {
    //     log.info("🚀 GAULA: Ejecutando validación de credenciales críticas...");

    //     log.info("🛠 GAULA: Verificando integridad de tablas críticas...");
    //     try {
    //         jdbcTemplate.execute("CREATE TABLE IF NOT EXISTS curso_plantilla (" +
    //             "id BIGINT AUTO_INCREMENT PRIMARY KEY, " +
    //             "codigo VARCHAR(10) NOT NULL UNIQUE, " +
    //             "nombre VARCHAR(150) NOT NULL, " +
    //             "color VARCHAR(9) NOT NULL, " +
    //             "tipo_materia VARCHAR(20) NOT NULL DEFAULT 'MODULOS')");
    //     } catch (Exception e) { log.warn("Error al verificar curso_plantilla: " + e.getMessage()); }

    //     try {
    //         jdbcTemplate.execute("CREATE TABLE IF NOT EXISTS horario_template (" +
    //             "id BIGINT AUTO_INCREMENT PRIMARY KEY, " +
    //             "nombre VARCHAR(50) NOT NULL, " +
    //             "hora_inicio TIME NOT NULL, " +
    //             "hora_fin TIME NOT NULL, " +
    //             "orden INT NOT NULL, " +
    //             "es_lectiva BOOLEAN NOT NULL)");
    //     } catch (Exception e) { log.warn("Error al verificar horario_template: " + e.getMessage()); }

    //     try {
    //         jdbcTemplate.execute("ALTER TABLE curso_plantilla ADD COLUMN tipo_materia VARCHAR(20) NOT NULL DEFAULT 'MODULOS'");
    //     } catch (Exception e) { log.warn("Columna tipo_materia ya existe o error: " + e.getMessage()); }

    //     try {
    //         jdbcTemplate.execute("CREATE TABLE IF NOT EXISTS curso_escolar (" +
    //             "id BIGINT AUTO_INCREMENT PRIMARY KEY, " +
    //             "denominacion VARCHAR(10) NOT NULL, " +
    //             "turno VARCHAR(10) NOT NULL, " +
    //             "activo BOOLEAN NOT NULL DEFAULT TRUE, " +
    //             "fecha_inicio DATE, " +
    //             "fecha_fin DATE, " +
    //             "descripcion VARCHAR(500), " +
    //             "curso_plantilla_id BIGINT, " +
    //             "CONSTRAINT fk_curso_escolar_plantilla FOREIGN KEY (curso_plantilla_id) REFERENCES curso_plantilla(id) ON DELETE SET NULL)");
    //     } catch (Exception e) { log.warn("Error al verificar curso_escolar: " + e.getMessage()); }

    //     try {
    //         jdbcTemplate.execute("ALTER TABLE curso ADD COLUMN ano_curso VARCHAR(10) NOT NULL DEFAULT 'PRIMERO'");
    //     } catch (Exception e) { log.warn("Columna ano_curso ya existe o error: " + e.getMessage()); }

    //     try {
    //         jdbcTemplate.execute("ALTER TABLE curso ADD COLUMN curso_escolar_id BIGINT");
    //     } catch (Exception e) { log.warn("Columna curso_escolar_id ya existe o error: " + e.getMessage()); }

    //     try {
    //         jdbcTemplate.execute("ALTER TABLE curso DROP COLUMN anio_escolar_id");
    //     } catch (Exception e) {
    //         try {
    //             jdbcTemplate.execute("ALTER TABLE curso MODIFY COLUMN anio_escolar_id BIGINT NULL");
    //         } catch (Exception e2) {
    //             log.warn("Error al mitigar anio_escolar_id: " + e2.getMessage());
    //         }
    //     }

    //     try {
    //         jdbcTemplate.execute("ALTER TABLE curso_escolar ADD COLUMN IF NOT EXISTS fecha_inicio DATE");
    //     } catch (Exception e) { log.warn("fecha_inicio ya existe o error: " + e.getMessage()); }

    //     try {
    //         jdbcTemplate.execute("ALTER TABLE curso_escolar ADD COLUMN IF NOT EXISTS fecha_fin DATE");
    //     } catch (Exception e) { log.warn("fecha_fin ya existe o error: " + e.getMessage()); }

    //     try {
    //         jdbcTemplate.execute("ALTER TABLE curso_escolar ADD COLUMN IF NOT EXISTS descripcion VARCHAR(500)");
    //     } catch (Exception e) { log.warn("descripcion ya existe o error: " + e.getMessage()); }

    //     String defaultPass = passwordEncoder.encode("admin123");

    //     // 1. Resetear Admins/Profesores
    //     resetProfesor("rsanchez", defaultPass);
    //     resetProfesor("ifernandez", defaultPass);
    //     resetProfesor("jpuig", defaultPass);

    //     // 2. Resetear Alumnos
    //     resetAlumno("igarcia", defaultPass);
    //     resetAlumno("clopez", defaultPass);
    //     resetAlumno("mrodriguez", defaultPass);
        
    //     // Ensure "alumno" user exists — assign to first available course
    //     String alumnoPass = passwordEncoder.encode("admin123");
    //     alumnoRepository.findByUsername("alumno").ifPresentOrElse(
    //         a -> {
    //             a.setPassword(alumnoPass);
    //             alumnoRepository.save(a);
    //             log.info("   [OK] Password reseteada para Alumno demo: alumno");
    //         },
    //         () -> {
    //             try {
    //                 // Find first available curso_id to satisfy NOT NULL constraint
    //                 List<Long> ids = jdbcTemplate.queryForList(
    //                     "SELECT id FROM curso ORDER BY id LIMIT 1", Long.class);
    //                 if (!ids.isEmpty()) {
    //                     Long cursoId = ids.get(0);
    //                     int count = jdbcTemplate.queryForObject(
    //                         "SELECT COUNT(*) FROM alumno WHERE email = ?", Integer.class,
    //                         "alumno@gaula.edu");
    //                     if (count == 0) {
    //                         jdbcTemplate.update(
    //                             "INSERT INTO alumno (nombre, apellidos, username, password, email, estado, avatar, curso_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
    //                             "Alumno", "Demo", "alumno", alumnoPass, "alumno@gaula.edu", "ACTIVO", "🎓", cursoId);
    //                         log.info("   [OK] Creado alumno demo: alumno / admin123");
    //                     }
    //                 } else {
    //                     log.warn("   [SKIP] No hay cursos disponibles para asignar al alumno demo. Créalos primero.");
    //                 }
    //             } catch (Exception e) {
    //                 log.warn("   [WARN] No se pudo crear alumno demo: " + e.getMessage());
    //             }
    //         }
    //     );

    //     // 3. Populate default schedule template
    //     try {
    //         long slotCount = horarioTemplateRepository.count();
    //         if (slotCount == 0) {
    //             String[] names = {"1ª Hora", "2ª Hora", "3ª Hora", "Recreo", "4ª Hora", "5ª Hora", "6ª Hora"};
    //             String[] starts = {"08:00", "09:00", "10:00", "11:00", "11:30", "12:30", "13:30"};
    //             String[] ends = {"09:00", "10:00", "11:00", "11:30", "12:30", "13:30", "14:30"};
    //             boolean[] lectivas = {true, true, true, false, true, true, true};
                
    //             for (int i = 0; i < names.length; i++) {
    //                 horarioTemplateRepository.save(HorarioTemplate.builder()
    //                     .nombre(names[i])
    //                     .horaInicio(java.time.LocalTime.parse(starts[i]))
    //                     .horaFin(java.time.LocalTime.parse(ends[i]))
    //                     .orden(i + 1)
    //                     .esLectiva(lectivas[i])
    //                     .build());
    //             }
    //             log.info("   [OK] Creada plantilla de horario por defecto.");
    //         }
    //     } catch (Exception e) {
    //         log.warn("   [WARN] No se pudo inicializar plantilla de horario: " + e.getMessage());
    //     }

    //     log.info("✅ GAULA: Credenciales sincronizadas. Usa 'admin123' para todos los usuarios de demo.");
    // }

    // @Transactional
    // private void resetProfesor(String username, String pass) {
    //     profesorRepository.findByUsername(username).ifPresentOrElse(
    //         p -> {
    //             p.setPassword(pass);
    //             profesorRepository.save(p);
    //             log.info("   [OK] Password reseteada para Profesor: {}", username);
    //         },
    //         () -> log.warn("   [ERROR] No se encontró el profesor: {}", username)
    //     );
    // }

    // @Transactional
    // private void resetAlumno(String username, String pass) {
    //     alumnoRepository.findByUsername(username).ifPresentOrElse(
    //         a -> {
    //             a.setPassword(pass);
    //             alumnoRepository.save(a);
    //             log.info("   [OK] Password reseteada para Alumno: {}", username);
    //         },
    //         () -> log.warn("   [ERROR] No se encontró el alumno: {}", username)
    //     );
    // }
}
