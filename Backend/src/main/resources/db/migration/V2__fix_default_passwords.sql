-- V2__fix_default_passwords.sql
-- Reseteo de contraseñas de demo para asegurar acceso después de la migración a Cloud.
-- Contraseña para todos estos usuarios: admin123

UPDATE profesor 
SET password = '$2a$12$N9qo8uLOickgx2ZMRZoMyeIjZAgNo3tI.E7Q42uL0D/7E64bW09be'
WHERE username IN ('rsanchez', 'ifernandez', 'jpuig');

UPDATE alumno
SET password = '$2a$12$N9qo8uLOickgx2ZMRZoMyeIjZAgNo3tI.E7Q42uL0D/7E64bW09be'
WHERE username IN ('igarcia', 'clopez', 'mrodriguez');
