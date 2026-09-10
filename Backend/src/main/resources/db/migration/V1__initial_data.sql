-- ══════════════════════════════════════════════════════════════════════════
-- V1__initial_data.sql
-- ══════════════════════════════════════════════════════════════════════════

-- 0. SCHEMA
CREATE TABLE configuracion_sistema (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    clave VARCHAR(100) NOT NULL UNIQUE,
    valor VARCHAR(500) NOT NULL,
    descripcion VARCHAR(300)
);

CREATE TABLE curso_plantilla (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(10) NOT NULL UNIQUE,
    nombre VARCHAR(150) NOT NULL,
    color VARCHAR(9) NOT NULL,
    tipo_materia VARCHAR(20) NOT NULL
);

CREATE TABLE materia_plantilla (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    horas_totales INTEGER NOT NULL,
    curso_plantilla_id BIGINT NOT NULL,
    CONSTRAINT fk_materia_plantilla_curso_plan FOREIGN KEY (curso_plantilla_id) REFERENCES curso_plantilla (id)
);

CREATE TABLE curso_escolar (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    denominacion VARCHAR(10) NOT NULL,
    turno VARCHAR(10) NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    curso_plantilla_id BIGINT NOT NULL,
    CONSTRAINT fk_curso_escolar_curso_plan FOREIGN KEY (curso_plantilla_id) REFERENCES curso_plantilla (id)
);

CREATE TABLE profesor (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    apellidos VARCHAR(150) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    estado VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    rol VARCHAR(15) NOT NULL DEFAULT 'TEACHER',
    avatar VARCHAR(255) DEFAULT 'emoji',
    especialidades VARCHAR(500),
    sustituto_id BIGINT,
    CONSTRAINT fk_profesor_sustituto FOREIGN KEY (sustituto_id) REFERENCES profesor (id)
);

CREATE TABLE curso (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    ano_curso VARCHAR(10) NOT NULL,
    codigo_grupo VARCHAR(20),
    curso_escolar_id BIGINT NOT NULL,
    tutor_id BIGINT,
    CONSTRAINT fk_curso_escolar FOREIGN KEY (curso_escolar_id) REFERENCES curso_escolar (id),
    CONSTRAINT fk_curso_tutor FOREIGN KEY (tutor_id) REFERENCES profesor (id)
);

CREATE TABLE materia (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    horas_totales INTEGER NOT NULL,
    curso_id BIGINT NOT NULL,
    materia_plantilla_id BIGINT,
    CONSTRAINT fk_materia_curso FOREIGN KEY (curso_id) REFERENCES curso (id),
    CONSTRAINT fk_materia_plantilla FOREIGN KEY (materia_plantilla_id) REFERENCES materia_plantilla (id)
);

CREATE TABLE clase (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    dia_semana VARCHAR(15) NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    aula VARCHAR(50),
    materia_id BIGINT NOT NULL,
    profesor_id BIGINT NOT NULL,
    CONSTRAINT fk_clase_materia FOREIGN KEY (materia_id) REFERENCES materia (id),
    CONSTRAINT fk_clase_profesor FOREIGN KEY (profesor_id) REFERENCES profesor (id)
);

CREATE TABLE alumno (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    apellidos VARCHAR(150) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    estado VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    avatar VARCHAR(255) DEFAULT 'emoji',
    curso_id BIGINT NOT NULL,
    CONSTRAINT fk_alumno_curso FOREIGN KEY (curso_id) REFERENCES curso (id)
);

CREATE TABLE alumno_materia (
    alumno_id BIGINT NOT NULL,
    materia_id BIGINT NOT NULL,
    PRIMARY KEY (alumno_id, materia_id),
    CONSTRAINT fk_am_alumno FOREIGN KEY (alumno_id) REFERENCES alumno (id),
    CONSTRAINT fk_am_materia FOREIGN KEY (materia_id) REFERENCES materia (id)
);

-- 1. CONFIG
INSERT INTO configuracion_sistema (clave, valor, descripcion) VALUES
    ('provincia_festivos', 'ES-CT', 'ISO 3166-2:ES Cataluna'),
    ('nombre_centro', 'Institut Tecnologic Ponent', 'Nombre centro'),
    ('email_soporte', 'soporte@itponent.cat', 'Soporte'),
    ('ano_escolar_activo', '24/25', '24/25');

