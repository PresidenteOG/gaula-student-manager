-- Actualizar estados existentes si los hay (RESUELTA -> CERRADA)
UPDATE incidencia SET estado = 'CERRADA' WHERE estado = 'RESUELTA';

-- Añadir columna resolucion
ALTER TABLE incidencia ADD COLUMN resolucion VARCHAR(20);
