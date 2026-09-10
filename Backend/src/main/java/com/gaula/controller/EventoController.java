package com.gaula.controller;

import com.gaula.entity.Evento;
import com.gaula.service.evento.EventoService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/eventos")
@RequiredArgsConstructor
@Tag(name = "Eventos", description = "Gestión de eventos del calendario (exámenes, festivos)")
public class EventoController {

    private final EventoService eventoService;

    @GetMapping
    @Operation(summary = "Listar eventos globales y de un curso específico")
    public ResponseEntity<List<Evento>> findAll(@RequestParam(required = false) Long cursoId) {
        if (cursoId != null) {
            return ResponseEntity.ok(eventoService.findByCursoId(cursoId));
        }
        return ResponseEntity.ok(eventoService.findAll());
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN')")
    @Operation(summary = "Crear un nuevo evento")
    public ResponseEntity<Evento> create(@RequestBody EventoRequest request) {
        return ResponseEntity.ok(eventoService.create(request));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN')")
    @Operation(summary = "Eliminar un evento")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        eventoService.delete(id);
        return ResponseEntity.noContent().build();
    }

    public record EventoRequest(String titulo, String descripcion, String fecha, String tipo, Long cursoId) {}
}
