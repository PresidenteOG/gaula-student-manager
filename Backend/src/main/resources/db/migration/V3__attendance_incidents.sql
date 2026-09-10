-- V3__attendance_incidents.sql
-- Creación de tablas para persistir el control de asistencia e incidencias disciplinarias.

-- 1. Tabla de Asistencia
-- Registra si un alumno estuvo presente, ausente o llegó tarde a una clase específica.
CREATE TABLE asistencia (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    clase_id BIGINT NOT NULL,
    alumno_id BIGINT NOT NULL,
    estado ENUM('PRESENTE', 'AUSENTE', 'RETRASO', 'JUSTIFICADO') DEFAULT 'PRESENTE',
    observaciones TEXT,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_asistencia_clase FOREIGN KEY (clase_id) REFERENCES clase(id) ON DELETE CASCADE,
    CONSTRAINT fk_asistencia_alumno FOREIGN KEY (alumno_id) REFERENCES alumno(id) ON DELETE CASCADE
);

-- 2. Tabla de Incidencias
-- Registra comportamientos o sucesos relevantes protagonizados por un alumno.
CREATE TABLE incidencia (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    alumno_id BIGINT NOT NULL,
    profesor_id BIGINT NOT NULL,
    titulo VARCHAR(100) NOT NULL,
    descripcion TEXT NOT NULL,
    gravedad ENUM('LEVE', 'GRAVE', 'MUY_GRAVE') DEFAULT 'LEVE',
    estado ENUM('ABIERTA', 'EN_REVISION', 'CERRADA') DEFAULT 'ABIERTA',
    fecha_incidencia TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_incidencia_alumno FOREIGN KEY (alumno_id) REFERENCES alumno(id) ON DELETE CASCADE,
    CONSTRAINT fk_incidencia_profesor FOREIGN KEY (profesor_id) REFERENCES profesor(id) ON DELETE CASCADE
);

-- Índices para mejorar rendimiento en búsquedas comunes
CREATE INDEX idx_asistencia_clase ON asistencia(clase_id);
CREATE INDEX idx_asistencia_alumno ON asistencia(alumno_id);
CREATE INDEX idx_incidencia_alumno ON incidencia(alumno_id);
CREATE INDEX idx_incidencia_fecha ON incidencia(fecha_incidencia);
