-- V13__festivo_cache.sql
-- Tabla de caché de festivos obtenidos de Nager.Date.
-- Evita llamadas externas repetidas: se carga una vez por año y se consulta localmente.
-- IF NOT EXISTS: safe para reintentar tras fallo parcial de esta misma migración.

CREATE TABLE IF NOT EXISTS festivo (
    id       BIGINT AUTO_INCREMENT PRIMARY KEY,
    fecha    DATE         NOT NULL,
    nombre   VARCHAR(200) NOT NULL,
    nombre_local VARCHAR(200),
    es_nacional  BOOLEAN  NOT NULL DEFAULT FALSE,
    anio     INT          NOT NULL,

    CONSTRAINT uq_festivo_fecha_nombre UNIQUE (fecha, nombre)
);

-- Tabla de provincias vinculadas a cada festivo (festivos autonómicos).
-- PK compuesta requerida por sql_require_primary_key.
CREATE TABLE IF NOT EXISTS festivo_provincia (
    festivo_id       BIGINT      NOT NULL,
    provincia_codigo VARCHAR(10) NOT NULL,

    PRIMARY KEY (festivo_id, provincia_codigo),
    CONSTRAINT fk_festivo_provincia FOREIGN KEY (festivo_id) REFERENCES festivo(id) ON DELETE CASCADE
);

CREATE INDEX idx_festivo_anio ON festivo(anio);
