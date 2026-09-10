-- V12: Ajustes de estabilidad para Asistencia e Incidencias
-- 1. Renombrar columna fecha_sesion a fecha
ALTER TABLE asistencia CHANGE COLUMN fecha_sesion fecha DATE NOT NULL;

-- 2. Añadir estado 'FALTA' al enum de asistencia
ALTER TABLE asistencia MODIFY COLUMN estado ENUM('PRESENTE', 'AUSENTE', 'FALTA', 'RETRASO', 'JUSTIFICADO') DEFAULT 'PRESENTE';

-- 3. Hacer profesor_id opcional en incidencias para permitir reportes de alumnos
ALTER TABLE incidencia MODIFY COLUMN profesor_id BIGINT NULL;

-- 4. Sincronizar ENUMs de incidencia con los modelos de Java
ALTER TABLE incidencia MODIFY COLUMN gravedad ENUM('BAJA', 'MEDIA', 'ALTA', 'LEVE', 'GRAVE', 'MUY_GRAVE') DEFAULT 'LEVE';
ALTER TABLE incidencia MODIFY COLUMN estado ENUM('ABIERTA', 'EN_PROCESO', 'CERRADA') DEFAULT 'ABIERTA';


