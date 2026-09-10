-- ══════════════════════════════════════════════════════════════════════════
-- V2__standard_admin.sql
-- ══════════════════════════════════════════════════════════════════════════

-- Insertar usuario admin maestro si no existe
-- Password: admin123 (BCrypt $2a$12$8.UnVuG9HHgffUDAlk8q7uy5Ak6AZHOnIZ6L.x7.6YmS6KY8)
INSERT INTO profesor (nombre, apellidos, username, password, email, estado, rol, avatar, especialidades)
SELECT 'Admin', 'Sistema', 'admin', '$2a$10$8.UnVuG9HHgffUDAlk8q7uy5Ak6AZHOnIZ6L.x7.6YmS6KY8', 'admin@gaula.es', 'ACTIVO', 'ADMIN', 'admin', 'Administración General'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM profesor WHERE username = 'admin');
