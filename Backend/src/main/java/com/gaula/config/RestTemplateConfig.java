package com.gaula.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

/**
 * Configuración de beans de infraestructura HTTP.
 *
 * RestTemplate es el cliente HTTP síncrono de Spring.
 * Lo usamos en FestivoService para llamar a la API externa Nager.Date.
 *
 * NOTA: En proyectos más grandes con muchas llamadas externas,
 * se recomienda migrar a WebClient (reactivo), pero para esta API
 * de consulta occasional, RestTemplate es más que suficiente.
 */
@Configuration
public class RestTemplateConfig {

    /**
     * Bean de RestTemplate disponible para inyección en cualquier @Service.
     * Spring Boot NO lo registra automáticamente desde la versión 2.x.
     */
    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
}
