package com.gaula.controller;

import com.gaula.dto.common.NotificationDto;
import com.gaula.security.UserDetailsServiceImpl.GaulaUserPrincipal;
import com.gaula.service.notificacion.NotificacionService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/notificaciones")
@RequiredArgsConstructor
@Tag(name = "Notificaciones", description = "Gestión de notificaciones de usuario")
public class NotificacionController {

    private final NotificacionService notifService;


    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Obtener notificaciones (incidencias abiertas)")
    public ResponseEntity<List<NotificationDto>> getNotificaciones(
        @AuthenticationPrincipal GaulaUserPrincipal principal
    ) {
        return ResponseEntity.ok(notifService.getNotificaciones(principal));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Eliminar/Marcar como leída una notificación")
    public ResponseEntity<Void> deleteNotificacion(@PathVariable Long id) {
        notifService.deleteNotificacion(id);
        return ResponseEntity.ok().build();
    }

    @PatchMapping("/{id}/read")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Marcar notificación como leída")
    public ResponseEntity<Void> patchNotificacionLeida(@PathVariable Long id) {
        return deleteNotificacion(id);
    }

    @PatchMapping("/read-all")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Marcar todas las notificaciones como leídas")
    public ResponseEntity<Void> patchNotificacionesLeidasAll(
        @AuthenticationPrincipal GaulaUserPrincipal principal
    ) {
        notifService.patchNotificacionesLeidasAll(principal);
        return ResponseEntity.ok().build();
    }
}
