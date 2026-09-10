-- ══════════════════════════════════════════════════════════════════════════
-- V6__fix_admin_password_cloud.sql
-- ══════════════════════════════════════════════════════════════════════════

-- Forzar la contraseña admin123 para el usuario admin
UPDATE profesor 
SET password = '$2a$12$N9qo8uLOickgx2ZMRZoMyeIjZAgNo3tI.E7Q42uL0D/7E64bW09be'
WHERE username = 'admin';
