package com.gaula.controller;

import com.gaula.dto.festivo.FestivoNagerDto;
import com.gaula.service.FestivoService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * Controlador de festivos públicos con filtrado por provincia.
 *
 * ENDPOINTS:
 *   GET  /api/festivos                       → festivos filtrados por la provincia configurada
 *   GET  /api/festivos?anio=2025             → festivos filtrados de un año concreto
 *   GET  /api/festivos/todos                 → todos los festivos de España sin filtrar (solo Admin)
 *   GET  /api/festivos/provincias            → lista de provincias disponibles
 *   PUT  /api/festivos/provincia/{codigo}    → Admin actualiza la provincia configurada
 *   GET  /api/festivos/provincia-actual      → devuelve la provincia actualmente configurada
 */
@RestController
@RequestMapping("/api/festivos")
@RequiredArgsConstructor
@Tag(name = "Festivos", description = "Festivos públicos de España filtrados por provincia autonómica")
public class FestivoController {

    private final FestivoService festivoService;

    /**
     * Devuelve los festivos de España para el año dado,
     * filtrados por la provincia configurada por el Administrador.
     *
     * Incluye:
     *   - Festivos nacionales (scope: toda España)
     *   - Festivos de la comunidad autónoma del centro
     * Excluye:
     *   - Festivos de otras comunidades autónomas
     *
     * @param anio año a consultar (por defecto: año actual)
     * @return lista de festivos relevantes para el calendario
     */
    @GetMapping
    @PreAuthorize("isAuthenticated()")
    @Operation(
        summary = "Obtener festivos filtrados por provincia",
        description = "Devuelve los festivos nacionales + los de la comunidad autónoma configurada. " +
                      "Si no hay provincia configurada, devuelve solo los nacionales."
    )
    public ResponseEntity<List<FestivoNagerDto>> obtenerFestivosFiltrados(
        @Parameter(description = "Año a consultar (ej: 2025). Por defecto: año actual.")
        @RequestParam(required = false) Integer anio
    ) {
        List<FestivoNagerDto> festivos = festivoService.obtenerFestivosFiltrados(anio);
        return ResponseEntity.ok(festivos);
    }

    /**
     * Devuelve TODOS los festivos de España sin filtrar.
     * Solo el Administrador puede ver el panorama completo de todas las CCAA.
     *
     * @param anio año a consultar
     * @return todos los festivos de España (nacionales + todas las CCAA)
     */
    @GetMapping("/todos")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(
        summary = "Obtener TODOS los festivos de España (Admin)",
        description = "Lista todos los festivos de España sin filtrar por provincia. " +
                      "Incluye festivos de todas las comunidades autónomas. Solo para Administradores."
    )
    public ResponseEntity<List<FestivoNagerDto>> obtenerTodosLosFestivos(
        @RequestParam(required = false, defaultValue = "0") int anio
    ) {
        int yearConsulta = (anio == 0) ? java.time.Year.now().getValue() : anio;
        List<FestivoNagerDto> festivos = festivoService.obtenerTodosLosFestivosNager(yearConsulta);
        return ResponseEntity.ok(festivos);
    }

    /**
     * Devuelve la lista completa de provincias españolas disponibles
     * para que el Administrador pueda seleccionar su región.
     * Esta lista se usa para poblar el <select> de la pantalla de Configuración.
     *
     * @return lista de ProvinciaDto con { codigo, nombre }
     */
    @GetMapping("/provincias")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(
        summary = "Listar provincias configurables (Admin)",
        description = "Devuelve todas las comunidades autónomas de España con su código ISO 3166-2:ES. " +
                      "Usado para el selector de provincia en la pantalla de Configuración del Administrador."
    )
    public ResponseEntity<List<FestivoService.ProvinciaDto>> obtenerProvincias() {
        return ResponseEntity.ok(festivoService.obtenerProvinciasDisponibles());
    }

    /**
     * Devuelve la provincia actualmente configurada.
     *
     * @return código ISO 3166-2:ES de la provincia actual, o null si no hay configurada
     */
    @GetMapping("/provincia-actual")
    @PreAuthorize("isAuthenticated()")
    @Operation(
        summary = "Obtener la provincia actualmente configurada",
        description = "Devuelve el código ISO de la comunidad autónoma del centro para el filtrado de festivos."
    )
    public ResponseEntity<ProvinciaActualResponse> obtenerProvinciaActual() {
        String provincia = festivoService.leerProvinciaConfigurada();
        return ResponseEntity.ok(new ProvinciaActualResponse(provincia));
    }

    /**
     * Permite al Administrador cambiar la provincia de festivos.
     * Inmediatamente afecta al calendario de todos los usuarios:
     * los festivos mostrados cambian según la nueva provincia.
     *
     * @param codigoProvincia código ISO 3166-2:ES (ej: "ES-CT", "ES-MD")
     * @return 200 OK con la configuración actualizada
     */
    @PutMapping("/provincia/{codigoProvincia}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(
        summary = "Cambiar la provincia de festivos (Admin)",
        description = "Actualiza la comunidad autónoma del centro. A partir de este cambio, " +
                      "todos los usuarios verán los festivos de la nueva provincia en su calendario. " +
                      "Código ejemplo: ES-CT (Cataluña), ES-MD (Madrid), ES-PV (País Vasco)."
    )
    public ResponseEntity<ProvinciaActualResponse> actualizarProvincia(
        @Parameter(description = "Código ISO 3166-2:ES de la comunidad autónoma. Ej: ES-CT")
        @PathVariable String codigoProvincia
    ) {
        // Validar formato del código (ES-XX)
        if (!codigoProvincia.matches("^ES-[A-Z]{2}$")) {
            return ResponseEntity.badRequest().build();
        }
        festivoService.actualizarProvincia(codigoProvincia);
        return ResponseEntity.ok(new ProvinciaActualResponse(codigoProvincia));
    }

    /**
     * Fuerza la re-sincronización del caché de festivos para un año concreto.
     * Borra los festivos del año de la DB y los vuelve a descargar desde Nager.Date.
     *
     * @param anio año a sincronizar
     * @return 200 OK con mensaje y total de festivos sincronizados
     */
    @PostMapping("/sync/{anio}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(
        summary = "Sincronizar festivos desde Nager.Date (Admin)",
        description = "Elimina el caché de festivos del año indicado y lo repopula desde la API de Nager.Date. " +
                      "Útil para actualizar los datos tras cambios en la fuente externa."
    )
    public ResponseEntity<Map<String, Object>> sincronizarFestivos(
        @Parameter(description = "Año a sincronizar. Ej: 2025")
        @PathVariable int anio
    ) {
        int count = festivoService.sincronizarFestivos(anio);
        return ResponseEntity.ok(Map.of(
            "mensaje", "Sincronizados " + count + " festivos",
            "anio", anio,
            "total", count
        ));
    }

    // ────────────────────────────────────────
    // Record auxiliar para la respuesta de provincia actual
    // ────────────────────────────────────────

    /**
     * DTO de respuesta simple para la provincia configurada.
     * { "codigoProvincia": "ES-CT" }
     */
    public record ProvinciaActualResponse(String codigoProvincia) {}
}
