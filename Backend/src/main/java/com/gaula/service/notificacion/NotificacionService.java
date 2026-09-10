package com.gaula.service.notificacion;

import com.gaula.dto.common.NotificationDto;
import com.gaula.security.UserDetailsServiceImpl;

import java.util.List;

/**
 * Contrato del servicio de Cursos (grupos clase instanciados).
 */
public interface NotificacionService {

    List<NotificationDto> getNotificaciones(UserDetailsServiceImpl.GaulaUserPrincipal principal);

    void deleteNotificacion(Long id);

    void patchNotificacionesLeidasAll(UserDetailsServiceImpl.GaulaUserPrincipal principal);
}
