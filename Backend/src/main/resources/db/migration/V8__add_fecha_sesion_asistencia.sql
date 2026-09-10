-- V8: Añadir columna fecha_sesion a la tabla asistencia para soportar historial de clases
ALTER TABLE asistencia ADD COLUMN fecha_sesion DATE;

-- Inicializar la columna con la parte de fecha del registro actual
UPDATE asistencia SET fecha_sesion = DATE(fecha_registro) WHERE fecha_sesion IS NULL;

-- Hacerla NOT NULL después de poblarla
ALTER TABLE asistencia MODIFY COLUMN fecha_sesion DATE NOT NULL;
