package com.gaula.config;

import org.springframework.boot.autoconfigure.flyway.FlywayMigrationStrategy;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

/**
 * Estrategia de migración Flyway para entornos de desarrollo.
 *
 * En dev/local, llama a repair() antes de migrate() para limpiar
 * automáticamente entradas FAILED en flyway_schema_history sin
 * necesitar intervención manual tras un fallo de migración.
 *
 * NO activo en producción — en prod se requiere repair manual
 * deliberado para evitar enmascarar problemas de migración reales.
 */
@Configuration
@Profile({"dev", "local"})
public class FlywayRepairConfig {

    @Bean
    public FlywayMigrationStrategy flywayRepairStrategy() {
        return flyway -> {
            flyway.repair();
            flyway.migrate();
        };
    }
}

