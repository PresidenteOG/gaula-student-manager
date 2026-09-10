-- V14: Añadir columna fecha_registro a la tabla clase
-- La entidad Clase define @Column(name = "fecha_registro", nullable = false, updatable = false)
-- pero la columna no existe en la BD, causando SQLSyntaxErrorException en asistencia/resumen/{id}.
-- Se rellena con CURRENT_TIMESTAMP para los registros existentes (valor por defecto coherente).

ALTER TABLE clase
    ADD COLUMN fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP;