-- 2. PLANTILLAS
INSERT INTO curso_plantilla (codigo, nombre, color, tipo_materia) VALUES
    ('DAM',  'Desarrollo de Aplicaciones Multiplataforma', '#60a5fa', 'MODULOS'),
    ('DAW',  'Desarrollo de Aplicaciones Web',            '#34d399', 'MODULOS'),
    ('ASIX', 'Administracion de Sistemas Informaticos en Red', '#a78bfa', 'MODULOS'),
    ('SMIX', 'Sistemas Microinformaticos y Redes',        '#fbbf24', 'MODULOS');

-- 3. MATERIAS PLANTILLA
INSERT INTO materia_plantilla (nombre, codigo, horas_totales, curso_plantilla_id) VALUES
    ('Programacion',                           'M-UF1', 240, 1),
    ('Bases de Datos',                         'M-UF2', 180, 1),
    ('Desarrollo de Interfaces',               'M-UF3', 120, 1),
    ('Acceso a Datos',                         'M-UF4', 100, 1);

-- 4. CURSOS ESCOLARES
INSERT INTO curso_escolar (denominacion, turno, activo, curso_plantilla_id) VALUES
    ('24/25', 'MANANA', true, 1),
    ('24/25', 'TARDE',  true, 1),
    ('24/25', 'MANANA', true, 2),
    ('24/25', 'TARDE',  true, 2);

-- 5. PROFESORES
INSERT INTO profesor (nombre, apellidos, username, password, email, estado, rol, avatar, especialidades) VALUES
    ('Roberto', 'Sanchez Dominguez', 'rsanchez', '$2a$12$hqLGVpH8xZ3z8QVkO7FqD.4LmkHCZGJGvVf/xPpKYz.7DvRE/cX3O', 'rsanchez@itponent.cat', 'ACTIVO', 'ADMIN', 'admin', 'Administracion de Sistemas'),
    ('Isabel', 'Fernandez Ruiz', 'ifernandez', '$2a$12$YN3j2GKjZ9qVpQZ4FxPiUuv1FeH3FGKmQ9k0P/5rMNsEvE4XHrBW6', 'ifernandez@itponent.cat', 'ACTIVO', 'TEACHER', 'teacher', 'Programacion'),
    ('Jordi', 'Puig Casanova', 'jpuig', '$2a$12$9Xz4fHrM3K8GsJQnT2lP0OY2zMkRcNF6vIbLVd7/xEqU9CtBeFr8.', 'jpuig@itponent.cat', 'ACTIVO', 'TEACHER', 'teacher', 'Desarrollo Web');

-- 6. CURSOS REALES
INSERT INTO curso (ano_curso, codigo_grupo, curso_escolar_id, tutor_id) VALUES
    ('PRIMERO', '1DAM-M', 1, (SELECT id FROM profesor WHERE username = 'ifernandez')),
    ('SEGUNDO', '2DAM-M', 1, (SELECT id FROM profesor WHERE username = 'ifernandez')),
    ('PRIMERO', '1DAW-M', 3, (SELECT id FROM profesor WHERE username = 'jpuig'));

-- 7. MATERIAS
INSERT INTO materia (nombre, codigo, horas_totales, curso_id, materia_plantilla_id) VALUES
    ('Programacion',           'M-UF1', 240, (SELECT id FROM curso WHERE codigo_grupo = '1DAM-M'), 1),
    ('Bases de Datos',         'M-UF2', 180, (SELECT id FROM curso WHERE codigo_grupo = '1DAM-M'), 2),
    ('Desarrollo de Interfaces','M-UF3',120, (SELECT id FROM curso WHERE codigo_grupo = '1DAM-M'), 3);

-- 8. ALUMNOS
INSERT INTO alumno (nombre, apellidos, username, password, email, estado, avatar, curso_id) VALUES
    ('Carlos',   'Lopez Martinez', 'clopez', '$2a$12$mQ9KpOvXsRtNn6HcJdUmB.FkG3IuYfLwPeX7/rHtC5vNbMsDeQa2K', 'clopez@alumnat.itponent.cat', 'ACTIVO', 'student', (SELECT id FROM curso WHERE codigo_grupo = '1DAM-M')),
    ('Sofia',    'Garcia Perez',   'sgarcia', '$2a$12$aR7XnKvLsQtPm4YcHdTrE.GjF9IsZiNuQeB5/oGvD2wOcLpEfRb3J', 'sgarcia@alumnat.itponent.cat', 'ACTIVO', 'student', (SELECT id FROM curso WHERE codigo_grupo = '1DAM-M'));

-- 9. MATRICULACION
INSERT INTO alumno_materia (alumno_id, materia_id)
SELECT a.id, m.id
FROM alumno a
JOIN materia m ON m.curso_id = a.curso_id
WHERE a.curso_id = (SELECT id FROM curso WHERE codigo_grupo = '1DAM-M');
