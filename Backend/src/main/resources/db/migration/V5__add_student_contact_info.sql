-- ══════════════════════════════════════════════════════════════════════════
-- V5__add_student_contact_info.sql
-- ══════════════════════════════════════════════════════════════════════════

ALTER TABLE alumno ADD COLUMN dni VARCHAR(20);
ALTER TABLE alumno ADD COLUMN telefono VARCHAR(20);
ALTER TABLE alumno ADD COLUMN direccion VARCHAR(255);
ALTER TABLE alumno ADD COLUMN fecha_nacimiento DATE;
