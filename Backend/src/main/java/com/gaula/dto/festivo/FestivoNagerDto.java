package com.gaula.dto.festivo;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

/**
 * DTO que representa un festivo público de la API Nager.Date.
 * URL del endpoint: GET https://date.nager.at/api/v3/PublicHolidays/{year}/ES
 *
 * Respuesta ejemplo de Nager.Date para España:
 * {
 *   "date": "2025-01-01",
 *   "localName": "Año Nuevo",
 *   "name": "New Year's Day",
 *   "countryCode": "ES",
 *   "fixed": true,
 *   "global": true,
 *   "counties": null,          ← null = festivo nacional (todas las CCAA)
 *   "launchYear": null,
 *   "types": ["Public"]
 * }
 *
 * Para festivos autonómicos, `counties` contiene los códigos ISO 3166-2:ES:
 * {
 *   "date": "2025-06-24",
 *   "localName": "Sant Joan",
 *   "counties": ["ES-CT", "ES-VC", "ES-IB"],  ← solo Cataluña, Valencia, Baleares
 *   "global": false,
 *   ...
 * }
 *
 * LÓGICA DE FILTRADO (aplicada en FestivoService):
 *   Si `counties` es null → festivo nacional → se muestra siempre
 *   Si `counties` contiene el código de provincia configurado → se muestra
 *   Si `counties` NO contiene el código de provincia → se OCULTA
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public record FestivoNagerDto(

    /** Fecha del festivo en formato ISO-8601: "2025-04-18" */
    @JsonProperty("date")
    String fecha,

    /** Nombre local del festivo en el idioma del país. Ej: "Viernes Santo" */
    @JsonProperty("localName")
    String nombreLocal,

    /** Nombre en inglés del festivo. */
    @JsonProperty("name")
    String nombre,

    /** Código de país ISO 3166-1 alpha-2. Siempre "ES" para España. */
    @JsonProperty("countryCode")
    String codigoPais,

    /**
     * Lista de códigos de subdivisión (comunidades autónomas) ISO 3166-2:ES.
     * NULL → festivo de ámbito nacional (todas las CCAA).
     * Non-null → festivo solo para esas CCAA.
     * Ejemplos: ["ES-CT"] para Cataluña, ["ES-PV"] para País Vasco.
     */
    @JsonProperty("counties")
    List<String> provincias,

    /**
     * true si el festivo es de ámbito nacional (equivale a counties = null).
     * Usado como campo de apoyo para la lógica de filtrado.
     */
    @JsonProperty("global")
    Boolean esNacional,

    /** Tipos de festivo: "Public", "Bank", "Optional", "Observance" */
    @JsonProperty("types")
    List<String> tipos
) {}
