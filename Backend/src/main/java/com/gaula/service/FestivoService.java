package com.gaula.service;

import com.gaula.dto.festivo.FestivoNagerDto;
import com.gaula.entity.ConfiguracionSistema;
import com.gaula.entity.Festivo;
import com.gaula.repository.ConfiguracionSistemaRepository;
import com.gaula.repository.FestivoRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDate;
import java.time.Year;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Servicio de festivos públicos para GAULA.
 *
 * INTEGRACIÓN CON NAGER.DATE API:
 *   URL: https://date.nager.at/api/v3/PublicHolidays/{year}/ES
 *   Devuelve todos los festivos de España (nacionales + autonómicos)
 *   para el año solicitado.
 *
 * LÓGICA DE FILTRADO POR PROVINCIA:
 *   El Administrador configura la provincia del centro en la tabla
 *   `configuracion_sistema` con clave = "provincia_festivos".
 *   Valor: código ISO 3166-2:ES → "ES-CT" (Cataluña), "ES-MD" (Madrid), etc.
 *
 *   Un festivo se incluye en la respuesta filtrada si:
 *     a) Es NACIONAL: counties == null || counties.isEmpty() || global == true
 *     b) Es AUTONÓMICO y su lista counties CONTIENE el código de provincia configurado
 *
 *   Ejemplo: si la provincia es "ES-CT" (Cataluña):
 *     ✅ "Año Nuevo" (counties=null) → nacional → se incluye
 *     ✅ "Sant Joan" (counties=["ES-CT", "ES-VC"]) → incluye ES-CT → se incluye
 *     ❌ "San Isidro" (counties=["ES-MD"]) → no incluye ES-CT → se EXCLUYE
 *
 * CACHÉ:
 *   Los festivos se cachean en memoria durante la sesión para evitar
 *   llamadas repetidas a la API externa (que es de terceros y puede tener
 *   rate limiting). Se usa Spring's simple cache (ConcurrentHashMap por defecto).
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class FestivoService {

    private final ConfiguracionSistemaRepository configRepository;
    private final FestivoRepository festivoRepository;
    private final RestTemplate restTemplate;

    @Value("${gaula.nager.base-url}")
    private String nagerBaseUrl;

    /**
     * Obtiene los festivos de España para el año dado, filtrados por
     * la provincia configurada por el Administrador.
     *
     * @param anio año para consultar festivos (si null, usa el año actual)
     * @return lista de FestivoNagerDto filtrados por provincia
     */
    @Transactional
    public List<FestivoNagerDto> obtenerFestivosFiltrados(Integer anio) {
        int yearConsulta = (anio != null) ? anio : Year.now().getValue();

        // ── 1. Intentar cargar desde caché en DB ──
        List<FestivoNagerDto> todosLosFestivos;
        if (festivoRepository.existsByAnio(yearConsulta)) {
            log.info("Cargando festivos de {} desde caché en DB", yearConsulta);
            todosLosFestivos = festivoRepository.findByAnio(yearConsulta).stream()
                .map(this::entityToDto)
                .collect(Collectors.toList());
        } else {
            // ── 2. Fetch desde Nager.Date y guardar en DB ──
            log.info("Sin caché para {}; obteniendo de Nager.Date y guardando en DB", yearConsulta);
            todosLosFestivos = obtenerTodosLosFestivosNager(yearConsulta);
            if (!todosLosFestivos.isEmpty()) {
                List<Festivo> entidades = todosLosFestivos.stream()
                    .map(dto -> dtoToEntity(dto, yearConsulta))
                    .collect(Collectors.toList());
                festivoRepository.saveAll(entidades);
                log.info("Guardados {} festivos en DB para el año {}", entidades.size(), yearConsulta);
            }
        }

        if (todosLosFestivos.isEmpty()) {
            return Collections.emptyList();
        }

        // ── 3. Leer la provincia configurada por el Administrador ──
        String provinciaConfigurada = leerProvinciaConfigurada();

        if (provinciaConfigurada == null || provinciaConfigurada.isBlank()) {
            // Si no hay provincia configurada, devolver SOLO los festivos nacionales
            log.info("Sin provincia configurada: devolviendo únicamente festivos nacionales");
            return todosLosFestivos.stream()
                .filter(this::esNacional)
                .collect(Collectors.toList());
        }

        log.info("Filtrando festivos de {} para provincia: {}", yearConsulta, provinciaConfigurada);

        // ── 4. Filtrar por provincia ──
        return todosLosFestivos.stream()
            .filter(festivo -> esFestivoParaProvincia(festivo, provinciaConfigurada))
            .collect(Collectors.toList());
    }

    /**
     * Obtiene TODOS los festivos de España sin filtrar.
     * Devuelve tanto nacionales como de todas las CCAA.
     * Útil para que el Admin vea el panorama completo antes de configurar la provincia.
     *
     * @param anio año para consultar
     * @return lista completa de festivos de España
     */
    public List<FestivoNagerDto> obtenerTodosLosFestivosNager(int anio) {
        String url = nagerBaseUrl + "/PublicHolidays/" + anio + "/ES";
        log.debug("Llamando a Nager.Date: {}", url);

        try {
            ResponseEntity<List<FestivoNagerDto>> response = restTemplate.exchange(
                url,
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<List<FestivoNagerDto>>() {}
            );

            List<FestivoNagerDto> festivos = response.getBody();
            if (festivos == null) {
                log.warn("Nager.Date devolvió una respuesta vacía para el año {}", anio);
                return Collections.emptyList();
            }

            log.info("Nager.Date devolvió {} festivos para España en {}", festivos.size(), anio);
            return festivos;

        } catch (HttpClientErrorException ex) {
            log.error("Error HTTP al llamar a Nager.Date: {} - {}", ex.getStatusCode(), ex.getMessage());
            return Collections.emptyList();
        } catch (Exception ex) {
            log.error("Error al conectar con Nager.Date: {}", ex.getMessage());
            return Collections.emptyList();
        }
    }

    /**
     * Actualiza la provincia de festivos configurada.
     * Solo puede ser llamado por el Administrador (verificado en el Controller con @PreAuthorize).
     *
     * @param codigoProvincia código ISO 3166-2:ES (ej: "ES-CT", "ES-MD")
     * @return la configuración actualizada
     */
    public ConfiguracionSistema actualizarProvincia(String codigoProvincia) {
        log.info("Administrador actualiza provincia de festivos a: {}", codigoProvincia);

        ConfiguracionSistema config = configRepository
            .findByClave(ConfiguracionSistema.KEY_PROVINCIA_FESTIVOS)
            .orElseGet(() -> ConfiguracionSistema.builder()
                .clave(ConfiguracionSistema.KEY_PROVINCIA_FESTIVOS)
                .descripcion("Código ISO 3166-2:ES de la comunidad autónoma del centro. " +
                             "Determina qué festivos autonómicos se muestran en el calendario.")
                .build()
            );

        config.setValor(codigoProvincia.trim().toUpperCase());
        return configRepository.save(config);
    }

    /**
     * Lee la provincia de festivos actualmente configurada.
     *
     * @return código ISO 3166-2:ES o null si no está configurado
     */
    public String leerProvinciaConfigurada() {
        return configRepository
            .findByClave(ConfiguracionSistema.KEY_PROVINCIA_FESTIVOS)
            .map(ConfiguracionSistema::getValor)
            .orElse(null);
    }

    /**
     * Devuelve el mapa de provincias españolas disponibles para la UI del Admin.
     * El Administrador verá un <select> con estas opciones en la pantalla de Configuración.
     *
     * @return lista de ProvinciasDto con código y nombre legible
     */
    public List<ProvinciaDto> obtenerProvinciasDisponibles() {
        return List.of(
            new ProvinciaDto(ConfiguracionSistema.PROVINCIA_CATALUÑA,   "Cataluña"),
            new ProvinciaDto(ConfiguracionSistema.PROVINCIA_MADRID,      "Madrid"),
            new ProvinciaDto(ConfiguracionSistema.PROVINCIA_VALENCIANA,  "Comunitat Valenciana"),
            new ProvinciaDto(ConfiguracionSistema.PROVINCIA_PAIS_VASCO,  "País Vasco / Euskadi"),
            new ProvinciaDto(ConfiguracionSistema.PROVINCIA_ANDALUCIA,   "Andalucía"),
            new ProvinciaDto(ConfiguracionSistema.PROVINCIA_GALICIA,     "Galicia"),
            new ProvinciaDto(ConfiguracionSistema.PROVINCIA_ARAGON,      "Aragón"),
            new ProvinciaDto(ConfiguracionSistema.PROVINCIA_ASTURIAS,    "Asturias"),
            new ProvinciaDto(ConfiguracionSistema.PROVINCIA_BALEARES,    "Islas Baleares"),
            new ProvinciaDto(ConfiguracionSistema.PROVINCIA_CANARIAS,    "Islas Canarias"),
            new ProvinciaDto(ConfiguracionSistema.PROVINCIA_CANTABRIA,   "Cantabria"),
            new ProvinciaDto(ConfiguracionSistema.PROVINCIA_CLM,         "Castilla-La Mancha"),
            new ProvinciaDto(ConfiguracionSistema.PROVINCIA_CYL,         "Castilla y León"),
            new ProvinciaDto(ConfiguracionSistema.PROVINCIA_EXTREMADURA, "Extremadura"),
            new ProvinciaDto(ConfiguracionSistema.PROVINCIA_RIOJA,       "La Rioja"),
            new ProvinciaDto(ConfiguracionSistema.PROVINCIA_MURCIA,      "Región de Murcia"),
            new ProvinciaDto(ConfiguracionSistema.PROVINCIA_NAVARRA,     "Navarra")
        );
    }

    /**
     * Elimina el caché de festivos de un año y lo re-descarga desde Nager.Date.
     * Solo puede ser llamado por el Administrador (verificado en el Controller con @PreAuthorize).
     *
     * @param anio año a sincronizar
     * @return número de festivos guardados en DB
     */
    @Transactional
    public int sincronizarFestivos(int anio) {
        log.info("Admin solicita sincronización de festivos para el año {}", anio);
        festivoRepository.deleteProvinciasByAnio(anio);
        festivoRepository.deleteByAnio(anio);

        List<FestivoNagerDto> festivos = obtenerTodosLosFestivosNager(anio);
        if (festivos.isEmpty()) {
            log.warn("Nager.Date no devolvió festivos para el año {}; caché no actualizado", anio);
            return 0;
        }

        List<Festivo> entidades = festivos.stream()
            .map(dto -> dtoToEntity(dto, anio))
            .collect(Collectors.toList());
        festivoRepository.saveAll(entidades);
        log.info("Sincronizados {} festivos para el año {}", entidades.size(), anio);
        return entidades.size();
    }

    // ──────────────────────────────────────────────────────────
    // Conversión DTO ↔ Entity
    // ──────────────────────────────────────────────────────────

    private Festivo dtoToEntity(FestivoNagerDto dto, int anio) {
        return Festivo.builder()
            .fecha(LocalDate.parse(dto.fecha()))
            .nombre(dto.nombre() != null ? dto.nombre() : dto.nombreLocal())
            .nombreLocal(dto.nombreLocal())
            .esNacional(Boolean.TRUE.equals(dto.esNacional())
                || dto.provincias() == null
                || dto.provincias().isEmpty())
            .provincias(dto.provincias())
            .anio(anio)
            .build();
    }

    private FestivoNagerDto entityToDto(Festivo entity) {
        return new FestivoNagerDto(
            entity.getFecha().toString(),
            entity.getNombreLocal(),
            entity.getNombre(),
            "ES",
            entity.getProvincias(),
            entity.isEsNacional(),
            null
        );
    }

    // ──────────────────────────────────────────────────────────
    // Métodos auxiliares (lógica de filtrado)
    // ──────────────────────────────────────────────────────────

    /**
     * Determina si un festivo es de ámbito nacional.
     * Es nacional si: counties == null, counties está vacío, o global == true.
     */
    private boolean esNacional(FestivoNagerDto festivo) {
        return Boolean.TRUE.equals(festivo.esNacional())
            || festivo.provincias() == null
            || festivo.provincias().isEmpty();
    }

    /**
     * Determina si un festivo es relevante para una provincia dada.
     * Incluye festivos nacionales + festivos autonómicos de esa provincia.
     *
     * @param festivo           festivo a evaluar
     * @param codigoProvincia   código ISO 3166-2:ES (ej: "ES-CT")
     * @return true si el festivo debe mostrarse para esa provincia
     */
    private boolean esFestivoParaProvincia(FestivoNagerDto festivo, String codigoProvincia) {
        // Festivos nacionales: siempre se incluyen
        if (esNacional(festivo)) {
            return true;
        }
        // Festivos autonómicos: incluir solo si el código de provincia coincide
        return festivo.provincias().contains(codigoProvincia);
    }

    // ──────────────────────────────────────────────────────────
    // Record auxiliar para la lista de provincias disponibles
    // ──────────────────────────────────────────────────────────

    /**
     * DTO simple para el selector de provincia en la UI de Admin:
     * { "codigo": "ES-CT", "nombre": "Cataluña" }
     */
    public record ProvinciaDto(String codigo, String nombre) {}
}
