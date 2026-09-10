package com.gaula.controller;

import com.gaula.domain.AnioEscolarDto;
import com.gaula.entity.*;
import com.gaula.dto.anio_escolar.CreateAnioEscolarRequest;
import com.gaula.dto.anio_escolar.UpdateAnioEscolarRequest;
import com.gaula.service.admin.AdminService;
import com.gaula.service.ano_escolar.AñoEscolarService;
import com.gaula.service.configuracion.ConfiguracionService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * Controlador REST de CursosEscolares y Configuración del sistema.
 */
@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
@Tag(name = "Administración", description = "Gestión de años escolares y configuración del sistema (solo Admin)")
public class AdminController {

    private final AñoEscolarService añoEscolarService;
    private final ConfiguracionService configuracionService;
    private final AdminService adminService;

    // ──────────── AUDITORÍA ────────────

    @GetMapping("/auditoria")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Listar registros de auditoría")
    public ResponseEntity<List<Auditoria>> findAllAuditoria() {
        return ResponseEntity.ok(adminService.findAllAuditoria());
    }

    @PostMapping("/auditoria")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Crear registro de auditoría")
    public ResponseEntity<Auditoria> createAuditoria(@RequestBody Auditoria auditoria) {
        return ResponseEntity.status(HttpStatus.CREATED).body(adminService.createAuditoria(auditoria));
    }

    // ──────────── CURSOS ESCOLARES ────────────

    @GetMapping("/anios-escolares")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER', 'STUDENT')")
    @Operation(summary = "Listar todos los años escolares")
    public ResponseEntity<List<AnioEscolarDto>> findAllEscolares(
        @RequestParam(required = false, defaultValue = "false") boolean soloActivos
    ) {
        return ResponseEntity.ok(soloActivos
            ? añoEscolarService.findActivos()
            : añoEscolarService.findAll()
        );
    }

    @GetMapping("/anios-escolares/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER', 'STUDENT')")
    @Operation(summary = "Obtener un año escolar por ID")
    public ResponseEntity<AnioEscolarDto> findEscolarById(@PathVariable Long id) {
        return ResponseEntity.ok(añoEscolarService.findById(id));
    }

    @PostMapping("/anios-escolares")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Crear un nuevo año escolar")
    public ResponseEntity<AnioEscolarDto> createEscolar(
        @Valid @RequestBody CreateAnioEscolarRequest request
    ) {
        return ResponseEntity.status(HttpStatus.CREATED).body(añoEscolarService.create(request));
    }

    @PatchMapping("/anios-escolares/{id}/activar")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Activar un año escolar (desactiva el anterior del mismo ciclo y turno)")
    public ResponseEntity<AnioEscolarDto> activarEscolar(@PathVariable Long id) {
        return ResponseEntity.ok(añoEscolarService.activar(id));
    }

    @PatchMapping("/anios-escolares/{id}/desactivar")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Desactivar un año escolar")
    public ResponseEntity<AnioEscolarDto> desactivarEscolar(@PathVariable Long id) {
        return ResponseEntity.ok(añoEscolarService.desactivar(id));
    }

    @PutMapping("/anios-escolares/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Actualizar un año escolar")
    public ResponseEntity<AnioEscolarDto> updateEscolar(
        @PathVariable Long id,
        @RequestBody UpdateAnioEscolarRequest request
    ) {
        return ResponseEntity.ok(añoEscolarService.update(id, request));
    }

    @DeleteMapping("/anios-escolares/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Eliminar un año escolar")
    public ResponseEntity<Void> deleteEscolar(@PathVariable Long id) {
        añoEscolarService.delete(id);
        return ResponseEntity.noContent().build();
    }

    // ──────────── DASHBOARD Y NOTIFICACIONES ────────────

    @GetMapping("/dashboard")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Obtener métricas para el dashboard de administración")
    public ResponseEntity<Map<String, Object>> getDashboardStats() {
        return ResponseEntity.ok(adminService.getDashboardStats());
    }

    // ──────────── HORARIOS Y GENERACIÓN ────────────

    @PostMapping("/cursos/{id}/generar-horario")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Generar un horario base automáticamente para un curso")
    public ResponseEntity<Void> generarHorario(@PathVariable Long id) {
        adminService.generarHorario(id);
        return ResponseEntity.ok().build();
    }

    @PatchMapping("/materias/{id}/color")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Actualizar el color de una materia")
    public ResponseEntity<Void> updateMateriaColor(
        @PathVariable Long id,
        @RequestParam String color
    ) {
        adminService.updateMateriaColor(id, color);
        return ResponseEntity.ok().build();
    }


    @GetMapping("/usuarios")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Listar todos los usuarios del sistema (Profesores y Alumnos)")
    public ResponseEntity<List<com.gaula.dto.admin.UsuarioAdminDto>> listarUsuarios() {
        return ResponseEntity.ok(adminService.listarUsuarios());
    }

    @PatchMapping("/usuarios/{id}/reset-password")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Resetear contraseña de un usuario a una por defecto")
    public ResponseEntity<Void> resetPassword(@PathVariable Long id, @RequestParam(required = false) String rol) {
        adminService.resetPassword(id, rol);
        return ResponseEntity.ok().build();
    }

    @PatchMapping("/usuarios/{id}/estado")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Cambiar el estado (ACTIVO/INACTIVO) de un usuario")
    public ResponseEntity<Void> cambiarEstadoUsuario(@PathVariable Long id, @RequestParam String nuevoEstado, @RequestParam(required = false) String rol) {
        adminService.cambiarEstadoUsuario(id, nuevoEstado, rol);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/usuarios/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Eliminar permanentemente un usuario")
    public ResponseEntity<Void> eliminarUsuario(@PathVariable Long id, @RequestParam(required = false) String rol) {
        adminService.eliminarUsuario(id, rol);
        return ResponseEntity.noContent().build();
    }

    // ──────────── CONFIGURACIÓN DEL SISTEMA ────────────

    @GetMapping("/configuracion")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(
        summary = "Listar toda la configuración del sistema",
        description = "Devuelve todos los pares clave-valor de configuración del sistema."
    )
    public ResponseEntity<List<ConfiguracionSistema>> findAllConfiguracion() {
        return ResponseEntity.ok(configuracionService.findAll());
    }

    @GetMapping("/configuracion/{clave}")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER', 'STUDENT')")
    @Operation(summary = "Obtener el valor de una configuración por clave")
    public ResponseEntity<Map<String, String>> getConfiguracion(@PathVariable String clave) {
        String valor = configuracionService.obtenerValor(clave).orElse(null);
        return ResponseEntity.ok(Map.of(
            "clave", clave,
            "valor", valor != null ? valor : ""
        ));
    }

    @PutMapping("/configuracion/{clave}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Crear o actualizar un valor de configuración")
    public ResponseEntity<ConfiguracionSistema> upsertConfiguracion(
        @PathVariable String clave,
        @RequestBody ConfigRequest request
    ) {
        ConfiguracionSistema guardada = configuracionService.guardar(
            clave, request.valor(), request.descripcion()
        );
        return ResponseEntity.ok(guardada);
    }

    @DeleteMapping("/configuracion/{clave}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Eliminar una configuración")
    public ResponseEntity<Void> deleteConfiguracion(@PathVariable String clave) {
        configuracionService.eliminar(clave);
        return ResponseEntity.noContent().build();
    }

    public record ConfigRequest(String valor, String descripcion) {}
}
