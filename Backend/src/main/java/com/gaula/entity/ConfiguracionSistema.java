package com.gaula.entity;

import jakarta.persistence.*;
import lombok.*;

/**
 * ConfiguracionSistema — Pares clave-valor para la configuración global del sistema.
 *
 * Almacena configuraciones que el Administrador puede modificar desde la UI:
 *   - provincia_festivos: código ISO de la provincia/región para filtrar festivos.
 *     Ejemplo: "ES-CT" (Cataluña), "ES-MD" (Madrid), "ES-VC" (Comunidad Valenciana)
 *     Valores posibles según Nager.Date / ISO 3166-2:ES
 *   - nombre_centro: nombre del centro educativo
 *   - curso_activo_id: ID del CursoEscolar actualmente activo
 *
 * DISEÑO: Patrón clave-valor permite añadir configuraciones nuevas
 * sin modificar el esquema de BBDD.
 */
@Entity
@Table(name = "configuracion_sistema",
       uniqueConstraints = @UniqueConstraint(
           name = "uq_config_clave",
           columnNames = "clave"
       ))
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ConfiguracionSistema {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * Clave única de la configuración.
     *
     * Claves reservadas del sistema:
     *   "provincia_festivos" → código ISO de la región (ES-CT, ES-MD, ES-PV...)
     *   "nombre_centro"      → nombre del centro educativo
     *   "email_soporte"      → email de soporte técnico
     *   "ano_escolar_activo" → denominación del año escolar activo ("24/25")
     */
    @Column(nullable = false, unique = true, length = 100)
    private String clave;

    /**
     * Valor de la configuración en texto plano.
     * Ejemplo: "ES-CT", "Institut Ponent", "24/25"
     */
    @Column(nullable = false, length = 500)
    private String valor;

    /**
     * Descripción legible de esta configuración para mostrar en la UI de admin.
     * Ejemplo: "Provincia para el filtrado de festivos en el calendario"
     */
    @Column(length = 300)
    private String descripcion;

    // ────────────────────────────────────────
    // Constantes de claves de configuración
    // ────────────────────────────────────────

    /** Clave para la provincia de festivos. Valor: código ISO 3166-2:ES */
    public static final String KEY_PROVINCIA_FESTIVOS = "provincia_festivos";

    /** Clave para el nombre del centro. */
    public static final String KEY_NOMBRE_CENTRO = "nombre_centro";

    /** Clave para el año escolar activo. */
    public static final String KEY_ANO_ESCOLAR_ACTIVO = "ano_escolar_activo";

    /** Clave para el email de soporte. */
    public static final String KEY_EMAIL_SOPORTE = "email_soporte";

    /** Porcentaje máximo de faltas permitido para modalidad presencial (e.g. "20") */
    public static final String KEY_MAX_FALTAS_PRESENCIAL = "max_faltas_presencial";

    /** Porcentaje máximo de faltas permitido para modalidad semipresencial (e.g. "50") */
    public static final String KEY_MAX_FALTAS_SEMIPRESENCIAL = "max_faltas_semipresencial";

    // ────────────────────────────────────────
    // Constantes de provincias españolas ISO 3166-2:ES
    // (subset de los subdivision codes compatibles con Nager.Date)
    // ────────────────────────────────────────

    /** Cataluña — festivos como Sant Joan, Sant Esteve, La Mercè... */
    public static final String PROVINCIA_CATALUÑA      = "ES-CT";
    /** Madrid */
    public static final String PROVINCIA_MADRID         = "ES-MD";
    /** Comunitat Valenciana */
    public static final String PROVINCIA_VALENCIANA     = "ES-VC";
    /** País Vasco / Euskadi */
    public static final String PROVINCIA_PAIS_VASCO     = "ES-PV";
    /** Andalucía */
    public static final String PROVINCIA_ANDALUCIA      = "ES-AN";
    /** Galicia */
    public static final String PROVINCIA_GALICIA        = "ES-GA";
    /** Aragón */
    public static final String PROVINCIA_ARAGON         = "ES-AR";
    /** Asturias */
    public static final String PROVINCIA_ASTURIAS       = "ES-AS";
    /** Islas Baleares */
    public static final String PROVINCIA_BALEARES       = "ES-IB";
    /** Islas Canarias */
    public static final String PROVINCIA_CANARIAS       = "ES-CN";
    /** Cantabria */
    public static final String PROVINCIA_CANTABRIA      = "ES-CB";
    /** Castilla-La Mancha */
    public static final String PROVINCIA_CLM            = "ES-CM";
    /** Castilla y León */
    public static final String PROVINCIA_CYL            = "ES-CL";
    /** Extremadura */
    public static final String PROVINCIA_EXTREMADURA    = "ES-EX";
    /** La Rioja */
    public static final String PROVINCIA_RIOJA          = "ES-RI";
    /** Murcia */
    public static final String PROVINCIA_MURCIA         = "ES-MC";
    /** Navarra */
    public static final String PROVINCIA_NAVARRA        = "ES-NC";
}
