-- V16: Añade información de contacto al profesor (espejo de V5 para alumno).
-- Permite que profesores/admins editen su perfil con los mismos campos que los alumnos.
ALTER TABLE profesor ADD COLUMN dni VARCHAR(20);
ALTER TABLE profesor ADD COLUMN telefono VARCHAR(20);
ALTER TABLE profesor ADD COLUMN direccion VARCHAR(255);
ALTER TABLE profesor ADD COLUMN fecha_nacimiento DATE;
