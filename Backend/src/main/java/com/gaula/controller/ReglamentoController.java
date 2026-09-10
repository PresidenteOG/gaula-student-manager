package com.gaula.controller;

import com.gaula.entity.Reglamento;
import com.gaula.service.reglamento.ReglamentoService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;

@RestController
@RequestMapping("/api/reglamento")
@RequiredArgsConstructor
@Tag(name = "Reglamento", description = "Gestión del reglamento del centro")
public class ReglamentoController {

    private final ReglamentoService reglamentoService;

    @GetMapping("/activo")
    @Operation(summary = "Obtener el reglamento activo")
    public ResponseEntity<Reglamento> findActive() {
        return reglamentoService.findActivo()
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/historial")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Obtener historial de versiones (Solo Admin)")
    public ResponseEntity<List<Reglamento>> findAll() {
        return ResponseEntity.ok(reglamentoService.findAll());
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Crear nueva versión del reglamento")
    public ResponseEntity<Reglamento> create(@RequestBody Reglamento request, Principal principal) {
        return ResponseEntity.ok(reglamentoService.create(request, principal));
    }

    @PatchMapping("/{id}/activar")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Activar una versión específica")
    public ResponseEntity<Reglamento> activate(@PathVariable Long id) {
        return reglamentoService.activar(id)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }
}
