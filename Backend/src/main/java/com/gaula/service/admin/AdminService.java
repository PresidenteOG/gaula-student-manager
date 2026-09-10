package com.gaula.service.admin;

import com.gaula.entity.Auditoria;
import com.gaula.dto.admin.UsuarioAdminDto;

import java.util.List;
import java.util.Map;

public interface AdminService {
    List<Auditoria> findAllAuditoria();
    Auditoria createAuditoria(Auditoria auditoria);
    
    Map<String, Object> getDashboardStats();
    
    void generarHorario(Long cursoId);
    
    void updateMateriaColor(Long materiaId, String color);
    
    List<UsuarioAdminDto> listarUsuarios();
    void resetPassword(Long id, String rol);
    void cambiarEstadoUsuario(Long id, String nuevoEstado, String rol);
    void eliminarUsuario(Long id, String rol);
}
