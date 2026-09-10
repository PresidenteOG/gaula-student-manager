-- V9: Seguimiento de actividad de usuarios
-- Autor: Antigravity-Dynamic
-- Objetivo: Blindar la trazabilidad de accesos.

-- 1. Añadir campos de seguimiento a la tabla de profesores (incluye administradores)
ALTER TABLE profesor
ADD COLUMN fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN ultima_conexion TIMESTAMP NULL,
ADD COLUMN ip_conexion VARCHAR(45) NULL,
ADD COLUMN ultimo_jwt TEXT NULL;

-- 2. Añadir campos de seguimiento a la tabla de alumnos
ALTER TABLE alumno
ADD COLUMN fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN ultima_conexion TIMESTAMP NULL,
ADD COLUMN ip_conexion VARCHAR(45) NULL,
ADD COLUMN ultimo_jwt TEXT NULL;
